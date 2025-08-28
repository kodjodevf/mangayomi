// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
