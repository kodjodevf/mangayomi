// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HttpHeaders {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpHeaders&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'HttpHeaders(field0: $field0)';
}


}

/// @nodoc
class $HttpHeadersCopyWith<$Res>  {
$HttpHeadersCopyWith(HttpHeaders _, $Res Function(HttpHeaders) __);
}


/// Adds pattern-matching-related methods to [HttpHeaders].
extension HttpHeadersPatterns on HttpHeaders {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HttpHeaders_Map value)?  map,TResult Function( HttpHeaders_List value)?  list,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HttpHeaders_Map() when map != null:
return map(_that);case HttpHeaders_List() when list != null:
return list(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HttpHeaders_Map value)  map,required TResult Function( HttpHeaders_List value)  list,}){
final _that = this;
switch (_that) {
case HttpHeaders_Map():
return map(_that);case HttpHeaders_List():
return list(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HttpHeaders_Map value)?  map,TResult? Function( HttpHeaders_List value)?  list,}){
final _that = this;
switch (_that) {
case HttpHeaders_Map() when map != null:
return map(_that);case HttpHeaders_List() when list != null:
return list(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Map<String, String> field0)?  map,TResult Function( List<(String, String)> field0)?  list,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HttpHeaders_Map() when map != null:
return map(_that.field0);case HttpHeaders_List() when list != null:
return list(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Map<String, String> field0)  map,required TResult Function( List<(String, String)> field0)  list,}) {final _that = this;
switch (_that) {
case HttpHeaders_Map():
return map(_that.field0);case HttpHeaders_List():
return list(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Map<String, String> field0)?  map,TResult? Function( List<(String, String)> field0)?  list,}) {final _that = this;
switch (_that) {
case HttpHeaders_Map() when map != null:
return map(_that.field0);case HttpHeaders_List() when list != null:
return list(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class HttpHeaders_Map extends HttpHeaders {
  const HttpHeaders_Map(final  Map<String, String> field0): _field0 = field0,super._();
  

 final  Map<String, String> _field0;
@override Map<String, String> get field0 {
  if (_field0 is EqualUnmodifiableMapView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_field0);
}


/// Create a copy of HttpHeaders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpHeaders_MapCopyWith<HttpHeaders_Map> get copyWith => _$HttpHeaders_MapCopyWithImpl<HttpHeaders_Map>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpHeaders_Map&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'HttpHeaders.map(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $HttpHeaders_MapCopyWith<$Res> implements $HttpHeadersCopyWith<$Res> {
  factory $HttpHeaders_MapCopyWith(HttpHeaders_Map value, $Res Function(HttpHeaders_Map) _then) = _$HttpHeaders_MapCopyWithImpl;
@useResult
$Res call({
 Map<String, String> field0
});




}
/// @nodoc
class _$HttpHeaders_MapCopyWithImpl<$Res>
    implements $HttpHeaders_MapCopyWith<$Res> {
  _$HttpHeaders_MapCopyWithImpl(this._self, this._then);

  final HttpHeaders_Map _self;
  final $Res Function(HttpHeaders_Map) _then;

/// Create a copy of HttpHeaders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(HttpHeaders_Map(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc


class HttpHeaders_List extends HttpHeaders {
  const HttpHeaders_List(final  List<(String, String)> field0): _field0 = field0,super._();
  

 final  List<(String, String)> _field0;
@override List<(String, String)> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of HttpHeaders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpHeaders_ListCopyWith<HttpHeaders_List> get copyWith => _$HttpHeaders_ListCopyWithImpl<HttpHeaders_List>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpHeaders_List&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'HttpHeaders.list(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $HttpHeaders_ListCopyWith<$Res> implements $HttpHeadersCopyWith<$Res> {
  factory $HttpHeaders_ListCopyWith(HttpHeaders_List value, $Res Function(HttpHeaders_List) _then) = _$HttpHeaders_ListCopyWithImpl;
@useResult
$Res call({
 List<(String, String)> field0
});




}
/// @nodoc
class _$HttpHeaders_ListCopyWithImpl<$Res>
    implements $HttpHeaders_ListCopyWith<$Res> {
  _$HttpHeaders_ListCopyWithImpl(this._self, this._then);

  final HttpHeaders_List _self;
  final $Res Function(HttpHeaders_List) _then;

/// Create a copy of HttpHeaders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(HttpHeaders_List(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<(String, String)>,
  ));
}


}

/// @nodoc
mixin _$HttpResponseBody {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponseBody);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpResponseBody()';
}


}

/// @nodoc
class $HttpResponseBodyCopyWith<$Res>  {
$HttpResponseBodyCopyWith(HttpResponseBody _, $Res Function(HttpResponseBody) __);
}


