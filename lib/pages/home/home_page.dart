import 'dart:convert';
import 'package:boat_player/components/backgrounds/image_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boat_player/cons/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/bilibili_client.dart';
import '../../components/player_bar.dart';
import '../../components/animated_boat_icon.dart';
import '../../components/backgrounds/marine_background.dart';
import '../../models/video_item.dart';
import '../../providers/player_provider.dart';
import '../../utils/cookie_store.dart';
import '../downloads/downloads_page.dart';
import '../more/more_page.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key, List<VideoItem>? initialVideos}) {
    if (initialVideos != null) {
      _HomePageState._preLoadedVideos = initialVideos;
    }
  }

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  final BilibiliClient _client = BilibiliClient();
  static const String _storageKey = 'home_video_list_cache';
  List<VideoItem> _homeVideos = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late TabController _tabController;

  /// Allow pre-setting videos (e.g. from WelcomePage)

  
  static List<VideoItem>? _preLoadedVideos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // If we have pre-loaded videos, use them
    if (_preLoadedVideos != null && _preLoadedVideos!.isNotEmpty) {
      _homeVideos = _preLoadedVideos!;
      // Clear static reference to free memory
      _preLoadedVideos = null;
      
      // Sync with player if player is empty
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (ref.read(playerControllerProvider).playlist.isEmpty) {
          ref.read(playerControllerProvider.notifier).setPlaylist(_homeVideos);
        }
      });
    } else {
      // Load cache first, then fetch
      _loadCachedVideos();

      // Auto fetch for the default MID if playlist is empty (not pre-fetched)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (ref.read(playerControllerProvider).playlist.isEmpty) {
          _fetchVideos();
        }
      });
    }
  }

  Future<void> _loadCachedVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedJson = prefs.getString(_storageKey);

      if (cachedJson != null && cachedJson.isNotEmpty && mounted) {
        final List<dynamic> list = jsonDecode(cachedJson);
        final videos = list.map((e) => VideoItem.fromJson(e)).toList();

        if (videos.isNotEmpty) {
          setState(() {
            _homeVideos = videos;
          });
          // Optional: Sync with player if player is empty
          if (ref.read(playerControllerProvider).playlist.isEmpty) {
            ref.read(playerControllerProvider.notifier).setPlaylist(videos);
          }
        }
      }
    } catch (e) {
      // Ignore cache errors
      debugPrint('Error loading cache: $e');
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchVideos() async {
    const mid = 208976996;
    // return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _client.getSpaceWbiArcSearch(mid: mid);
      if (mounted) {
        final videos = response.vlist;
        if (videos.isEmpty) {
          setState(() {
            _errorMessage = 'No videos found for this user.';
          });
        } else {
          // Update local list
          setState(() {
            _homeVideos = videos;
          });

          // Only update player if it's empty
          if (ref.read(playerControllerProvider).playlist.isEmpty) {
            ref.read(playerControllerProvider.notifier).setPlaylist(videos);
          }

          // Cache the result
          final prefs = await SharedPreferences.getInstance();
          final jsonStr = jsonEncode(videos.map((v) => v.toJson()).toList());
          await prefs.setString(_storageKey, jsonStr);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String bvid) async {
    final Uri url = Uri.parse('https://www.bilibili.com/video/$bvid');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  String _fixUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
  }

  Future<void> _printCookie() async {
    debugPrint(CookieStore().cookie);
  }

  void _showDebugDialog() {
    SmartDialog.show(
      clickMaskDismiss: true,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Debug',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: SmartDialog.dismiss,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _printCookie,
                        child: const Text('打印当前 Cookie'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          Config.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.login, color: Colors.white),
        //     tooltip: 'Login Bilibili',
        //     onPressed: _goToLogin,
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return TabBar(
                controller: _tabController,
                indicatorColor: Colors.orangeAccent,
                indicatorWeight: 3,
                labelColor: Colors.orangeAccent,
                unselectedLabelColor: Colors.white70,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: AnimatedBoatIcon(
                      icon: Icons.sailing,
                      size: 30,
                      color: _tabController.index == 0
                          ? Colors.orangeAccent
                          : Colors.white,
                      isAnimating: _tabController.index == 0,
                    ),
                  ),
                  Tab(
                    icon: AnimatedBoatIcon(
                      icon: Icons.download_for_offline,
                      size: 24,
                      color: _tabController.index == 1
                          ? Colors.orangeAccent
                          : Colors.white,
                      isAnimating: _tabController.index == 1,
                    ),
                  ),
                  Tab(
                    icon: AnimatedBoatIcon(
                      icon: Icons.menu,
                      size: 24,
                      color: _tabController.index == 2
                          ? Colors.orangeAccent
                          : Colors.white,
                      isAnimating: _tabController.index == 2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _tabController.index == 1
                  ? const ImageBackground(key: ValueKey('image_bg'))
                  : const MarineBackground(key: ValueKey('marine_bg')),
            ),
          ),

          // Main Content
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Video List (Original Home)
                _buildVideoList(),

                // Tab 2: Downloads
                const DownloadsPage(),

                // Tab 3: More
                const MorePage(),
              ],
            ),
          ),

          // Player Bar at bottom
          Positioned(
            left: 0,
            right: 0,
            // bottom: MediaQuery.paddingOf(context).bottom,
            bottom: 0,
            child: PlayerBar(),
          ),

          if (Config.debug)
            Positioned(
              right: 16,
              bottom: 90 + MediaQuery.of(context).padding.bottom,
              child: FloatingActionButton.small(
                heroTag: 'debug_fab_home',
                onPressed: _showDebugDialog,
                child: const Icon(Icons.bug_report),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.music_note,
                color: Colors.orangeAccent,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                "投稿列表",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: _fetchVideos,
                  tooltip: 'Refresh',
                ),
            ],
          ),
        ),

        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        const SizedBox(height: 10),

        // Video List
        Expanded(
          child: _homeVideos.isEmpty && !_isLoading && _errorMessage.isEmpty
              ? const Center(
                  child: Text(
                    '发生意外错误',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : Builder(
                  builder: (context) {
                    final player = ref.watch(playerControllerProvider);
                    final controller =
                        ref.read(playerControllerProvider.notifier);

                    return ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: 100,
                      ),
                      itemCount: _homeVideos.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final video = _homeVideos[index];
                        final isPlaying =
                            player.currentVideo?.bvid == video.bvid;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          color: isPlaying
                              ? Colors.orangeAccent.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isPlaying
                                ? BorderSide(
                                    color: Colors.orangeAccent.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 1,
                                  )
                                : BorderSide.none,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: SizedBox(
                              width: 80,
                              height: 45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  _fixUrl(video.pic),
                                  fit: BoxFit.cover,
                                  headers: const {
                                    'Referer': 'https://www.bilibili.com/',
                                    'User-Agent':
                                        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                                  },
                                  errorBuilder: (ctx, err, stack) =>
                                      const Icon(
                                    Icons.broken_image,
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isPlaying
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isPlaying
                                    ? Colors.orangeAccent
                                    : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              video.length,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    (isPlaying && player.isPlaying)
                                        ? Icons.pause_circle
                                        : Icons.play_circle_outline,
                                    color: isPlaying
                                        ? Colors.orangeAccent
                                        : Colors.white70,
                                  ),
                                  onPressed: () {
                                    if (isPlaying) {
                                      if (player.isPlaying) {
                                        controller.pause();
                                      } else {
                                        controller.play();
                                      }
                                    } else {
                                      controller.setPlaylist(_homeVideos);
                                      controller.playAtIndex(index);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.open_in_new,
                                    size: 20,
                                    color: Colors.white54,
                                  ),
                                  onPressed: () => _launchUrl(video.bvid),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.setPlaylist(_homeVideos);
                              controller.playAtIndex(index);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
