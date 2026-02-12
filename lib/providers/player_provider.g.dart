// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioHandler)
final audioHandlerProvider = AudioHandlerProvider._();

final class AudioHandlerProvider
    extends
        $FunctionalProvider<
          BoatAudioHandler,
          BoatAudioHandler,
          BoatAudioHandler
        >
    with $Provider<BoatAudioHandler> {
  AudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioHandlerHash();

  @$internal
  @override
  $ProviderElement<BoatAudioHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BoatAudioHandler create(Ref ref) {
    return audioHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BoatAudioHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BoatAudioHandler>(value),
    );
  }
}

String _$audioHandlerHash() => r'3b843944bfb0d62f122d8f257b030e8dc93f0786';

@ProviderFor(playerPosition)
final playerPositionProvider = PlayerPositionProvider._();

final class PlayerPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Duration>, Duration, Stream<Duration>>
    with $FutureModifier<Duration>, $StreamProvider<Duration> {
  PlayerPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerPositionHash();

  @$internal
  @override
  $StreamProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration> create(Ref ref) {
    return playerPosition(ref);
  }
}

String _$playerPositionHash() => r'1f4bb075028ef62dc880b8a5ca833e6ceb7fed27';

@ProviderFor(playerDuration)
final playerDurationProvider = PlayerDurationProvider._();

final class PlayerDurationProvider
    extends
        $FunctionalProvider<AsyncValue<Duration?>, Duration?, Stream<Duration?>>
    with $FutureModifier<Duration?>, $StreamProvider<Duration?> {
  PlayerDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerDurationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerDurationHash();

  @$internal
  @override
  $StreamProviderElement<Duration?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration?> create(Ref ref) {
    return playerDuration(ref);
  }
}

String _$playerDurationHash() => r'b01fb46bbd1f14ceabf8ac6addca564d755574ce';

@ProviderFor(PlayerController)
final playerControllerProvider = PlayerControllerProvider._();

final class PlayerControllerProvider
    extends $NotifierProvider<PlayerController, PlayerControllerState> {
  PlayerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerControllerHash();

  @$internal
  @override
  PlayerController create() => PlayerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerControllerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerControllerState>(value),
    );
  }
}

String _$playerControllerHash() => r'f6ca00b92276034e7df7ae6619aca280a5c26bc9';

abstract class _$PlayerController extends $Notifier<PlayerControllerState> {
  PlayerControllerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerControllerState, PlayerControllerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerControllerState, PlayerControllerState>,
              PlayerControllerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
