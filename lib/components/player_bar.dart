import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';
import 'playlist_bottom_sheet.dart';
import '../pages/player/music_player_page.dart';

class PlayerBar extends ConsumerStatefulWidget {
  const PlayerBar({super.key});

  @override
  ConsumerState<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends ConsumerState<PlayerBar> {
  String _fixUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
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

  IconData _getPlayModeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.loop:
        return Icons.repeat;
      case PlayMode.single:
        return Icons.repeat_one;
      case PlayMode.random:
        return Icons.shuffle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerControllerProvider);
    final video = player.currentVideo;
        if (video == null) return const SizedBox.shrink();

        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MusicPlayerPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      // Row 1: Song Info
                      Row(
                        children: [
                          // Album Art
                          Hero(
                            tag: 'album_art_${video.bvid}',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _fixUrl(video.pic),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    width: 48,
                                    height: 48,
                                    color: colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.music_note,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title & Artist
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  video.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),

                      // Progress Bar (Moved here)
                      Builder(
                        builder: (context) {
                          final position =
                              ref.watch(playerPositionProvider).value ??
                              Duration.zero;
                          final duration =
                              ref.watch(playerDurationProvider).value ??
                              Duration.zero;

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: duration.inMilliseconds > 0
                                  ? position.inMilliseconds /
                                      duration.inMilliseconds
                                  : 0.0,
                              minHeight: 4,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Row 2: Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              _getPlayModeIcon(player.playMode),
                              size: 22,
                            ),
                            onPressed: ref.read(playerControllerProvider.notifier).togglePlayMode,
                            tooltip: '切换模式',
                            color: colorScheme.onSurfaceVariant,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  size: 32,
                                ),
                                onPressed:
                                    ref.read(playerControllerProvider.notifier).previous,
                                color: colorScheme.onSurface,
                              ),
                              const SizedBox(width: 16),
                              if (player.isLoading)
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              else
                                StreamBuilder<bool>(
                                  stream: ref
                                      .watch(audioHandlerProvider)
                                      .playbackState
                                      .map((s) => s.playing),
                                  builder: (context, snapshot) {
                                    final playing = snapshot.data ?? false;
                                    return Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 30,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                        onPressed: playing
                                            ? ref
                                                .read(playerControllerProvider.notifier)
                                                .pause
                                            : ref
                                                .read(playerControllerProvider.notifier)
                                                .play,
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 32,
                                ),
                                onPressed:
                                    ref.read(playerControllerProvider.notifier).next,
                                color: colorScheme.onSurface,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.queue_music_rounded,
                              size: 22,
                            ),
                            onPressed: () => _showPlaylist(context),
                            tooltip: '播放列表',
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bottom padding for safe area
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom > 0 ? 0 : 8,
                ),
              ],
            ),
          ),
        );
  }
}
