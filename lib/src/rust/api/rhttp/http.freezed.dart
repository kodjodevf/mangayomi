// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HttpHeaders {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, String> field0) map,
    required TResult Function(List<(String, String)> field0) list,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, String> field0)? map,
    TResult? Function(List<(String, String)> field0)? list,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, String> field0)? map,
    TResult Function(List<(String, String)> field0)? list,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpHeaders_Map value) map,
    required TResult Function(HttpHeaders_List value) list,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpHeaders_Map value)? map,
    TResult? Function(HttpHeaders_List value)? list,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpHeaders_Map value)? map,
    TResult Function(HttpHeaders_List value)? list,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpHeadersCopyWith<$Res> {
  factory $HttpHeadersCopyWith(
    HttpHeaders value,
    $Res Function(HttpHeaders) then,
  ) = _$HttpHeadersCopyWithImpl<$Res, HttpHeaders>;
}

/// @nodoc
class _$HttpHeadersCopyWithImpl<$Res, $Val extends HttpHeaders>
    implements $HttpHeadersCopyWith<$Res> {
  _$HttpHeadersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HttpHeaders_MapImplCopyWith<$Res> {
  factory _$$HttpHeaders_MapImplCopyWith(
    _$HttpHeaders_MapImpl value,
    $Res Function(_$HttpHeaders_MapImpl) then,
  ) = __$$HttpHeaders_MapImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, String> field0});
}

/// @nodoc
class __$$HttpHeaders_MapImplCopyWithImpl<$Res>
    extends _$HttpHeadersCopyWithImpl<$Res, _$HttpHeaders_MapImpl>
    implements _$$HttpHeaders_MapImplCopyWith<$Res> {
  __$$HttpHeaders_MapImplCopyWithImpl(
    _$HttpHeaders_MapImpl _value,
    $Res Function(_$HttpHeaders_MapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$HttpHeaders_MapImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$HttpHeaders_MapImpl extends HttpHeaders_Map {
  const _$HttpHeaders_MapImpl(final Map<String, String> field0)
    : _field0 = field0,
      super._();

  final Map<String, String> _field0;
  @override
  Map<String, String> get field0 {
    if (_field0 is EqualUnmodifiableMapView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_field0);
  }

  @override
  String toString() {
    return 'HttpHeaders.map(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpHeaders_MapImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpHeaders_MapImplCopyWith<_$HttpHeaders_MapImpl> get copyWith =>
      __$$HttpHeaders_MapImplCopyWithImpl<_$HttpHeaders_MapImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, String> field0) map,
    required TResult Function(List<(String, String)> field0) list,
  }) {
    return map(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, String> field0)? map,
    TResult? Function(List<(String, String)> field0)? list,
  }) {
    return map?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, String> field0)? map,
    TResult Function(List<(String, String)> field0)? list,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpHeaders_Map value) map,
    required TResult Function(HttpHeaders_List value) list,
  }) {
    return map(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpHeaders_Map value)? map,
    TResult? Function(HttpHeaders_List value)? list,
  }) {
    return map?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpHeaders_Map value)? map,
    TResult Function(HttpHeaders_List value)? list,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(this);
    }
    return orElse();
  }
}

abstract class HttpHeaders_Map extends HttpHeaders {
  const factory HttpHeaders_Map(final Map<String, String> field0) =
      _$HttpHeaders_MapImpl;
  const HttpHeaders_Map._() : super._();

  @override
  Map<String, String> get field0;

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HttpHeaders_MapImplCopyWith<_$HttpHeaders_MapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HttpHeaders_ListImplCopyWith<$Res> {
  factory _$$HttpHeaders_ListImplCopyWith(
    _$HttpHeaders_ListImpl value,
    $Res Function(_$HttpHeaders_ListImpl) then,
  ) = __$$HttpHeaders_ListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<(String, String)> field0});
}

/// @nodoc
class __$$HttpHeaders_ListImplCopyWithImpl<$Res>
    extends _$HttpHeadersCopyWithImpl<$Res, _$HttpHeaders_ListImpl>
    implements _$$HttpHeaders_ListImplCopyWith<$Res> {
  __$$HttpHeaders_ListImplCopyWithImpl(
    _$HttpHeaders_ListImpl _value,
    $Res Function(_$HttpHeaders_ListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$HttpHeaders_ListImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<(String, String)>,
      ),
    );
  }
}

/// @nodoc

class _$HttpHeaders_ListImpl extends HttpHeaders_List {
  const _$HttpHeaders_ListImpl(final List<(String, String)> field0)
    : _field0 = field0,
      super._();

