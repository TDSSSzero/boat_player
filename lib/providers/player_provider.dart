import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:boat_player/utils/boat_log.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/bilibili_client.dart';
import '../models/video_item.dart';
import '../services/boat_audio_handler.dart';
import '../utils/download_manager.dart';

part 'player_provider.freezed.dart';
part 'player_provider.g.dart';

enum PlayMode {
  loop,
  single,
  random,
}

@freezed
abstract class PlayerControllerState with _$PlayerControllerState {
  const factory PlayerControllerState({
    @Default(<VideoItem>[]) List<VideoItem> playlist,
    @Default(-1) int currentIndex,
    VideoItem? currentVideo,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(PlayMode.loop) PlayMode playMode,
    @Default(false) bool isPlaying,
  }) = _PlayerControllerState;
}

@Riverpod(keepAlive: true)
BoatAudioHandler audioHandler(Ref ref) {
  throw UnimplementedError('audioHandlerProvider must be overridden');
}

@riverpod
Stream<Duration> playerPosition(Ref ref) {
  return AudioService.position;
}

@riverpod
Stream<Duration?> playerDuration(Ref ref) {
  return ref.watch(audioHandlerProvider).mediaItem.map((item) => item?.duration);
}

@Riverpod(keepAlive: true)
class PlayerController extends _$PlayerController {
  final BilibiliClient _client = BilibiliClient();
  final DownloadManager _downloadManager = DownloadManager();
  final Random _random = Random();

  int _loadToken = 0;

  BoatAudioHandler get _audioHandler => ref.read(audioHandlerProvider);

  @override
  PlayerControllerState build() {
    _init();
    return const PlayerControllerState();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    final sub = _audioHandler.playbackState.listen((s) {
      vlog('provider listen: ${s.processingState}');
      if (s.processingState == AudioProcessingState.completed && !state.isLoading) {
        next(userTapped: false);
      }

      if (state.isPlaying != s.playing) {
        state = state.copyWith(isPlaying: s.playing);
      }
    });
    ref.onDispose(sub.cancel);

    _audioHandler.onSkipToNext = () => next(userTapped: true);
    _audioHandler.onSkipToPrevious = () => previous();
    ref.onDispose(() {
      _audioHandler.onSkipToNext = null;
      _audioHandler.onSkipToPrevious = null;
    });
  }

  void togglePlayMode() {
    final nextMode = switch (state.playMode) {
      PlayMode.loop => PlayMode.single,
      PlayMode.single => PlayMode.random,
      PlayMode.random => PlayMode.loop,
    };
    state = state.copyWith(playMode: nextMode);
  }

  void setPlaylist(List<VideoItem> videos) {
    final nextIndex = state.currentIndex;
    final shouldReset = nextIndex < 0 || nextIndex >= videos.length;
    state = state.copyWith(
      playlist: videos,
      currentIndex: shouldReset ? -1 : nextIndex,
      currentVideo: shouldReset ? null : videos[nextIndex],
    );
  }

