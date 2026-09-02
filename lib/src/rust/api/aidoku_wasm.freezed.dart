// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aidoku_wasm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AidokuFilterValue {

 String get id;
/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValueCopyWith<AidokuFilterValue> get copyWith => _$AidokuFilterValueCopyWithImpl<AidokuFilterValue>(this as AidokuFilterValue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AidokuFilterValue(id: $id)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValueCopyWith<$Res>  {
  factory $AidokuFilterValueCopyWith(AidokuFilterValue value, $Res Function(AidokuFilterValue) _then) = _$AidokuFilterValueCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$AidokuFilterValueCopyWithImpl<$Res>
    implements $AidokuFilterValueCopyWith<$Res> {
  _$AidokuFilterValueCopyWithImpl(this._self, this._then);

  final AidokuFilterValue _self;
  final $Res Function(AidokuFilterValue) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AidokuFilterValue].
extension AidokuFilterValuePatterns on AidokuFilterValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AidokuFilterValue_Text value)?  text,TResult Function( AidokuFilterValue_Sort value)?  sort,TResult Function( AidokuFilterValue_Check value)?  check,TResult Function( AidokuFilterValue_Select value)?  select,TResult Function( AidokuFilterValue_MultiSelect value)?  multiSelect,TResult Function( AidokuFilterValue_Range value)?  range,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AidokuFilterValue_Text() when text != null:
return text(_that);case AidokuFilterValue_Sort() when sort != null:
return sort(_that);case AidokuFilterValue_Check() when check != null:
return check(_that);case AidokuFilterValue_Select() when select != null:
return select(_that);case AidokuFilterValue_MultiSelect() when multiSelect != null:
return multiSelect(_that);case AidokuFilterValue_Range() when range != null:
return range(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AidokuFilterValue_Text value)  text,required TResult Function( AidokuFilterValue_Sort value)  sort,required TResult Function( AidokuFilterValue_Check value)  check,required TResult Function( AidokuFilterValue_Select value)  select,required TResult Function( AidokuFilterValue_MultiSelect value)  multiSelect,required TResult Function( AidokuFilterValue_Range value)  range,}){
final _that = this;
switch (_that) {
case AidokuFilterValue_Text():
return text(_that);case AidokuFilterValue_Sort():
return sort(_that);case AidokuFilterValue_Check():
return check(_that);case AidokuFilterValue_Select():
return select(_that);case AidokuFilterValue_MultiSelect():
return multiSelect(_that);case AidokuFilterValue_Range():
return range(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AidokuFilterValue_Text value)?  text,TResult? Function( AidokuFilterValue_Sort value)?  sort,TResult? Function( AidokuFilterValue_Check value)?  check,TResult? Function( AidokuFilterValue_Select value)?  select,TResult? Function( AidokuFilterValue_MultiSelect value)?  multiSelect,TResult? Function( AidokuFilterValue_Range value)?  range,}){
final _that = this;
switch (_that) {
case AidokuFilterValue_Text() when text != null:
return text(_that);case AidokuFilterValue_Sort() when sort != null:
return sort(_that);case AidokuFilterValue_Check() when check != null:
return check(_that);case AidokuFilterValue_Select() when select != null:
return select(_that);case AidokuFilterValue_MultiSelect() when multiSelect != null:
return multiSelect(_that);case AidokuFilterValue_Range() when range != null:
return range(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String value)?  text,TResult Function( String id,  int index,  bool ascending)?  sort,TResult Function( String id,  PlatformInt64 value)?  check,TResult Function( String id,  String value)?  select,TResult Function( String id,  List<String> included,  List<String> excluded)?  multiSelect,TResult Function( String id,  double? from,  double? to)?  range,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AidokuFilterValue_Text() when text != null:
return text(_that.id,_that.value);case AidokuFilterValue_Sort() when sort != null:
return sort(_that.id,_that.index,_that.ascending);case AidokuFilterValue_Check() when check != null:
return check(_that.id,_that.value);case AidokuFilterValue_Select() when select != null:
return select(_that.id,_that.value);case AidokuFilterValue_MultiSelect() when multiSelect != null:
return multiSelect(_that.id,_that.included,_that.excluded);case AidokuFilterValue_Range() when range != null:
return range(_that.id,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String value)  text,required TResult Function( String id,  int index,  bool ascending)  sort,required TResult Function( String id,  PlatformInt64 value)  check,required TResult Function( String id,  String value)  select,required TResult Function( String id,  List<String> included,  List<String> excluded)  multiSelect,required TResult Function( String id,  double? from,  double? to)  range,}) {final _that = this;
switch (_that) {
case AidokuFilterValue_Text():
return text(_that.id,_that.value);case AidokuFilterValue_Sort():
return sort(_that.id,_that.index,_that.ascending);case AidokuFilterValue_Check():
return check(_that.id,_that.value);case AidokuFilterValue_Select():
return select(_that.id,_that.value);case AidokuFilterValue_MultiSelect():
return multiSelect(_that.id,_that.included,_that.excluded);case AidokuFilterValue_Range():
return range(_that.id,_that.from,_that.to);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String value)?  text,TResult? Function( String id,  int index,  bool ascending)?  sort,TResult? Function( String id,  PlatformInt64 value)?  check,TResult? Function( String id,  String value)?  select,TResult? Function( String id,  List<String> included,  List<String> excluded)?  multiSelect,TResult? Function( String id,  double? from,  double? to)?  range,}) {final _that = this;
switch (_that) {
case AidokuFilterValue_Text() when text != null:
return text(_that.id,_that.value);case AidokuFilterValue_Sort() when sort != null:
return sort(_that.id,_that.index,_that.ascending);case AidokuFilterValue_Check() when check != null:
return check(_that.id,_that.value);case AidokuFilterValue_Select() when select != null:
return select(_that.id,_that.value);case AidokuFilterValue_MultiSelect() when multiSelect != null:
return multiSelect(_that.id,_that.included,_that.excluded);case AidokuFilterValue_Range() when range != null:
return range(_that.id,_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class AidokuFilterValue_Text extends AidokuFilterValue {
  const AidokuFilterValue_Text({required this.id, required this.value}): super._();
  

@override final  String id;
 final  String value;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_TextCopyWith<AidokuFilterValue_Text> get copyWith => _$AidokuFilterValue_TextCopyWithImpl<AidokuFilterValue_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_Text&&(identical(other.id, id) || other.id == id)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,id,value);

@override
String toString() {
  return 'AidokuFilterValue.text(id: $id, value: $value)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_TextCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_TextCopyWith(AidokuFilterValue_Text value, $Res Function(AidokuFilterValue_Text) _then) = _$AidokuFilterValue_TextCopyWithImpl;
@override @useResult
$Res call({
 String id, String value
});




}
/// @nodoc
class _$AidokuFilterValue_TextCopyWithImpl<$Res>
    implements $AidokuFilterValue_TextCopyWith<$Res> {
  _$AidokuFilterValue_TextCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_Text _self;
  final $Res Function(AidokuFilterValue_Text) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? value = null,}) {
  return _then(AidokuFilterValue_Text(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AidokuFilterValue_Sort extends AidokuFilterValue {
  const AidokuFilterValue_Sort({required this.id, required this.index, required this.ascending}): super._();
  

@override final  String id;
 final  int index;
 final  bool ascending;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_SortCopyWith<AidokuFilterValue_Sort> get copyWith => _$AidokuFilterValue_SortCopyWithImpl<AidokuFilterValue_Sort>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_Sort&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.ascending, ascending) || other.ascending == ascending));
}


@override
int get hashCode => Object.hash(runtimeType,id,index,ascending);

@override
String toString() {
  return 'AidokuFilterValue.sort(id: $id, index: $index, ascending: $ascending)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_SortCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_SortCopyWith(AidokuFilterValue_Sort value, $Res Function(AidokuFilterValue_Sort) _then) = _$AidokuFilterValue_SortCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, bool ascending
});




}
/// @nodoc
class _$AidokuFilterValue_SortCopyWithImpl<$Res>
    implements $AidokuFilterValue_SortCopyWith<$Res> {
  _$AidokuFilterValue_SortCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_Sort _self;
  final $Res Function(AidokuFilterValue_Sort) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? ascending = null,}) {
  return _then(AidokuFilterValue_Sort(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,ascending: null == ascending ? _self.ascending : ascending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AidokuFilterValue_Check extends AidokuFilterValue {
  const AidokuFilterValue_Check({required this.id, required this.value}): super._();
  

@override final  String id;
 final  PlatformInt64 value;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_CheckCopyWith<AidokuFilterValue_Check> get copyWith => _$AidokuFilterValue_CheckCopyWithImpl<AidokuFilterValue_Check>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_Check&&(identical(other.id, id) || other.id == id)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,id,value);

@override
String toString() {
  return 'AidokuFilterValue.check(id: $id, value: $value)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_CheckCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_CheckCopyWith(AidokuFilterValue_Check value, $Res Function(AidokuFilterValue_Check) _then) = _$AidokuFilterValue_CheckCopyWithImpl;
@override @useResult
$Res call({
 String id, PlatformInt64 value
});




}
/// @nodoc
class _$AidokuFilterValue_CheckCopyWithImpl<$Res>
    implements $AidokuFilterValue_CheckCopyWith<$Res> {
  _$AidokuFilterValue_CheckCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_Check _self;
  final $Res Function(AidokuFilterValue_Check) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? value = null,}) {
  return _then(AidokuFilterValue_Check(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class AidokuFilterValue_Select extends AidokuFilterValue {
  const AidokuFilterValue_Select({required this.id, required this.value}): super._();
  

@override final  String id;
 final  String value;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_SelectCopyWith<AidokuFilterValue_Select> get copyWith => _$AidokuFilterValue_SelectCopyWithImpl<AidokuFilterValue_Select>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_Select&&(identical(other.id, id) || other.id == id)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,id,value);

@override
String toString() {
  return 'AidokuFilterValue.select(id: $id, value: $value)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_SelectCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_SelectCopyWith(AidokuFilterValue_Select value, $Res Function(AidokuFilterValue_Select) _then) = _$AidokuFilterValue_SelectCopyWithImpl;
@override @useResult
$Res call({
 String id, String value
});




}
/// @nodoc
class _$AidokuFilterValue_SelectCopyWithImpl<$Res>
    implements $AidokuFilterValue_SelectCopyWith<$Res> {
  _$AidokuFilterValue_SelectCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_Select _self;
  final $Res Function(AidokuFilterValue_Select) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? value = null,}) {
  return _then(AidokuFilterValue_Select(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AidokuFilterValue_MultiSelect extends AidokuFilterValue {
  const AidokuFilterValue_MultiSelect({required this.id, required  List<String> included, required  List<String> excluded}): _included = included,_excluded = excluded,super._();
  

@override final  String id;
 final  List<String> _included;
 List<String> get included {
  if (_included is EqualUnmodifiableListView) return _included;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_included);
}

 final  List<String> _excluded;
 List<String> get excluded {
  if (_excluded is EqualUnmodifiableListView) return _excluded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excluded);
}


/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_MultiSelectCopyWith<AidokuFilterValue_MultiSelect> get copyWith => _$AidokuFilterValue_MultiSelectCopyWithImpl<AidokuFilterValue_MultiSelect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_MultiSelect&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._included, _included)&&const DeepCollectionEquality().equals(other._excluded, _excluded));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_included),const DeepCollectionEquality().hash(_excluded));

@override
String toString() {
  return 'AidokuFilterValue.multiSelect(id: $id, included: $included, excluded: $excluded)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_MultiSelectCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_MultiSelectCopyWith(AidokuFilterValue_MultiSelect value, $Res Function(AidokuFilterValue_MultiSelect) _then) = _$AidokuFilterValue_MultiSelectCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> included, List<String> excluded
});




}
/// @nodoc
class _$AidokuFilterValue_MultiSelectCopyWithImpl<$Res>
    implements $AidokuFilterValue_MultiSelectCopyWith<$Res> {
  _$AidokuFilterValue_MultiSelectCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_MultiSelect _self;
  final $Res Function(AidokuFilterValue_MultiSelect) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? included = null,Object? excluded = null,}) {
  return _then(AidokuFilterValue_MultiSelect(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,included: null == included ? _self._included : included // ignore: cast_nullable_to_non_nullable
as List<String>,excluded: null == excluded ? _self._excluded : excluded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class AidokuFilterValue_Range extends AidokuFilterValue {
  const AidokuFilterValue_Range({required this.id, this.from, this.to}): super._();
  

@override final  String id;
 final  double? from;
 final  double? to;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuFilterValue_RangeCopyWith<AidokuFilterValue_Range> get copyWith => _$AidokuFilterValue_RangeCopyWithImpl<AidokuFilterValue_Range>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuFilterValue_Range&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,id,from,to);

@override
String toString() {
  return 'AidokuFilterValue.range(id: $id, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $AidokuFilterValue_RangeCopyWith<$Res> implements $AidokuFilterValueCopyWith<$Res> {
  factory $AidokuFilterValue_RangeCopyWith(AidokuFilterValue_Range value, $Res Function(AidokuFilterValue_Range) _then) = _$AidokuFilterValue_RangeCopyWithImpl;
@override @useResult
$Res call({
 String id, double? from, double? to
});




}
/// @nodoc
class _$AidokuFilterValue_RangeCopyWithImpl<$Res>
    implements $AidokuFilterValue_RangeCopyWith<$Res> {
  _$AidokuFilterValue_RangeCopyWithImpl(this._self, this._then);

  final AidokuFilterValue_Range _self;
  final $Res Function(AidokuFilterValue_Range) _then;

/// Create a copy of AidokuFilterValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? from = freezed,Object? to = freezed,}) {
  return _then(AidokuFilterValue_Range(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as double?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$AidokuPage {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AidokuPage()';
}


}

/// @nodoc
class $AidokuPageCopyWith<$Res>  {
$AidokuPageCopyWith(AidokuPage _, $Res Function(AidokuPage) __);
}


/// Adds pattern-matching-related methods to [AidokuPage].
extension AidokuPagePatterns on AidokuPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AidokuPage_Url value)?  url,TResult Function( AidokuPage_Text value)?  text,TResult Function( AidokuPage_Image value)?  image,TResult Function( AidokuPage_ZipFile value)?  zipFile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AidokuPage_Url() when url != null:
return url(_that);case AidokuPage_Text() when text != null:
return text(_that);case AidokuPage_Image() when image != null:
return image(_that);case AidokuPage_ZipFile() when zipFile != null:
return zipFile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AidokuPage_Url value)  url,required TResult Function( AidokuPage_Text value)  text,required TResult Function( AidokuPage_Image value)  image,required TResult Function( AidokuPage_ZipFile value)  zipFile,}){
final _that = this;
switch (_that) {
case AidokuPage_Url():
return url(_that);case AidokuPage_Text():
return text(_that);case AidokuPage_Image():
return image(_that);case AidokuPage_ZipFile():
return zipFile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AidokuPage_Url value)?  url,TResult? Function( AidokuPage_Text value)?  text,TResult? Function( AidokuPage_Image value)?  image,TResult? Function( AidokuPage_ZipFile value)?  zipFile,}){
final _that = this;
switch (_that) {
case AidokuPage_Url() when url != null:
return url(_that);case AidokuPage_Text() when text != null:
return text(_that);case AidokuPage_Image() when image != null:
return image(_that);case AidokuPage_ZipFile() when zipFile != null:
return zipFile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String url,  List<(String, String)> context)?  url,TResult Function( String field0)?  text,TResult Function( Uint8List? data)?  image,TResult Function( String url,  String filePath)?  zipFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AidokuPage_Url() when url != null:
return url(_that.url,_that.context);case AidokuPage_Text() when text != null:
return text(_that.field0);case AidokuPage_Image() when image != null:
return image(_that.data);case AidokuPage_ZipFile() when zipFile != null:
return zipFile(_that.url,_that.filePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String url,  List<(String, String)> context)  url,required TResult Function( String field0)  text,required TResult Function( Uint8List? data)  image,required TResult Function( String url,  String filePath)  zipFile,}) {final _that = this;
switch (_that) {
case AidokuPage_Url():
return url(_that.url,_that.context);case AidokuPage_Text():
return text(_that.field0);case AidokuPage_Image():
return image(_that.data);case AidokuPage_ZipFile():
return zipFile(_that.url,_that.filePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String url,  List<(String, String)> context)?  url,TResult? Function( String field0)?  text,TResult? Function( Uint8List? data)?  image,TResult? Function( String url,  String filePath)?  zipFile,}) {final _that = this;
switch (_that) {
case AidokuPage_Url() when url != null:
return url(_that.url,_that.context);case AidokuPage_Text() when text != null:
return text(_that.field0);case AidokuPage_Image() when image != null:
return image(_that.data);case AidokuPage_ZipFile() when zipFile != null:
return zipFile(_that.url,_that.filePath);case _:
  return null;

}
}

}