  final List<(String, String)> _field0;
  @override
  List<(String, String)> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'HttpHeaders.list(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpHeaders_ListImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpHeaders_ListImplCopyWith<_$HttpHeaders_ListImpl> get copyWith =>
      __$$HttpHeaders_ListImplCopyWithImpl<_$HttpHeaders_ListImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, String> field0) map,
    required TResult Function(List<(String, String)> field0) list,
  }) {
    return list(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, String> field0)? map,
    TResult? Function(List<(String, String)> field0)? list,
  }) {
    return list?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, String> field0)? map,
    TResult Function(List<(String, String)> field0)? list,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpHeaders_Map value) map,
    required TResult Function(HttpHeaders_List value) list,
  }) {
    return list(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpHeaders_Map value)? map,
    TResult? Function(HttpHeaders_List value)? list,
  }) {
    return list?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpHeaders_Map value)? map,
    TResult Function(HttpHeaders_List value)? list,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(this);
    }
    return orElse();
  }
}

abstract class HttpHeaders_List extends HttpHeaders {
  const factory HttpHeaders_List(final List<(String, String)> field0) =
      _$HttpHeaders_ListImpl;
  const HttpHeaders_List._() : super._();

  @override
  List<(String, String)> get field0;

  /// Create a copy of HttpHeaders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HttpHeaders_ListImplCopyWith<_$HttpHeaders_ListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HttpResponseBody {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(Uint8List field0) bytes,
    required TResult Function() stream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(Uint8List field0)? bytes,
    TResult? Function()? stream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(Uint8List field0)? bytes,
    TResult Function()? stream,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpResponseBody_Text value) text,
    required TResult Function(HttpResponseBody_Bytes value) bytes,
    required TResult Function(HttpResponseBody_Stream value) stream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpResponseBody_Text value)? text,
    TResult? Function(HttpResponseBody_Bytes value)? bytes,
    TResult? Function(HttpResponseBody_Stream value)? stream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpResponseBody_Text value)? text,
    TResult Function(HttpResponseBody_Bytes value)? bytes,
    TResult Function(HttpResponseBody_Stream value)? stream,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpResponseBodyCopyWith<$Res> {
  factory $HttpResponseBodyCopyWith(
    HttpResponseBody value,
    $Res Function(HttpResponseBody) then,
  ) = _$HttpResponseBodyCopyWithImpl<$Res, HttpResponseBody>;
}

/// @nodoc
class _$HttpResponseBodyCopyWithImpl<$Res, $Val extends HttpResponseBody>
    implements $HttpResponseBodyCopyWith<$Res> {
  _$HttpResponseBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HttpResponseBody_TextImplCopyWith<$Res> {
  factory _$$HttpResponseBody_TextImplCopyWith(
    _$HttpResponseBody_TextImpl value,
    $Res Function(_$HttpResponseBody_TextImpl) then,
  ) = __$$HttpResponseBody_TextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$HttpResponseBody_TextImplCopyWithImpl<$Res>
    extends _$HttpResponseBodyCopyWithImpl<$Res, _$HttpResponseBody_TextImpl>
    implements _$$HttpResponseBody_TextImplCopyWith<$Res> {
  __$$HttpResponseBody_TextImplCopyWithImpl(
    _$HttpResponseBody_TextImpl _value,
    $Res Function(_$HttpResponseBody_TextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$HttpResponseBody_TextImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$HttpResponseBody_TextImpl extends HttpResponseBody_Text {
  const _$HttpResponseBody_TextImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'HttpResponseBody.text(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpResponseBody_TextImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpResponseBody_TextImplCopyWith<_$HttpResponseBody_TextImpl>
  get copyWith =>
      __$$HttpResponseBody_TextImplCopyWithImpl<_$HttpResponseBody_TextImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(Uint8List field0) bytes,
    required TResult Function() stream,
  }) {
    return text(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(Uint8List field0)? bytes,
    TResult? Function()? stream,
  }) {
    return text?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(Uint8List field0)? bytes,
    TResult Function()? stream,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpResponseBody_Text value) text,
    required TResult Function(HttpResponseBody_Bytes value) bytes,
    required TResult Function(HttpResponseBody_Stream value) stream,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpResponseBody_Text value)? text,
    TResult? Function(HttpResponseBody_Bytes value)? bytes,
    TResult? Function(HttpResponseBody_Stream value)? stream,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpResponseBody_Text value)? text,
    TResult Function(HttpResponseBody_Bytes value)? bytes,
    TResult Function(HttpResponseBody_Stream value)? stream,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class HttpResponseBody_Text extends HttpResponseBody {
  const factory HttpResponseBody_Text(final String field0) =
      _$HttpResponseBody_TextImpl;
  const HttpResponseBody_Text._() : super._();

  String get field0;

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HttpResponseBody_TextImplCopyWith<_$HttpResponseBody_TextImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HttpResponseBody_BytesImplCopyWith<$Res> {
  factory _$$HttpResponseBody_BytesImplCopyWith(
    _$HttpResponseBody_BytesImpl value,
    $Res Function(_$HttpResponseBody_BytesImpl) then,
  ) = __$$HttpResponseBody_BytesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List field0});
}

/// @nodoc
class __$$HttpResponseBody_BytesImplCopyWithImpl<$Res>
    extends _$HttpResponseBodyCopyWithImpl<$Res, _$HttpResponseBody_BytesImpl>
    implements _$$HttpResponseBody_BytesImplCopyWith<$Res> {
  __$$HttpResponseBody_BytesImplCopyWithImpl(
    _$HttpResponseBody_BytesImpl _value,
    $Res Function(_$HttpResponseBody_BytesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$HttpResponseBody_BytesImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$HttpResponseBody_BytesImpl extends HttpResponseBody_Bytes {
  const _$HttpResponseBody_BytesImpl(this.field0) : super._();

  @override
  final Uint8List field0;

  @override
  String toString() {
    return 'HttpResponseBody.bytes(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpResponseBody_BytesImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpResponseBody_BytesImplCopyWith<_$HttpResponseBody_BytesImpl>
  get copyWith =>
      __$$HttpResponseBody_BytesImplCopyWithImpl<_$HttpResponseBody_BytesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(Uint8List field0) bytes,
    required TResult Function() stream,
  }) {
    return bytes(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(Uint8List field0)? bytes,
    TResult? Function()? stream,
  }) {
    return bytes?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(Uint8List field0)? bytes,
    TResult Function()? stream,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpResponseBody_Text value) text,
    required TResult Function(HttpResponseBody_Bytes value) bytes,
    required TResult Function(HttpResponseBody_Stream value) stream,
  }) {
    return bytes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpResponseBody_Text value)? text,
    TResult? Function(HttpResponseBody_Bytes value)? bytes,
    TResult? Function(HttpResponseBody_Stream value)? stream,
  }) {
    return bytes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpResponseBody_Text value)? text,
    TResult Function(HttpResponseBody_Bytes value)? bytes,
    TResult Function(HttpResponseBody_Stream value)? stream,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(this);
    }
    return orElse();
  }
}