  Future<void> playAtIndex(int index) async {
    final playlist = state.playlist;
    if (index < 0 || index >= playlist.length) return;

    final video = playlist[index];
    state = state.copyWith(
      currentIndex: index,
      currentVideo: video,
      isLoading: true,
      errorMessage: null,
    );

    // 1. 生成新的加载令牌
    _loadToken++;
    final currentToken = _loadToken;

    try {
      await _audioHandler.stop();
      // 检查令牌是否过期
      if (currentToken != _loadToken) return;

      final item = MediaItem(
        id: video.bvid,
        album: 'Bilibili',
        title: video.title,
        artist: video.author,
        artUri: Uri.parse(
          video.pic.startsWith('//') ? 'https:${video.pic}' : video.pic,
        ),
        duration: null,
      );

      await _audioHandler.updateMediaItem(item);

      // 1. Check local cache first
      if (await _downloadManager.hasFile(video.bvid)) {
        final path = await _downloadManager.getFilePath(video.bvid);
        if (currentToken != _loadToken) return;

        final duration =
            await _audioHandler.setAudioSource(AudioSource.file(path, tag: video));
        if (currentToken != _loadToken) return;

        if (duration != null) {
          await _audioHandler.updateMediaItem(item.copyWith(duration: duration));
        }

        unawaited(_audioHandler.play());
        return;
      }

      final detail = await _client.getWebInterfaceView(bvid: video.bvid);
      if (currentToken != _loadToken) return;

      final playUrlRes = await _client.getPlayerPlayUrl(
        bvid: video.bvid,
        cid: detail.cid,
      );
      if (currentToken != _loadToken) return;

      if (playUrlRes.audioStreams.isEmpty) {
        throw Exception('No audio stream found');
      }

      final audioUrl = playUrlRes.audioStreams.first.baseUrl;
      final duration = await _audioHandler.setAudioSource(
        AudioSource.uri(
          Uri.parse(audioUrl),
          headers: {
            'Referer': 'https://www.bilibili.com/',
            'User-Agent':
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Cookie': BilibiliClient.cookie,
          },
          tag: video,
        ),
      );

      if (currentToken != _loadToken) return;

      if (duration != null) {
        await _audioHandler.updateMediaItem(item.copyWith(duration: duration));
      }
      unawaited(_audioHandler.play());
    } catch (e) {
      if (currentToken != _loadToken) {
        debugPrint('Ignored error from stale task: $e');
        return;
      }

      if (e.toString().contains('Loading interrupted') ||
          e.toString().contains('AbortError')) {
        debugPrint('Ignored loading interruption: $e');
        return;
      }

      state = state.copyWith(errorMessage: e.toString());
      debugPrint('Error playing video: $e');
    } finally {
      if (currentToken == _loadToken) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> play() async {
    await _audioHandler.play();
  }

  Future<void> pause() async {
    await _audioHandler.pause();
  }

  Future<void> next({bool userTapped = true}) async {
    final playlist = state.playlist;
    if (playlist.isEmpty) return;

    final currentIndex = state.currentIndex;
    final nextIndex = userTapped
        ? (state.playMode == PlayMode.random
            ? _getRandomIndex(playlist.length, currentIndex)
            : (currentIndex + 1) % playlist.length)
        : switch (state.playMode) {
            PlayMode.single => currentIndex,
            PlayMode.random => _getRandomIndex(playlist.length, currentIndex),
            PlayMode.loop => (currentIndex + 1) % playlist.length,
          };

    await playAtIndex(nextIndex);
  }

  Future<void> previous() async {
    final playlist = state.playlist;
    if (playlist.isEmpty) return;

    final currentIndex = state.currentIndex;
    final prevIndex = state.playMode == PlayMode.random
        ? _getRandomIndex(playlist.length, currentIndex)
        : (currentIndex - 1 + playlist.length) % playlist.length;
    await playAtIndex(prevIndex);
  }

  int _getRandomIndex(int length, int currentIndex) {
    if (length <= 1) return 0;
    int newIndex;
    do {
      newIndex = _random.nextInt(length);
    } while (newIndex == currentIndex);
    return newIndex;
  }

  Future<void> seek(Duration position) async {
    await _audioHandler.seek(position);
  }

  Future<void> downloadCurrentAudio(
    void Function(int received, int total) onProgress,
  ) async {
    final video = state.currentVideo;
    if (video == null) return;

    final detail = await _client.getWebInterfaceView(bvid: video.bvid);
    final playUrlRes = await _client.getPlayerPlayUrl(
      bvid: video.bvid,
      cid: detail.cid,
    );

    if (playUrlRes.audioStreams.isEmpty) throw Exception('No audio stream');
    final url = playUrlRes.audioStreams.first.baseUrl;

    await _downloadManager.downloadAudio(
      video: video,
      url: url,
      onProgress: onProgress,
    );
  }
}
