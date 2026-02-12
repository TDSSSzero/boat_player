import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';

class PlaylistBottomSheet extends ConsumerWidget {
  const PlaylistBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerControllerProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.queue_music, color: Colors.orangeAccent),
                const SizedBox(width: 8),
                const Text(
                  '当前播放列表',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Flexible(
            child: Builder(
              builder: (context) {
                final playlist = player.playlist;
                if (playlist.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('Queue is empty'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlist.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final video = playlist[index];
                    final isPlaying = player.currentIndex == index;

                    return ListTile(
                      selected: isPlaying,
                      selectedTileColor:
                          Colors.orangeAccent.withValues(alpha: 0.1),
                      leading: isPlaying
                          ? const Icon(
                              Icons.equalizer,
                              color: Colors.orangeAccent,
                            )
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                      title: Text(
                        video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isPlaying ? Colors.orangeAccent : null,
                          fontWeight:
                              isPlaying ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        video.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isPlaying
                          ? const Icon(
                              Icons.volume_up,
                              size: 16,
                              color: Colors.orangeAccent,
                            )
                          : null,
                      onTap: () {
                        ref
                            .read(playerControllerProvider.notifier)
                            .playAtIndex(index);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
