import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/video_item.dart';
import '../../utils/download_manager.dart';
import '../../providers/player_provider.dart';

class DownloadsPage extends ConsumerStatefulWidget {
  const DownloadsPage({super.key});

  @override
  ConsumerState<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends ConsumerState<DownloadsPage> {
  final DownloadManager _downloadManager = DownloadManager();
  List<VideoItem> _downloads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    setState(() => _isLoading = true);
    final items = await _downloadManager.getDownloadedItems();
    if (mounted) {
      setState(() {
        _downloads = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(VideoItem video) async {
    await _downloadManager.deleteDownload(video);
    await _loadDownloads();
  }
  
  void _playAll(int index) {
    if (_downloads.isEmpty) return;
    ref.read(playerControllerProvider.notifier).setPlaylist(_downloads);
    ref.read(playerControllerProvider.notifier).playAtIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('下载列表', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadDownloads,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _downloads.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_done, size: 64, color: Colors.white54),
                      SizedBox(height: 16),
                      Text('还没有下载的曲目', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: _downloads.length,
                  itemBuilder: (context, index) {
                    final video = _downloads[index];
                    return Dismissible(
                      key: Key(video.bvid),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteItem(video),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            video.title, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(color: Colors.white)
                          ),
                          leading: const Icon(Icons.music_note, color: Colors.white70),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_circle_outline, color: Colors.white70),
                            onPressed: () => _playAll(index),
                          ),
                          onTap: () => _playAll(index),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
