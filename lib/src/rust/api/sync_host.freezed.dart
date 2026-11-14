// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_host.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncHostRequestKind {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncHostRequestKind);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SyncHostRequestKind()';
}


}

/// @nodoc
class $SyncHostRequestKindCopyWith<$Res>  {
$SyncHostRequestKindCopyWith(SyncHostRequestKind _, $Res Function(SyncHostRequestKind) __);
}


/// Adds pattern-matching-related methods to [SyncHostRequestKind].
extension SyncHostRequestKindPatterns on SyncHostRequestKind {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SyncHostRequestKind_Sync value)?  sync_,TResult Function( SyncHostRequestKind_Pair value)?  pair,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync() when sync_ != null:
return sync_(_that);case SyncHostRequestKind_Pair() when pair != null:
return pair(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SyncHostRequestKind_Sync value)  sync_,required TResult Function( SyncHostRequestKind_Pair value)  pair,}){
final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync():
return sync_(_that);case SyncHostRequestKind_Pair():
return pair(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SyncHostRequestKind_Sync value)?  sync_,TResult? Function( SyncHostRequestKind_Pair value)?  pair,}){
final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync() when sync_ != null:
return sync_(_that);case SyncHostRequestKind_Pair() when pair != null:
return pair(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  sync_,TResult Function( String deviceName)?  pair,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync() when sync_ != null:
return sync_();case SyncHostRequestKind_Pair() when pair != null:
return pair(_that.deviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  sync_,required TResult Function( String deviceName)  pair,}) {final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync():
return sync_();case SyncHostRequestKind_Pair():
return pair(_that.deviceName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  sync_,TResult? Function( String deviceName)?  pair,}) {final _that = this;
switch (_that) {
case SyncHostRequestKind_Sync() when sync_ != null:
return sync_();case SyncHostRequestKind_Pair() when pair != null:
return pair(_that.deviceName);case _:
  return null;

}
}

}

/// @nodoc


class SyncHostRequestKind_Sync extends SyncHostRequestKind {
  const SyncHostRequestKind_Sync(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncHostRequestKind_Sync);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SyncHostRequestKind.sync_()';
}


}




/// @nodoc


class SyncHostRequestKind_Pair extends SyncHostRequestKind {
  const SyncHostRequestKind_Pair({required this.deviceName}): super._();
  

 final  String deviceName;

/// Create a copy of SyncHostRequestKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncHostRequestKind_PairCopyWith<SyncHostRequestKind_Pair> get copyWith => _$SyncHostRequestKind_PairCopyWithImpl<SyncHostRequestKind_Pair>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncHostRequestKind_Pair&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceName);
}

@override
String toString() {
    return 'SyncHostRequestKind.pair(deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class $SyncHostRequestKind_PairCopyWith<$Res> implements $SyncHostRequestKindCopyWith<$Res> {
  factory $SyncHostRequestKind_PairCopyWith(SyncHostRequestKind_Pair value, $Res Function(SyncHostRequestKind_Pair) _then) = _$SyncHostRequestKind_PairCopyWithImpl;
@useResult
$Res call({
 String deviceName
});




}
/// @nodoc
class _$SyncHostRequestKind_PairCopyWithImpl<$Res>
    implements $SyncHostRequestKind_PairCopyWith<$Res> {
  _$SyncHostRequestKind_PairCopyWithImpl(this._self, this._then);

  final SyncHostRequestKind_Pair _self;
  final $Res Function(SyncHostRequestKind_Pair) _then;

/// Create a copy of SyncHostRequestKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceName = null,}) {
  return _then(SyncHostRequestKind_Pair(
deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