abstract class HttpResponseBody_Bytes extends HttpResponseBody {
  const factory HttpResponseBody_Bytes(final Uint8List field0) =
      _$HttpResponseBody_BytesImpl;
  const HttpResponseBody_Bytes._() : super._();

  Uint8List get field0;

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HttpResponseBody_BytesImplCopyWith<_$HttpResponseBody_BytesImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HttpResponseBody_StreamImplCopyWith<$Res> {
  factory _$$HttpResponseBody_StreamImplCopyWith(
    _$HttpResponseBody_StreamImpl value,
    $Res Function(_$HttpResponseBody_StreamImpl) then,
  ) = __$$HttpResponseBody_StreamImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HttpResponseBody_StreamImplCopyWithImpl<$Res>
    extends _$HttpResponseBodyCopyWithImpl<$Res, _$HttpResponseBody_StreamImpl>
    implements _$$HttpResponseBody_StreamImplCopyWith<$Res> {
  __$$HttpResponseBody_StreamImplCopyWithImpl(
    _$HttpResponseBody_StreamImpl _value,
    $Res Function(_$HttpResponseBody_StreamImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HttpResponseBody
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HttpResponseBody_StreamImpl extends HttpResponseBody_Stream {
  const _$HttpResponseBody_StreamImpl() : super._();

  @override
  String toString() {
    return 'HttpResponseBody.stream()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpResponseBody_StreamImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(Uint8List field0) bytes,
    required TResult Function() stream,
  }) {
    return stream();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(Uint8List field0)? bytes,
    TResult? Function()? stream,
  }) {
    return stream?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(Uint8List field0)? bytes,
    TResult Function()? stream,
    required TResult orElse(),
  }) {
    if (stream != null) {
      return stream();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HttpResponseBody_Text value) text,
    required TResult Function(HttpResponseBody_Bytes value) bytes,
    required TResult Function(HttpResponseBody_Stream value) stream,
  }) {
    return stream(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HttpResponseBody_Text value)? text,
    TResult? Function(HttpResponseBody_Bytes value)? bytes,
    TResult? Function(HttpResponseBody_Stream value)? stream,
  }) {
    return stream?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HttpResponseBody_Text value)? text,
    TResult Function(HttpResponseBody_Bytes value)? bytes,
    TResult Function(HttpResponseBody_Stream value)? stream,
    required TResult orElse(),
  }) {
    if (stream != null) {
      return stream(this);
    }
    return orElse();
  }
}

abstract class HttpResponseBody_Stream extends HttpResponseBody {
  const factory HttpResponseBody_Stream() = _$HttpResponseBody_StreamImpl;
  const HttpResponseBody_Stream._() : super._();
}
