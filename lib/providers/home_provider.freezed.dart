// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 List<BMusic> get all;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&const DeepCollectionEquality().equals(other.all, all));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(all));

@override
String toString() {
  return 'HomeState(all: $all)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 List<BMusic> all
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,}) {
  return _then(_self.copyWith(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as List<BMusic>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BMusic> all)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.all);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BMusic> all)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.all);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BMusic> all)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.all);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({final  List<BMusic> all = const [BMusic(playCount: 0)]}): _all = all;
  

 final  List<BMusic> _all;
@override@JsonKey() List<BMusic> get all {
  if (_all is EqualUnmodifiableListView) return _all;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_all);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&const DeepCollectionEquality().equals(other._all, _all));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_all));

@override
String toString() {
  return 'HomeState(all: $all)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 List<BMusic> all
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,}) {
  return _then(_HomeState(
all: null == all ? _self._all : all // ignore: cast_nullable_to_non_nullable
as List<BMusic>,
  ));
}


}

/// @nodoc
mixin _$BMusic {

 int get playCount;
/// Create a copy of BMusic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BMusicCopyWith<BMusic> get copyWith => _$BMusicCopyWithImpl<BMusic>(this as BMusic, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BMusic&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,playCount);

@override
String toString() {
  return 'BMusic(playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class $BMusicCopyWith<$Res>  {
  factory $BMusicCopyWith(BMusic value, $Res Function(BMusic) _then) = _$BMusicCopyWithImpl;
@useResult
$Res call({
 int playCount
});




}
/// @nodoc
class _$BMusicCopyWithImpl<$Res>
    implements $BMusicCopyWith<$Res> {
  _$BMusicCopyWithImpl(this._self, this._then);

  final BMusic _self;
  final $Res Function(BMusic) _then;

/// Create a copy of BMusic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playCount = null,}) {
  return _then(_self.copyWith(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BMusic].
extension BMusicPatterns on BMusic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BMusic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BMusic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BMusic value)  $default,){
final _that = this;
switch (_that) {
case _BMusic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BMusic value)?  $default,){
final _that = this;
switch (_that) {
case _BMusic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BMusic() when $default != null:
return $default(_that.playCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playCount)  $default,) {final _that = this;
switch (_that) {
case _BMusic():
return $default(_that.playCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playCount)?  $default,) {final _that = this;
switch (_that) {
case _BMusic() when $default != null:
return $default(_that.playCount);case _:
  return null;

}
}

}

/// @nodoc


class _BMusic implements BMusic {
  const _BMusic({required this.playCount});
  

@override final  int playCount;

/// Create a copy of BMusic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BMusicCopyWith<_BMusic> get copyWith => __$BMusicCopyWithImpl<_BMusic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BMusic&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,playCount);

@override
String toString() {
  return 'BMusic(playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class _$BMusicCopyWith<$Res> implements $BMusicCopyWith<$Res> {
  factory _$BMusicCopyWith(_BMusic value, $Res Function(_BMusic) _then) = __$BMusicCopyWithImpl;
@override @useResult
$Res call({
 int playCount
});




}
/// @nodoc
class __$BMusicCopyWithImpl<$Res>
    implements _$BMusicCopyWith<$Res> {
  __$BMusicCopyWithImpl(this._self, this._then);

  final _BMusic _self;
  final $Res Function(_BMusic) _then;

/// Create a copy of BMusic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playCount = null,}) {
  return _then(_BMusic(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
