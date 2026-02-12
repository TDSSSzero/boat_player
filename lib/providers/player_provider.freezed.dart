// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerControllerState implements DiagnosticableTreeMixin {

 List<VideoItem> get playlist; int get currentIndex; VideoItem? get currentVideo; bool get isLoading; String? get errorMessage; PlayMode get playMode; bool get isPlaying;
/// Create a copy of PlayerControllerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerControllerStateCopyWith<PlayerControllerState> get copyWith => _$PlayerControllerStateCopyWithImpl<PlayerControllerState>(this as PlayerControllerState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerControllerState'))
    ..add(DiagnosticsProperty('playlist', playlist))..add(DiagnosticsProperty('currentIndex', currentIndex))..add(DiagnosticsProperty('currentVideo', currentVideo))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('playMode', playMode))..add(DiagnosticsProperty('isPlaying', isPlaying));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerControllerState&&const DeepCollectionEquality().equals(other.playlist, playlist)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentVideo, currentVideo) || other.currentVideo == currentVideo)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.playMode, playMode) || other.playMode == playMode)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(playlist),currentIndex,currentVideo,isLoading,errorMessage,playMode,isPlaying);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerControllerState(playlist: $playlist, currentIndex: $currentIndex, currentVideo: $currentVideo, isLoading: $isLoading, errorMessage: $errorMessage, playMode: $playMode, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class $PlayerControllerStateCopyWith<$Res>  {
  factory $PlayerControllerStateCopyWith(PlayerControllerState value, $Res Function(PlayerControllerState) _then) = _$PlayerControllerStateCopyWithImpl;
@useResult
$Res call({
 List<VideoItem> playlist, int currentIndex, VideoItem? currentVideo, bool isLoading, String? errorMessage, PlayMode playMode, bool isPlaying
});




}
/// @nodoc
class _$PlayerControllerStateCopyWithImpl<$Res>
    implements $PlayerControllerStateCopyWith<$Res> {
  _$PlayerControllerStateCopyWithImpl(this._self, this._then);

  final PlayerControllerState _self;
  final $Res Function(PlayerControllerState) _then;

/// Create a copy of PlayerControllerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playlist = null,Object? currentIndex = null,Object? currentVideo = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? playMode = null,Object? isPlaying = null,}) {
  return _then(_self.copyWith(
playlist: null == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as List<VideoItem>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentVideo: freezed == currentVideo ? _self.currentVideo : currentVideo // ignore: cast_nullable_to_non_nullable
as VideoItem?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,playMode: null == playMode ? _self.playMode : playMode // ignore: cast_nullable_to_non_nullable
as PlayMode,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerControllerState].
extension PlayerControllerStatePatterns on PlayerControllerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerControllerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerControllerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerControllerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerControllerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerControllerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerControllerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VideoItem> playlist,  int currentIndex,  VideoItem? currentVideo,  bool isLoading,  String? errorMessage,  PlayMode playMode,  bool isPlaying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerControllerState() when $default != null:
return $default(_that.playlist,_that.currentIndex,_that.currentVideo,_that.isLoading,_that.errorMessage,_that.playMode,_that.isPlaying);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VideoItem> playlist,  int currentIndex,  VideoItem? currentVideo,  bool isLoading,  String? errorMessage,  PlayMode playMode,  bool isPlaying)  $default,) {final _that = this;
switch (_that) {
case _PlayerControllerState():
return $default(_that.playlist,_that.currentIndex,_that.currentVideo,_that.isLoading,_that.errorMessage,_that.playMode,_that.isPlaying);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VideoItem> playlist,  int currentIndex,  VideoItem? currentVideo,  bool isLoading,  String? errorMessage,  PlayMode playMode,  bool isPlaying)?  $default,) {final _that = this;
switch (_that) {
case _PlayerControllerState() when $default != null:
return $default(_that.playlist,_that.currentIndex,_that.currentVideo,_that.isLoading,_that.errorMessage,_that.playMode,_that.isPlaying);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerControllerState with DiagnosticableTreeMixin implements PlayerControllerState {
  const _PlayerControllerState({final  List<VideoItem> playlist = const <VideoItem>[], this.currentIndex = -1, this.currentVideo, this.isLoading = false, this.errorMessage, this.playMode = PlayMode.loop, this.isPlaying = false}): _playlist = playlist;
  

 final  List<VideoItem> _playlist;
@override@JsonKey() List<VideoItem> get playlist {
  if (_playlist is EqualUnmodifiableListView) return _playlist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playlist);
}

@override@JsonKey() final  int currentIndex;
@override final  VideoItem? currentVideo;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override@JsonKey() final  PlayMode playMode;
@override@JsonKey() final  bool isPlaying;

/// Create a copy of PlayerControllerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerControllerStateCopyWith<_PlayerControllerState> get copyWith => __$PlayerControllerStateCopyWithImpl<_PlayerControllerState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerControllerState'))
    ..add(DiagnosticsProperty('playlist', playlist))..add(DiagnosticsProperty('currentIndex', currentIndex))..add(DiagnosticsProperty('currentVideo', currentVideo))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('playMode', playMode))..add(DiagnosticsProperty('isPlaying', isPlaying));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerControllerState&&const DeepCollectionEquality().equals(other._playlist, _playlist)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentVideo, currentVideo) || other.currentVideo == currentVideo)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.playMode, playMode) || other.playMode == playMode)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_playlist),currentIndex,currentVideo,isLoading,errorMessage,playMode,isPlaying);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerControllerState(playlist: $playlist, currentIndex: $currentIndex, currentVideo: $currentVideo, isLoading: $isLoading, errorMessage: $errorMessage, playMode: $playMode, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class _$PlayerControllerStateCopyWith<$Res> implements $PlayerControllerStateCopyWith<$Res> {
  factory _$PlayerControllerStateCopyWith(_PlayerControllerState value, $Res Function(_PlayerControllerState) _then) = __$PlayerControllerStateCopyWithImpl;
@override @useResult
$Res call({
 List<VideoItem> playlist, int currentIndex, VideoItem? currentVideo, bool isLoading, String? errorMessage, PlayMode playMode, bool isPlaying
});




}
/// @nodoc
class __$PlayerControllerStateCopyWithImpl<$Res>
    implements _$PlayerControllerStateCopyWith<$Res> {
  __$PlayerControllerStateCopyWithImpl(this._self, this._then);

  final _PlayerControllerState _self;
  final $Res Function(_PlayerControllerState) _then;

/// Create a copy of PlayerControllerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playlist = null,Object? currentIndex = null,Object? currentVideo = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? playMode = null,Object? isPlaying = null,}) {
  return _then(_PlayerControllerState(
playlist: null == playlist ? _self._playlist : playlist // ignore: cast_nullable_to_non_nullable
as List<VideoItem>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentVideo: freezed == currentVideo ? _self.currentVideo : currentVideo // ignore: cast_nullable_to_non_nullable
as VideoItem?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,playMode: null == playMode ? _self.playMode : playMode // ignore: cast_nullable_to_non_nullable
as PlayMode,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
