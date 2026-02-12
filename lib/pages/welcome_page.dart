import 'package:boat_player/api/bilibili_client.dart';
import 'package:boat_player/cons/config.dart';
import 'package:boat_player/models/video_item.dart';
import 'package:boat_player/pages/dialog/privacy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../utils/cookie_store.dart';
import 'home/home_page.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  static const String _kPrivacyNoticeShownKey = 'privacy_notice_shown_v1';

  bool _checking = true;
  String _statusText = '检查 cookies...';
  late AnimationController _controller;

  // Animation for fade out
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _maybeShowPrivacyDialogOnce();
    await _checkLoginStatus();
  }

  Future<void> _maybeShowPrivacyDialogOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShown = prefs.getBool(_kPrivacyNoticeShownKey) ?? false;
    if (hasShown || !mounted) return;

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    await SmartDialog.show(builder: (_) => const PrivacyDialog());
    await prefs.setBool(_kPrivacyNoticeShownKey, true);
  }

  Future<void> _checkLoginStatus() async {
    // 1. Check Cookie
    if (!CookieStore().hasCookie) {
      if (mounted) {
        setState(() {
          _checking = false;
          _statusText = '';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _statusText = '正在游览...';
      });
    }

    // 2. Fetch Data immediately
    List<VideoItem>? videos;
    try {
      final client = BilibiliClient();
      const mid = 208976996;
      final response = await client.getSpaceWbiArcSearch(mid: mid);
      videos = response.vlist;
    } catch (e) {
      debugPrint('Welcome fetch failed: $e');
      // If failed, we still proceed to Home, but Home will try to fetch again or show error
    }

    // 3. Wait for minimum time (2 seconds total for UX)
    // We already spent some time fetching, so wait remaining time
    // Let's just ensure we show the "Loading" state for at least 2s from start
    await Future.delayed(const Duration(seconds: 2));

    // 4. Fade Out Animation (300-500ms)
    if (mounted) {
      setState(() {
        _opacity = 0.0;
      });

      // Wait for animation
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomePage(initialVideos: videos),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  Future<void> _goToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (result == true) {
      // If login success, restart the check process
      if (mounted) {
        setState(() {
          _checking = true;
          _opacity = 1.0;
        });
        _checkLoginStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If checking, still show the themed background but maybe just a loader
    final content = _checking
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _statusText,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Boat
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: math.sin(_controller.value * 2 * math.pi) * 0.05,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.sailing,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                '淡水',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '赞美船神！',
                style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
              ),
              const SizedBox(height: 60),

              // Login Button
              FilledButton.icon(
                onPressed: _goToLogin,
                icon: const Icon(Icons.login),
                label: const Text('请登录'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 40),
              // Seafood Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.set_meal, color: Colors.white70, size: 30),
                  SizedBox(width: 20),
                  Icon(Icons.waves, color: Colors.white70, size: 30),
                  SizedBox(width: 20),
                  Icon(Icons.phishing, color: Colors.white70, size: 30),
                ],
              ),
            ],
          );

    return Scaffold(
      backgroundColor: Colors.blue[800]!,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[900]!, Colors.blue[700]!, Colors.blue[400]!],
            ),
          ),
          child: Stack(
            children: [
              // Background Waves (Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 150,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: WaveClipper(offset: 20),
                  child: Container(
                    height: 120,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),

              // Main Content
              Center(child: content),
              // if (Config.debug && !_checking)
              if (!_checking)
                Positioned(left: 50, bottom: 50, child: _buildDebug(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebug(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => HomePage()),
        //     );
        //   },
        //   child: Text('home'),
        // ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (c) {
                final cookieStore = CookieStore();
                final controller = TextEditingController(
                  text: cookieStore.cookie,
                );
                return Dialog(
                  child: Column(
                    children: [
                      Text('cookie:'),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: '输入你的 cookie'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            final navigator = Navigator.of(context);
                            await cookieStore.saveCookie(controller.text);
                            if (!context.mounted) return;
                            navigator.pop();
                            navigator.pushReplacement(
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          }
                        },
                        child: Text('提交'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('cokkie'),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double offset;
  WaveClipper({this.offset = 0});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(
      size.width - (size.width / 3.25),
      size.height - 65,
    );
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(
      size.width,
      0,
    ); // Close top right (actually bottom right in stack context, wait)
    // To make it fill the bottom, we need to trace the bottom edge.
    // Actually standard wave clipper usually fills the top or bottom.
    // Let's assume this is a bottom wave.
    // Re-drawing for bottom alignment:

    path.reset();
    path.moveTo(0, 20); // Start slightly down

    // Wave logic
    final waveHeight = 20.0;
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(i, math.sin((i + offset) / 30) * waveHeight + waveHeight);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
