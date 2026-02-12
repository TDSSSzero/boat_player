import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/cookie_store.dart';

part 'settings_provider.freezed.dart';
part 'settings_provider.g.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool isWaveAnimationEnabled,
  }) = _SettingsState;
}

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  static const String _kWaveAnimationKey = 'wave_animation_enabled';

  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsState();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      isWaveAnimationEnabled: prefs.getBool(_kWaveAnimationKey) ?? true,
    );
  }

  Future<void> toggleWaveAnimation(bool enabled) async {
    state = state.copyWith(isWaveAnimationEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWaveAnimationKey, enabled);
  }

  Future<void> clearAllCache() async {
    await CookieStore().clearCookie();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const SettingsState();
  }
}
