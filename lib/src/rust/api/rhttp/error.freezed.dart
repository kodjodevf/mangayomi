// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RhttpError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RhttpError()';
}


}

/// @nodoc
class $RhttpErrorCopyWith<$Res>  {
$RhttpErrorCopyWith(RhttpError _, $Res Function(RhttpError) __);
}


/// Adds pattern-matching-related methods to [RhttpError].
extension RhttpErrorPatterns on RhttpError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RhttpError_RhttpCancelError value)?  rhttpCancelError,TResult Function( RhttpError_RhttpTimeoutError value)?  rhttpTimeoutError,TResult Function( RhttpError_RhttpRedirectError value)?  rhttpRedirectError,TResult Function( RhttpError_RhttpStatusCodeError value)?  rhttpStatusCodeError,TResult Function( RhttpError_RhttpInvalidCertificateError value)?  rhttpInvalidCertificateError,TResult Function( RhttpError_RhttpConnectionError value)?  rhttpConnectionError,TResult Function( RhttpError_RhttpUnknownError value)?  rhttpUnknownError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError() when rhttpCancelError != null:
return rhttpCancelError(_that);case RhttpError_RhttpTimeoutError() when rhttpTimeoutError != null:
return rhttpTimeoutError(_that);case RhttpError_RhttpRedirectError() when rhttpRedirectError != null:
return rhttpRedirectError(_that);case RhttpError_RhttpStatusCodeError() when rhttpStatusCodeError != null:
return rhttpStatusCodeError(_that);case RhttpError_RhttpInvalidCertificateError() when rhttpInvalidCertificateError != null:
return rhttpInvalidCertificateError(_that);case RhttpError_RhttpConnectionError() when rhttpConnectionError != null:
return rhttpConnectionError(_that);case RhttpError_RhttpUnknownError() when rhttpUnknownError != null:
return rhttpUnknownError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RhttpError_RhttpCancelError value)  rhttpCancelError,required TResult Function( RhttpError_RhttpTimeoutError value)  rhttpTimeoutError,required TResult Function( RhttpError_RhttpRedirectError value)  rhttpRedirectError,required TResult Function( RhttpError_RhttpStatusCodeError value)  rhttpStatusCodeError,required TResult Function( RhttpError_RhttpInvalidCertificateError value)  rhttpInvalidCertificateError,required TResult Function( RhttpError_RhttpConnectionError value)  rhttpConnectionError,required TResult Function( RhttpError_RhttpUnknownError value)  rhttpUnknownError,}){
final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError():
return rhttpCancelError(_that);case RhttpError_RhttpTimeoutError():
return rhttpTimeoutError(_that);case RhttpError_RhttpRedirectError():
return rhttpRedirectError(_that);case RhttpError_RhttpStatusCodeError():
return rhttpStatusCodeError(_that);case RhttpError_RhttpInvalidCertificateError():
return rhttpInvalidCertificateError(_that);case RhttpError_RhttpConnectionError():
return rhttpConnectionError(_that);case RhttpError_RhttpUnknownError():
return rhttpUnknownError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RhttpError_RhttpCancelError value)?  rhttpCancelError,TResult? Function( RhttpError_RhttpTimeoutError value)?  rhttpTimeoutError,TResult? Function( RhttpError_RhttpRedirectError value)?  rhttpRedirectError,TResult? Function( RhttpError_RhttpStatusCodeError value)?  rhttpStatusCodeError,TResult? Function( RhttpError_RhttpInvalidCertificateError value)?  rhttpInvalidCertificateError,TResult? Function( RhttpError_RhttpConnectionError value)?  rhttpConnectionError,TResult? Function( RhttpError_RhttpUnknownError value)?  rhttpUnknownError,}){
final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError() when rhttpCancelError != null:
return rhttpCancelError(_that);case RhttpError_RhttpTimeoutError() when rhttpTimeoutError != null:
return rhttpTimeoutError(_that);case RhttpError_RhttpRedirectError() when rhttpRedirectError != null:
return rhttpRedirectError(_that);case RhttpError_RhttpStatusCodeError() when rhttpStatusCodeError != null:
return rhttpStatusCodeError(_that);case RhttpError_RhttpInvalidCertificateError() when rhttpInvalidCertificateError != null:
return rhttpInvalidCertificateError(_that);case RhttpError_RhttpConnectionError() when rhttpConnectionError != null:
return rhttpConnectionError(_that);case RhttpError_RhttpUnknownError() when rhttpUnknownError != null:
return rhttpUnknownError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  rhttpCancelError,TResult Function()?  rhttpTimeoutError,TResult Function()?  rhttpRedirectError,TResult Function( int field0,  List<(String, String)> field1,  HttpResponseBody field2)?  rhttpStatusCodeError,TResult Function( String field0)?  rhttpInvalidCertificateError,TResult Function( String field0)?  rhttpConnectionError,TResult Function( String field0)?  rhttpUnknownError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError() when rhttpCancelError != null:
return rhttpCancelError();case RhttpError_RhttpTimeoutError() when rhttpTimeoutError != null:
return rhttpTimeoutError();case RhttpError_RhttpRedirectError() when rhttpRedirectError != null:
return rhttpRedirectError();case RhttpError_RhttpStatusCodeError() when rhttpStatusCodeError != null:
return rhttpStatusCodeError(_that.field0,_that.field1,_that.field2);case RhttpError_RhttpInvalidCertificateError() when rhttpInvalidCertificateError != null:
return rhttpInvalidCertificateError(_that.field0);case RhttpError_RhttpConnectionError() when rhttpConnectionError != null:
return rhttpConnectionError(_that.field0);case RhttpError_RhttpUnknownError() when rhttpUnknownError != null:
return rhttpUnknownError(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  rhttpCancelError,required TResult Function()  rhttpTimeoutError,required TResult Function()  rhttpRedirectError,required TResult Function( int field0,  List<(String, String)> field1,  HttpResponseBody field2)  rhttpStatusCodeError,required TResult Function( String field0)  rhttpInvalidCertificateError,required TResult Function( String field0)  rhttpConnectionError,required TResult Function( String field0)  rhttpUnknownError,}) {final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError():
return rhttpCancelError();case RhttpError_RhttpTimeoutError():
return rhttpTimeoutError();case RhttpError_RhttpRedirectError():
return rhttpRedirectError();case RhttpError_RhttpStatusCodeError():
return rhttpStatusCodeError(_that.field0,_that.field1,_that.field2);case RhttpError_RhttpInvalidCertificateError():
return rhttpInvalidCertificateError(_that.field0);case RhttpError_RhttpConnectionError():
return rhttpConnectionError(_that.field0);case RhttpError_RhttpUnknownError():
return rhttpUnknownError(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  rhttpCancelError,TResult? Function()?  rhttpTimeoutError,TResult? Function()?  rhttpRedirectError,TResult? Function( int field0,  List<(String, String)> field1,  HttpResponseBody field2)?  rhttpStatusCodeError,TResult? Function( String field0)?  rhttpInvalidCertificateError,TResult? Function( String field0)?  rhttpConnectionError,TResult? Function( String field0)?  rhttpUnknownError,}) {final _that = this;
switch (_that) {
case RhttpError_RhttpCancelError() when rhttpCancelError != null:
return rhttpCancelError();case RhttpError_RhttpTimeoutError() when rhttpTimeoutError != null:
return rhttpTimeoutError();case RhttpError_RhttpRedirectError() when rhttpRedirectError != null:
return rhttpRedirectError();case RhttpError_RhttpStatusCodeError() when rhttpStatusCodeError != null:
return rhttpStatusCodeError(_that.field0,_that.field1,_that.field2);case RhttpError_RhttpInvalidCertificateError() when rhttpInvalidCertificateError != null:
return rhttpInvalidCertificateError(_that.field0);case RhttpError_RhttpConnectionError() when rhttpConnectionError != null:
return rhttpConnectionError(_that.field0);case RhttpError_RhttpUnknownError() when rhttpUnknownError != null:
return rhttpUnknownError(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class RhttpError_RhttpCancelError extends RhttpError {
  const RhttpError_RhttpCancelError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpCancelError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RhttpError.rhttpCancelError()';
}


}




/// @nodoc


class RhttpError_RhttpTimeoutError extends RhttpError {
  const RhttpError_RhttpTimeoutError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpTimeoutError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RhttpError.rhttpTimeoutError()';
}


}




/// @nodoc


class RhttpError_RhttpRedirectError extends RhttpError {
  const RhttpError_RhttpRedirectError(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpRedirectError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RhttpError.rhttpRedirectError()';
}


}




/// @nodoc


class RhttpError_RhttpStatusCodeError extends RhttpError {
  const RhttpError_RhttpStatusCodeError(this.field0, final  List<(String, String)> field1, this.field2): _field1 = field1,super._();
  

 final  int field0;
 final  List<(String, String)> _field1;
 List<(String, String)> get field1 {
  if (_field1 is EqualUnmodifiableListView) return _field1;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field1);
}

 final  HttpResponseBody field2;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RhttpError_RhttpStatusCodeErrorCopyWith<RhttpError_RhttpStatusCodeError> get copyWith => _$RhttpError_RhttpStatusCodeErrorCopyWithImpl<RhttpError_RhttpStatusCodeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpStatusCodeError&&(identical(other.field0, field0) || other.field0 == field0)&&const DeepCollectionEquality().equals(other._field1, _field1)&&(identical(other.field2, field2) || other.field2 == field2));
}