/// Adds pattern-matching-related methods to [HttpResponseBody].
extension HttpResponseBodyPatterns on HttpResponseBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HttpResponseBody_Text value)?  text,TResult Function( HttpResponseBody_Bytes value)?  bytes,TResult Function( HttpResponseBody_Stream value)?  stream,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HttpResponseBody_Text() when text != null:
return text(_that);case HttpResponseBody_Bytes() when bytes != null:
return bytes(_that);case HttpResponseBody_Stream() when stream != null:
return stream(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HttpResponseBody_Text value)  text,required TResult Function( HttpResponseBody_Bytes value)  bytes,required TResult Function( HttpResponseBody_Stream value)  stream,}){
final _that = this;
switch (_that) {
case HttpResponseBody_Text():
return text(_that);case HttpResponseBody_Bytes():
return bytes(_that);case HttpResponseBody_Stream():
return stream(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HttpResponseBody_Text value)?  text,TResult? Function( HttpResponseBody_Bytes value)?  bytes,TResult? Function( HttpResponseBody_Stream value)?  stream,}){
final _that = this;
switch (_that) {
case HttpResponseBody_Text() when text != null:
return text(_that);case HttpResponseBody_Bytes() when bytes != null:
return bytes(_that);case HttpResponseBody_Stream() when stream != null:
return stream(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String field0)?  text,TResult Function( Uint8List field0)?  bytes,TResult Function()?  stream,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HttpResponseBody_Text() when text != null:
return text(_that.field0);case HttpResponseBody_Bytes() when bytes != null:
return bytes(_that.field0);case HttpResponseBody_Stream() when stream != null:
return stream();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String field0)  text,required TResult Function( Uint8List field0)  bytes,required TResult Function()  stream,}) {final _that = this;
switch (_that) {
case HttpResponseBody_Text():
return text(_that.field0);case HttpResponseBody_Bytes():
return bytes(_that.field0);case HttpResponseBody_Stream():
return stream();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String field0)?  text,TResult? Function( Uint8List field0)?  bytes,TResult? Function()?  stream,}) {final _that = this;
switch (_that) {
case HttpResponseBody_Text() when text != null:
return text(_that.field0);case HttpResponseBody_Bytes() when bytes != null:
return bytes(_that.field0);case HttpResponseBody_Stream() when stream != null:
return stream();case _:
  return null;

}
}

}

/// @nodoc


class HttpResponseBody_Text extends HttpResponseBody {
  const HttpResponseBody_Text(this.field0): super._();
  

 final  String field0;

/// Create a copy of HttpResponseBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpResponseBody_TextCopyWith<HttpResponseBody_Text> get copyWith => _$HttpResponseBody_TextCopyWithImpl<HttpResponseBody_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponseBody_Text&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'HttpResponseBody.text(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $HttpResponseBody_TextCopyWith<$Res> implements $HttpResponseBodyCopyWith<$Res> {
  factory $HttpResponseBody_TextCopyWith(HttpResponseBody_Text value, $Res Function(HttpResponseBody_Text) _then) = _$HttpResponseBody_TextCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$HttpResponseBody_TextCopyWithImpl<$Res>
    implements $HttpResponseBody_TextCopyWith<$Res> {
  _$HttpResponseBody_TextCopyWithImpl(this._self, this._then);

  final HttpResponseBody_Text _self;
  final $Res Function(HttpResponseBody_Text) _then;

/// Create a copy of HttpResponseBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(HttpResponseBody_Text(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HttpResponseBody_Bytes extends HttpResponseBody {
  const HttpResponseBody_Bytes(this.field0): super._();
  

 final  Uint8List field0;

/// Create a copy of HttpResponseBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpResponseBody_BytesCopyWith<HttpResponseBody_Bytes> get copyWith => _$HttpResponseBody_BytesCopyWithImpl<HttpResponseBody_Bytes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponseBody_Bytes&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'HttpResponseBody.bytes(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $HttpResponseBody_BytesCopyWith<$Res> implements $HttpResponseBodyCopyWith<$Res> {
  factory $HttpResponseBody_BytesCopyWith(HttpResponseBody_Bytes value, $Res Function(HttpResponseBody_Bytes) _then) = _$HttpResponseBody_BytesCopyWithImpl;
@useResult
$Res call({
 Uint8List field0
});




}
/// @nodoc
class _$HttpResponseBody_BytesCopyWithImpl<$Res>
    implements $HttpResponseBody_BytesCopyWith<$Res> {
  _$HttpResponseBody_BytesCopyWithImpl(this._self, this._then);

  final HttpResponseBody_Bytes _self;
  final $Res Function(HttpResponseBody_Bytes) _then;

/// Create a copy of HttpResponseBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(HttpResponseBody_Bytes(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class HttpResponseBody_Stream extends HttpResponseBody {
  const HttpResponseBody_Stream(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponseBody_Stream);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpResponseBody.stream()';
}


}




// dart format on
