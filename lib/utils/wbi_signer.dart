import 'dart:convert';
import 'package:crypto/crypto.dart';

class WbiSigner {
  static final List<int> _mixinKeyEncTab = [
    46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35, 27, 43, 5, 49,
    33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13, 37, 48, 7, 16, 24, 55, 40,
    61, 26, 17, 0, 1, 60, 51, 30, 4, 22, 25, 54, 21, 56, 59, 6, 63, 57, 62, 11,
    36, 20, 34, 44, 52
  ];

  static String _getMixinKey(String orig) {
    if (orig.length < 32) return orig; // Should not happen if inputs are valid
    String result = "";
    for (int i = 0; i < 32; i++) {
      if (i < _mixinKeyEncTab.length && _mixinKeyEncTab[i] < orig.length) {
         result += orig[_mixinKeyEncTab[i]];
      }
    }
    return result;
  }

  static String _md5Hex(String s) {
    return md5.convert(utf8.encode(s)).toString();
  }

  /// Sign the parameters.
  /// [params] is the map of parameters to sign.
  /// [imgKey] and [subKey] are obtained from the nav interface.
  static Map<String, dynamic> encodeParams(
    Map<String, dynamic> params,
    String imgKey,
    String subKey,
  ) {
    if (imgKey.isEmpty || subKey.isEmpty) {
      return params;
    }

    final mixinKey = _getMixinKey(imgKey + subKey);
    final currTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final Map<String, dynamic> signedParams = Map.from(params);
    signedParams['wts'] = currTime;

    // Sort keys
    final sortedKeys = signedParams.keys.toList()..sort();
    
    // Filter characters
    final chrFilter = RegExp(r"[!'()*]");

    final List<String> queryParts = [];
    
    for (final key in sortedKeys) {
      final value = signedParams[key];
      if (value == null) continue;
      
      final String valStr = value.toString();
      final String filteredVal = valStr.replaceAll(chrFilter, "");
      
      // Url encode key and value
      // Uri.encodeComponent is equivalent to encodeURIComponent in JS
      final String k = Uri.encodeComponent(key);
      final String v = Uri.encodeComponent(filteredVal);
      
      queryParts.add("$k=$v");
    }

    final String query = queryParts.join("&");
    final String wRid = _md5Hex(query + mixinKey);

    signedParams['w_rid'] = wRid;

    return signedParams;
  }
}
