import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boat_player/components/backgrounds/marine_background.dart';
import 'package:boat_player/components/playlist_bottom_sheet.dart';
import 'package:boat_player/providers/player_provider.dart';
import 'package:boat_player/utils/download_manager.dart';

class MusicPlayerPage extends ConsumerStatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  ConsumerState<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends ConsumerState<MusicPlayerPage> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _isDownloaded = false;
  String? _checkedBvid;

  String _fixUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
  }

  void _startDownload() async {
    final controller = ref.read(playerControllerProvider.notifier);
    final player = ref.read(playerControllerProvider);
    final video = player.currentVideo;
    if (video == null) return;
    if (_isDownloaded) return;
    
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      await controller.downloadCurrentAudio((received, total) {
        if (mounted && total > 0) {
          setState(() {
            _downloadProgress = received / total;
          });
        }
      });

      final downloaded = await DownloadManager().hasFile(video.bvid);
      if (mounted) {
        setState(() {
          _isDownloaded = downloaded;
          _checkedBvid = video.bvid;
        });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('下载完成!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _refreshDownloadedStatus(String bvid) async {
    final downloaded = await DownloadManager().hasFile(bvid);
    if (!mounted) return;
    if (_checkedBvid != bvid) return;
    setState(() {
      _isDownloaded = downloaded;
    });
  }

  void _showPlaylist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => const PlaylistBottomSheet(),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }

  IconData _getPlayModeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.loop:
        return Icons.repeat_rounded;
      case PlayMode.single:
        return Icons.repeat_one_rounded;
      case PlayMode.random:
        return Icons.shuffle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(playerControllerProvider.notifier);
    final player = ref.watch(playerControllerProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: MarineBackground(key: ValueKey('marine_bg_player')),
          ),
          
          // Content
          SafeArea(
            child: Builder(
              builder: (context) {
                final video = player.currentVideo;
                if (video == null) return const Center(child: Text('No media'));

                if (_checkedBvid != video.bvid) {
                  _checkedBvid = video.bvid;
                  _isDownloaded = false;
                  _refreshDownloadedStatus(video.bvid);
                }

                return Column(
                  children: [
                    const Spacer(),
                    // Album Art
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              _fixUrl(video.pic),
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                color: Colors.white10,
                                child: const Icon(Icons.music_note, size: 80, color: Colors.white30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title & Author
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            video.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video.author,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Progress Bar
                    Builder(
                      builder: (context) {
                        final position =
                            ref.watch(playerPositionProvider).value ??
                            Duration.zero;
                        final duration =
                            ref.watch(playerDurationProvider).value ??
                            Duration.zero;

                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.orangeAccent,
                                inactiveTrackColor: Colors.white24,
                                thumbColor: Colors.white,
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                              ),
                              child: Slider(
                                value: position.inSeconds
                                    .toDouble()
                                    .clamp(0, duration.inSeconds.toDouble()),
                                max: duration.inSeconds.toDouble() > 0
                                    ? duration.inSeconds.toDouble()
                                    : 1,
                                onChanged: (value) {
                                  controller.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.skip_previous_rounded, color: Colors.white),
                          onPressed: player.currentIndex > 0 ? controller.previous : null,
                        ),
                        StreamBuilder<bool>(
                          stream: ref
                              .watch(audioHandlerProvider)
                              .playbackState
                              .map((s) => s.playing),
                          builder: (context, snapshot) {
                            final playing = snapshot.data ?? false;
                            if (player.isLoading) {
                              return const SizedBox(
                                width: 80,
                                height: 80,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                ),
                              );
                            }
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  )
                                ]
                              ),
                              child: IconButton(
                                iconSize: 40,
                                icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                                onPressed: playing ? controller.pause : controller.play,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
                          onPressed: player.currentIndex < player.playlist.length - 1 
                              ? controller.next 
                              : null,
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Bottom Actions
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              _getPlayModeIcon(player.playMode),
                              color: Colors.white70,
                              size: 28,
                            ),
                            onPressed: controller.togglePlayMode,
                            tooltip: 'Switch Play Mode',
                          ),
                          IconButton(
                            icon: const Icon(Icons.queue_music_rounded, color: Colors.white70, size: 28),
                            onPressed: () => _showPlaylist(context),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isDownloaded
                                      ? Icons.download_done
                                      : (_isDownloading ? Icons.downloading_rounded : Icons.download_rounded),
                                  color: _isDownloaded
                                      ? Colors.lightGreenAccent
                                      : (_isDownloading ? Colors.orangeAccent : Colors.white70),
                                  size: 28,
                                ),
                                onPressed: (_isDownloading || _isDownloaded) ? null : _startDownload,
                              ),
                              if (_isDownloading && !_isDownloaded)
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CircularProgressIndicator(
                                    value: _downloadProgress,
                                    strokeWidth: 2,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
