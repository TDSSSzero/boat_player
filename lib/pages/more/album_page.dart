import 'package:flutter/material.dart';
import '../../components/backgrounds/marine_background.dart';
import '../../utils/boat_assets.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showFab) {
        setState(() {
          _showFab = true;
        });
      } else if (_scrollController.offset <= 200 && _showFab) {
        setState(() {
          _showFab = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showImageDetail(BuildContext context, String assetPath) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return ImageDetailPage(assetPath: assetPath);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Boat Album', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background
          const Positioned.fill(child: MarineBackground()),

          // Grid View
          SafeArea(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: BoatAssets.allBoats.length,
              itemBuilder: (context, index) {
                final assetPath = BoatAssets.allBoats[index];
                return GestureDetector(
                  onTap: () => _showImageDetail(context, assetPath),
                  child: Hero(
                    tag: assetPath,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image, color: Colors.white54));
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final String assetPath;

  const ImageDetailPage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: assetPath,
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        elevation: 0,
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
