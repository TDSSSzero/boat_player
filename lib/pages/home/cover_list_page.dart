import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/bilibili_client.dart';

class CoverListPage extends StatefulWidget {
  const CoverListPage({super.key});

  @override
  State<CoverListPage> createState() => _CoverListPageState();
}

class _CoverListPageState extends State<CoverListPage> with AutomaticKeepAliveClientMixin {
  final BilibiliClient _client = BilibiliClient();
  static const int _targetMid = 208976996;
  static const String _storageKey = 'cover_song_list';
  
  List<String> _songList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _fetchCoverList();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedList = prefs.getStringList(_storageKey);
    if (storedList != null && storedList.isNotEmpty) {
      setState(() {
        _songList = storedList;
      });
    }
  }

  Future<void> _fetchCoverList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _client.getSpaceWbiArcSearch(mid: _targetMid, ps: 50);
      
      if (mounted) {
        final videos = response.vlist;
        final songs = videos.map((v) => v.title).toList();
        
        setState(() {
          _songList = songs;
        });
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_storageKey, songs);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent for gradient background
      appBar: AppBar(
        title: const Text('船歌列表', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _fetchCoverList,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
            ),
          if (_isLoading && _songList.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white)))
          else if (_songList.isEmpty)
            const Expanded(child: Center(child: Text('No songs found', style: TextStyle(color: Colors.white70))))
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: _songList.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      _songList[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
