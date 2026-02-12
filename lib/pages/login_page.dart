import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/cookie_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  CookieManager cookieManager = CookieManager.instance();
  bool _isLoginSuccess = false;
  final otherAgent =
      "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Bilibili'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
          url: WebUri("https://passport.bilibili.com/login"),
        ),
        initialSettings: InAppWebViewSettings(
          userAgent: otherAgent,
          useHybridComposition: true, // Fix for some Android versions
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          if (url != null) {
            await _checkCookie(url);
          }
        },
      ),
    );
  }

  Future<void> _checkCookie(WebUri url) async {
    if (_isLoginSuccess) return;

    // Get cookies for bilibili.com
    final cookies = await cookieManager.getCookies(
      url: WebUri("https://bilibili.com"),
    );

    String? sessData;
    final List<String> cookieParts = [];

    for (var cookie in cookies) {
      if (cookie.name == 'SESSDATA') {
        sessData = cookie.value;
      }
      cookieParts.add('${cookie.name}=${cookie.value}');
    }

    if (sessData != null && sessData.isNotEmpty) {
      _isLoginSuccess = true;
      final cookieStr = cookieParts.join('; ');

      // Save to store
      await CookieStore().saveCookie(cookieStr);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login Success!')));
        Navigator.pop(context, true);
      }
    }
  }
}
