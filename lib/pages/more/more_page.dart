import 'package:boat_player/components/backgrounds/image_background.dart';
import 'package:boat_player/pages/more/album_page.dart';
import 'package:boat_player/pages/more/settings_page.dart';
import 'package:flutter/material.dart';
import '../home/cover_list_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          '海鲜市场',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.photo_album,
            title: '很多船',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Stack(children: [const AlbumPage()]),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.grid_view,
            title: '船歌列表',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Stack(
                    children: [
                      const Positioned.fill(child: ImageBackground()),
                      const CoverListPage(),
                    ],
                  ),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: '设置',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}