/// @nodoc


class AidokuPage_Url extends AidokuPage {
  const AidokuPage_Url({required this.url, required  List<(String, String)> context}): _context = context,super._();
  

 final  String url;
 final  List<(String, String)> _context;
 List<(String, String)> get context {
  if (_context is EqualUnmodifiableListView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_context);
}


/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuPage_UrlCopyWith<AidokuPage_Url> get copyWith => _$AidokuPage_UrlCopyWithImpl<AidokuPage_Url>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuPage_Url&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._context, _context));
}


@override
int get hashCode => Object.hash(runtimeType,url,const DeepCollectionEquality().hash(_context));

@override
String toString() {
  return 'AidokuPage.url(url: $url, context: $context)';
}


}

/// @nodoc
abstract mixin class $AidokuPage_UrlCopyWith<$Res> implements $AidokuPageCopyWith<$Res> {
  factory $AidokuPage_UrlCopyWith(AidokuPage_Url value, $Res Function(AidokuPage_Url) _then) = _$AidokuPage_UrlCopyWithImpl;
@useResult
$Res call({
 String url, List<(String, String)> context
});




}
/// @nodoc
class _$AidokuPage_UrlCopyWithImpl<$Res>
    implements $AidokuPage_UrlCopyWith<$Res> {
  _$AidokuPage_UrlCopyWithImpl(this._self, this._then);

  final AidokuPage_Url _self;
  final $Res Function(AidokuPage_Url) _then;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,Object? context = null,}) {
  return _then(AidokuPage_Url(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as List<(String, String)>,
  ));
}


}

