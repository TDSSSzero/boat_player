import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_item.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  DownloadManager._internal();

  final Dio _dio = Dio();

  Future<String> get _downloadDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${directory.path}/downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  Future<String> getFilePath(String bvid) async {
    final dir = await _downloadDirectory;
    return '$dir/$bvid.m4a';
  }

  Future<bool> hasFile(String bvid) async {
    final path = await getFilePath(bvid);
    return File(path).exists();
  }

  Future<void> downloadAudio({
    required VideoItem video,
    required String url,
    required Function(int received, int total) onProgress,
  }) async {
    final savePath = await getFilePath(video.bvid);
    
    // Add headers required by Bilibili
    final options = Options(headers: {
      'Referer': 'https://www.bilibili.com/',
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    });

    try {
      await _dio.download(
        url,
        savePath,
        options: options,
        onReceiveProgress: onProgress,
      );
      
      // Save metadata on successful download
      await _saveMetadata(video);
    } catch (e) {
      // If download fails, delete partial file
      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }

  Future<void> _saveMetadata(VideoItem video) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(video.toJson());
    await prefs.setString('download_meta_${video.bvid}', jsonStr);
  }

  Future<void> _removeMetadata(String bvid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('download_meta_$bvid');
  }

  Future<List<VideoItem>> getDownloadedItems() async {
    final dirPath = await _downloadDirectory;
    final dir = Directory(dirPath);
    if (!await dir.exists()) return [];

    final prefs = await SharedPreferences.getInstance();
    final List<VideoItem> items = [];

    final List<FileSystemEntity> entities = await dir.list().toList();
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.m4a')) {
        final filename = entity.uri.pathSegments.last;
        final bvid = filename.replaceAll('.m4a', '');
        
        final metaStr = prefs.getString('download_meta_$bvid');
        if (metaStr != null) {
          try {
             items.add(VideoItem.fromJson(jsonDecode(metaStr)));
          } catch (e) {
             // ignore
          }
        } else {
             items.add(VideoItem(
               aid: 0,
               bvid: bvid,
               title: 'Unknown Title ($bvid)',
               pic: '',
               play: 0,
               comment: 0,
               author: '',
               mid: 0,
               created: 0,
               length: '',
             ));
        }
      }
    }
    return items;
  }

  Future<void> deleteDownload(VideoItem video) async {
    final path = await getFilePath(video.bvid);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    await _removeMetadata(video.bvid);
  }
}
