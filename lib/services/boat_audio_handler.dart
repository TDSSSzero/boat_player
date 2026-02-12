import 'package:audio_service/audio_service.dart';
import 'package:boat_player/utils/boat_log.dart';
import 'package:just_audio/just_audio.dart';

class BoatAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player;

  BoatAudioHandler(this._player) {
    _init();
  }

  void _init() {
    // 监听播放状态并更新 playbackState
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    vlog('player isPlayer: ${_player.playing}');
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  // 暴露给外部设置 MediaItem
  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
  }

  Future<Duration?> setAudioSource(AudioSource source) {
    return _player.setAudioSource(source);
  }

  // 实现 play 方法
  @override
  Future<void> play() => _player.play();

  // 实现 pause 方法
  @override
  Future<void> pause() => _player.pause();

  // 实现 stop 方法
  @override
  Future<void> stop() => _player.stop();

  // 实现 seek 方法
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);
      // 临时方案：定义回调函数
  Future<void> Function()? onSkipToNext;
  Future<void> Function()? onSkipToPrevious;

  @override
  Future<void> skipToNext() async {
    if (onSkipToNext != null) {
      await onSkipToNext!();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (onSkipToPrevious != null) {
      await onSkipToPrevious!();
    }
  }
}
