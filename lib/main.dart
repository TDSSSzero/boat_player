import 'package:audio_service/audio_service.dart';
import 'package:boat_player/utils/per_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:boat_player/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'providers/player_provider.dart';
import 'utils/cookie_store.dart';
import 'services/boat_audio_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CookieStore().init();

  // 初始化音频服务
  final player = AudioPlayer();
  await player.setVolume(1.0);
  _audioHandler = await AudioService.init(
    builder: () => BoatAudioHandler(player),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(_audioHandler!),
      ],
      child: const MyApp(),
    ),
  );
}

BoatAudioHandler? _audioHandler;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boat Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [FlutterSmartDialog.observer],
      home: const _AppInitializer(),
    );
  }
}

class _AppInitializer extends StatefulWidget {
  const _AppInitializer();

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((c) async {
      bool get = await PerTools.areNotificationsEnabled();
      if (!get) {
        get = await PerTools.requestNoti();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomePage();
  }
}