@override
int get hashCode => Object.hash(runtimeType,field0,const DeepCollectionEquality().hash(_field1),field2);

@override
String toString() {
  return 'RhttpError.rhttpStatusCodeError(field0: $field0, field1: $field1, field2: $field2)';
}


}

/// @nodoc
abstract mixin class $RhttpError_RhttpStatusCodeErrorCopyWith<$Res> implements $RhttpErrorCopyWith<$Res> {
  factory $RhttpError_RhttpStatusCodeErrorCopyWith(RhttpError_RhttpStatusCodeError value, $Res Function(RhttpError_RhttpStatusCodeError) _then) = _$RhttpError_RhttpStatusCodeErrorCopyWithImpl;
@useResult
$Res call({
 int field0, List<(String, String)> field1, HttpResponseBody field2
});


$HttpResponseBodyCopyWith<$Res> get field2;

}
/// @nodoc
class _$RhttpError_RhttpStatusCodeErrorCopyWithImpl<$Res>
    implements $RhttpError_RhttpStatusCodeErrorCopyWith<$Res> {
  _$RhttpError_RhttpStatusCodeErrorCopyWithImpl(this._self, this._then);

  final RhttpError_RhttpStatusCodeError _self;
  final $Res Function(RhttpError_RhttpStatusCodeError) _then;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,Object? field1 = null,Object? field2 = null,}) {
  return _then(RhttpError_RhttpStatusCodeError(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int,null == field1 ? _self._field1 : field1 // ignore: cast_nullable_to_non_nullable
as List<(String, String)>,null == field2 ? _self.field2 : field2 // ignore: cast_nullable_to_non_nullable
as HttpResponseBody,
  ));
}

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HttpResponseBodyCopyWith<$Res> get field2 {
  
  return $HttpResponseBodyCopyWith<$Res>(_self.field2, (value) {
    return _then(_self.copyWith(field2: value));
  });
}
}

