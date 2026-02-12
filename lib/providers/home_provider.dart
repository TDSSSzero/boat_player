import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.freezed.dart';
part 'home_provider.g.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([BMusic(playCount: 0)]) List<BMusic> all,
  }) = _HomeState;
}

@freezed
abstract class BMusic with _$BMusic {
  const factory BMusic({
    required int playCount,
  }) = _BMusic;
}

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    return const HomeState();
  }

  void add() {
    final current = state.all;
    if (current.isEmpty) {
      state = state.copyWith(all: const [BMusic(playCount: 1)]);
      return;
    }

    final first = current.first;
    final updatedFirst = first.copyWith(playCount: first.playCount + 1);
    state = state.copyWith(all: [updatedFirst, ...current.skip(1)]);
  }
}