/// @nodoc


class AidokuPage_Text extends AidokuPage {
  const AidokuPage_Text(this.field0): super._();
  

 final  String field0;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuPage_TextCopyWith<AidokuPage_Text> get copyWith => _$AidokuPage_TextCopyWithImpl<AidokuPage_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuPage_Text&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'AidokuPage.text(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $AidokuPage_TextCopyWith<$Res> implements $AidokuPageCopyWith<$Res> {
  factory $AidokuPage_TextCopyWith(AidokuPage_Text value, $Res Function(AidokuPage_Text) _then) = _$AidokuPage_TextCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$AidokuPage_TextCopyWithImpl<$Res>
    implements $AidokuPage_TextCopyWith<$Res> {
  _$AidokuPage_TextCopyWithImpl(this._self, this._then);

  final AidokuPage_Text _self;
  final $Res Function(AidokuPage_Text) _then;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(AidokuPage_Text(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AidokuPage_Image extends AidokuPage {
  const AidokuPage_Image({this.data}): super._();
  

 final  Uint8List? data;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuPage_ImageCopyWith<AidokuPage_Image> get copyWith => _$AidokuPage_ImageCopyWithImpl<AidokuPage_Image>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuPage_Image&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'AidokuPage.image(data: $data)';
}


}

/// @nodoc
abstract mixin class $AidokuPage_ImageCopyWith<$Res> implements $AidokuPageCopyWith<$Res> {
  factory $AidokuPage_ImageCopyWith(AidokuPage_Image value, $Res Function(AidokuPage_Image) _then) = _$AidokuPage_ImageCopyWithImpl;
@useResult
$Res call({
 Uint8List? data
});




}
/// @nodoc
class _$AidokuPage_ImageCopyWithImpl<$Res>
    implements $AidokuPage_ImageCopyWith<$Res> {
  _$AidokuPage_ImageCopyWithImpl(this._self, this._then);

  final AidokuPage_Image _self;
  final $Res Function(AidokuPage_Image) _then;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(AidokuPage_Image(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

/// @nodoc


class AidokuPage_ZipFile extends AidokuPage {
  const AidokuPage_ZipFile({required this.url, required this.filePath}): super._();
  

 final  String url;
 final  String filePath;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AidokuPage_ZipFileCopyWith<AidokuPage_ZipFile> get copyWith => _$AidokuPage_ZipFileCopyWithImpl<AidokuPage_ZipFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AidokuPage_ZipFile&&(identical(other.url, url) || other.url == url)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,url,filePath);

@override
String toString() {
  return 'AidokuPage.zipFile(url: $url, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class $AidokuPage_ZipFileCopyWith<$Res> implements $AidokuPageCopyWith<$Res> {
  factory $AidokuPage_ZipFileCopyWith(AidokuPage_ZipFile value, $Res Function(AidokuPage_ZipFile) _then) = _$AidokuPage_ZipFileCopyWithImpl;
@useResult
$Res call({
 String url, String filePath
});




}
/// @nodoc
class _$AidokuPage_ZipFileCopyWithImpl<$Res>
    implements $AidokuPage_ZipFileCopyWith<$Res> {
  _$AidokuPage_ZipFileCopyWithImpl(this._self, this._then);

  final AidokuPage_ZipFile _self;
  final $Res Function(AidokuPage_ZipFile) _then;

/// Create a copy of AidokuPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,Object? filePath = null,}) {
  return _then(AidokuPage_ZipFile(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
