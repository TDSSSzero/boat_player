import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/wbi_signer.dart';
import '../utils/cookie_store.dart';
import '../models/video_item.dart';
import '../models/video_detail.dart';
import '../models/play_url.dart';

class BilibiliClient {
  final Dio _dio;
  String? _imgKey;
  String? _subKey;

  //208976996
  
  // static const String _cookie = 
  // 'buvid3=C3DC187F-D24A-851E-9584-9C1C66E616D473937infoc; b_nut=1749442973; _uuid=89D102811-97A10-915D-4514-59A65A32D23F74410infoc; buvid_fp=f1546485495d911b76bf333dc2727710; enable_web_push=DISABLE; enable_feed_channel=ENABLE; buvid4=299F1552-97B0-A87B-90CF-49A3E6ADBA0774881-025060912-8JIr1tIF3gU4p9DWfvDzbQ%3D%3D; rpdid=|(J|YJull)kl0J\'u~RmRlRJkY; DedeUserID=1538744; DedeUserID__ckMd5=668aeee8933ebd27; header_theme_version=OPEN; theme-tip-show=SHOWED; theme-avatar-tip-show=SHOWED; LIVE_BUVID=AUTO1417508249197255; hit-dyn-v2=1; PVID=2; CURRENT_QUALITY=16; bmg_af_switch=1; bmg_src_def_domain=i1.hdslb.com; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Njc3NTczODAsImlhdCI6MTc2NzQ5ODEyMCwicGx0IjotMX0.4VzeVdhaQDQ1n5u5LqoJQlxz51XLfX4VAGSCW3O_VY8; bili_ticket_expires=1767757320; SESSDATA=f1008b19%2C1783050180%2Cd85ab%2A11CjDq-rYDXQQXHmvyI2J2rtuO9sfGVGF23c7Fl2DhXuJeXR01sDsQhTVWbLk4N22pufcSVnZxVk5mNkNPOWU4X1k4WXF4MEc1azYzeXFaVjJiNnU0TFZyWjN3RVU5RGhDWFdGN0RUSXJTWUxMS1QyejVwdmxzLUtNdXdiZ2RtTjUtaHNYTkVCWmpnIIEC; bili_jct=7912777c49b0489cf8532a28aa08f64b; sid=5op3yrni; home_feed_column=5; browser_resolution=1920-860; bp_t_offset_1538744=1153891286747447296; CURRENT_FNVAL=4048; b_lsid=9AC951062_19B876CD219';

  BilibiliClient() : _dio = Dio() {
    _dio.options.baseUrl = 'https://api.bilibili.com';
    _dio.options.headers = {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Referer': 'https://www.bilibili.com/',
    };
    
    // Add interceptor to inject cookie dynamically
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (CookieStore().hasCookie) {
          options.headers['Cookie'] = CookieStore().cookie;
        }
        return handler.next(options);
      },
    ));
  }

  static String get cookie => CookieStore().cookie;

  Future<void> _updateWbiKeys() async {
    try {
      final response = await _dio.get('/x/web-interface/nav');
      if (response.statusCode == 200 && response.data['code'] == 0) {
        final wbiImg = response.data['data']['wbi_img'];
        if (wbiImg != null) {
          final String imgUrl = wbiImg['img_url'];
          final String subUrl = wbiImg['sub_url'];
          
          _imgKey = _extractKey(imgUrl);
          _subKey = _extractKey(subUrl);
        }
      }
    } catch (e) {
      debugPrint('Error fetching Wbi keys: $e');
    }
  }

  String _extractKey(String url) {
    final lastSlash = url.lastIndexOf('/');
    final lastDot = url.lastIndexOf('.');
    if (lastSlash != -1 && lastDot != -1 && lastDot > lastSlash) {
      return url.substring(lastSlash + 1, lastDot);
    }
    return '';
  }

  Future<SpaceArcSearchResponse> getSpaceWbiArcSearch({
    required int mid,
    int pn = 1,
    int ps = 30,
    String? keyword,
    String? order,
  }) async {
    if (_imgKey == null || _subKey == null) {
      await _updateWbiKeys();
    }

    final Map<String, dynamic> params = {
      'mid': mid,
      'pn': pn,
      'ps': ps,
    };
    
    if (keyword != null) params['keyword'] = keyword;
    if (order != null) params['order'] = order;

    final signedParams = WbiSigner.encodeParams(
      params,
      _imgKey ?? '',
      _subKey ?? '',
    );

    try {
      final response = await _dio.get(
        '/x/space/wbi/arc/search',
        queryParameters: signedParams,
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 0) {
           return SpaceArcSearchResponse.fromJson(response.data);
        } else {
           throw Exception('API Error: ${response.data['message']} (Code: ${response.data['code']})');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VideoDetail> getWebInterfaceView({required String bvid}) async {
    try {
      final response = await _dio.get(
        '/x/web-interface/view',
        queryParameters: {'bvid': bvid},
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 0) {
          return VideoDetail.fromJson(response.data);
        } else {
          throw Exception('API Error: ${response.data['message']} (Code: ${response.data['code']})');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlayUrlResponse> getPlayerPlayUrl({
    required String bvid,
    required int cid,
  }) async {
    if (_imgKey == null || _subKey == null) {
      await _updateWbiKeys();
    }

    final Map<String, dynamic> params = {
      'bvid': bvid,
      'cid': cid,
      'fnval': 16, // DASH
      'fnver': 0,
      'fourk': 1,
    };

    final signedParams = WbiSigner.encodeParams(
      params,
      _imgKey ?? '',
      _subKey ?? '',
    );

    try {
      final response = await _dio.get(
        '/x/player/wbi/playurl',
        queryParameters: signedParams,
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 0) {
          return PlayUrlResponse.fromJson(response.data);
        } else {
          throw Exception('API Error: ${response.data['message']} (Code: ${response.data['code']})');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