/// @nodoc


class RhttpError_RhttpInvalidCertificateError extends RhttpError {
  const RhttpError_RhttpInvalidCertificateError(this.field0): super._();
  

 final  String field0;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RhttpError_RhttpInvalidCertificateErrorCopyWith<RhttpError_RhttpInvalidCertificateError> get copyWith => _$RhttpError_RhttpInvalidCertificateErrorCopyWithImpl<RhttpError_RhttpInvalidCertificateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpInvalidCertificateError&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RhttpError.rhttpInvalidCertificateError(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RhttpError_RhttpInvalidCertificateErrorCopyWith<$Res> implements $RhttpErrorCopyWith<$Res> {
  factory $RhttpError_RhttpInvalidCertificateErrorCopyWith(RhttpError_RhttpInvalidCertificateError value, $Res Function(RhttpError_RhttpInvalidCertificateError) _then) = _$RhttpError_RhttpInvalidCertificateErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RhttpError_RhttpInvalidCertificateErrorCopyWithImpl<$Res>
    implements $RhttpError_RhttpInvalidCertificateErrorCopyWith<$Res> {
  _$RhttpError_RhttpInvalidCertificateErrorCopyWithImpl(this._self, this._then);

  final RhttpError_RhttpInvalidCertificateError _self;
  final $Res Function(RhttpError_RhttpInvalidCertificateError) _then;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RhttpError_RhttpInvalidCertificateError(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RhttpError_RhttpConnectionError extends RhttpError {
  const RhttpError_RhttpConnectionError(this.field0): super._();
  

 final  String field0;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RhttpError_RhttpConnectionErrorCopyWith<RhttpError_RhttpConnectionError> get copyWith => _$RhttpError_RhttpConnectionErrorCopyWithImpl<RhttpError_RhttpConnectionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpConnectionError&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RhttpError.rhttpConnectionError(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RhttpError_RhttpConnectionErrorCopyWith<$Res> implements $RhttpErrorCopyWith<$Res> {
  factory $RhttpError_RhttpConnectionErrorCopyWith(RhttpError_RhttpConnectionError value, $Res Function(RhttpError_RhttpConnectionError) _then) = _$RhttpError_RhttpConnectionErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RhttpError_RhttpConnectionErrorCopyWithImpl<$Res>
    implements $RhttpError_RhttpConnectionErrorCopyWith<$Res> {
  _$RhttpError_RhttpConnectionErrorCopyWithImpl(this._self, this._then);

  final RhttpError_RhttpConnectionError _self;
  final $Res Function(RhttpError_RhttpConnectionError) _then;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RhttpError_RhttpConnectionError(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RhttpError_RhttpUnknownError extends RhttpError {
  const RhttpError_RhttpUnknownError(this.field0): super._();
  

 final  String field0;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RhttpError_RhttpUnknownErrorCopyWith<RhttpError_RhttpUnknownError> get copyWith => _$RhttpError_RhttpUnknownErrorCopyWithImpl<RhttpError_RhttpUnknownError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RhttpError_RhttpUnknownError&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RhttpError.rhttpUnknownError(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RhttpError_RhttpUnknownErrorCopyWith<$Res> implements $RhttpErrorCopyWith<$Res> {
  factory $RhttpError_RhttpUnknownErrorCopyWith(RhttpError_RhttpUnknownError value, $Res Function(RhttpError_RhttpUnknownError) _then) = _$RhttpError_RhttpUnknownErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RhttpError_RhttpUnknownErrorCopyWithImpl<$Res>
    implements $RhttpError_RhttpUnknownErrorCopyWith<$Res> {
  _$RhttpError_RhttpUnknownErrorCopyWithImpl(this._self, this._then);

  final RhttpError_RhttpUnknownError _self;
  final $Res Function(RhttpError_RhttpUnknownError) _then;

/// Create a copy of RhttpError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RhttpError_RhttpUnknownError(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
