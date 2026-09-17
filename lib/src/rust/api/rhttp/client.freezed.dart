// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProxySettings {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxySettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProxySettings()';
}


}

/// @nodoc
class $ProxySettingsCopyWith<$Res>  {
$ProxySettingsCopyWith(ProxySettings _, $Res Function(ProxySettings) __);
}


/// Adds pattern-matching-related methods to [ProxySettings].
extension ProxySettingsPatterns on ProxySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProxySettings_NoProxy value)?  noProxy,TResult Function( ProxySettings_CustomProxyList value)?  customProxyList,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProxySettings_NoProxy() when noProxy != null:
return noProxy(_that);case ProxySettings_CustomProxyList() when customProxyList != null:
return customProxyList(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProxySettings_NoProxy value)  noProxy,required TResult Function( ProxySettings_CustomProxyList value)  customProxyList,}){
final _that = this;
switch (_that) {
case ProxySettings_NoProxy():
return noProxy(_that);case ProxySettings_CustomProxyList():
return customProxyList(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProxySettings_NoProxy value)?  noProxy,TResult? Function( ProxySettings_CustomProxyList value)?  customProxyList,}){
final _that = this;
switch (_that) {
case ProxySettings_NoProxy() when noProxy != null:
return noProxy(_that);case ProxySettings_CustomProxyList() when customProxyList != null:
return customProxyList(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noProxy,TResult Function( List<CustomProxy> field0)?  customProxyList,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProxySettings_NoProxy() when noProxy != null:
return noProxy();case ProxySettings_CustomProxyList() when customProxyList != null:
return customProxyList(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noProxy,required TResult Function( List<CustomProxy> field0)  customProxyList,}) {final _that = this;
switch (_that) {
case ProxySettings_NoProxy():
return noProxy();case ProxySettings_CustomProxyList():
return customProxyList(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noProxy,TResult? Function( List<CustomProxy> field0)?  customProxyList,}) {final _that = this;
switch (_that) {
case ProxySettings_NoProxy() when noProxy != null:
return noProxy();case ProxySettings_CustomProxyList() when customProxyList != null:
return customProxyList(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ProxySettings_NoProxy extends ProxySettings {
  const ProxySettings_NoProxy(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxySettings_NoProxy);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProxySettings.noProxy()';
}


}




/// @nodoc


class ProxySettings_CustomProxyList extends ProxySettings {
  const ProxySettings_CustomProxyList(final  List<CustomProxy> field0): _field0 = field0,super._();
  

 final  List<CustomProxy> _field0;
 List<CustomProxy> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxySettings_CustomProxyListCopyWith<ProxySettings_CustomProxyList> get copyWith => _$ProxySettings_CustomProxyListCopyWithImpl<ProxySettings_CustomProxyList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxySettings_CustomProxyList&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'ProxySettings.customProxyList(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ProxySettings_CustomProxyListCopyWith<$Res> implements $ProxySettingsCopyWith<$Res> {
  factory $ProxySettings_CustomProxyListCopyWith(ProxySettings_CustomProxyList value, $Res Function(ProxySettings_CustomProxyList) _then) = _$ProxySettings_CustomProxyListCopyWithImpl;
@useResult
$Res call({
 List<CustomProxy> field0
});




}
/// @nodoc
class _$ProxySettings_CustomProxyListCopyWithImpl<$Res>
    implements $ProxySettings_CustomProxyListCopyWith<$Res> {
  _$ProxySettings_CustomProxyListCopyWithImpl(this._self, this._then);

  final ProxySettings_CustomProxyList _self;
  final $Res Function(ProxySettings_CustomProxyList) _then;

/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ProxySettings_CustomProxyList(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<CustomProxy>,
  ));
}


}

/// @nodoc
mixin _$RedirectSettings {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedirectSettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RedirectSettings()';
}


}

/// @nodoc
class $RedirectSettingsCopyWith<$Res>  {
$RedirectSettingsCopyWith(RedirectSettings _, $Res Function(RedirectSettings) __);
}


/// Adds pattern-matching-related methods to [RedirectSettings].
extension RedirectSettingsPatterns on RedirectSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RedirectSettings_NoRedirect value)?  noRedirect,TResult Function( RedirectSettings_LimitedRedirects value)?  limitedRedirects,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect() when noRedirect != null:
return noRedirect(_that);case RedirectSettings_LimitedRedirects() when limitedRedirects != null:
return limitedRedirects(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RedirectSettings_NoRedirect value)  noRedirect,required TResult Function( RedirectSettings_LimitedRedirects value)  limitedRedirects,}){
final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect():
return noRedirect(_that);case RedirectSettings_LimitedRedirects():
return limitedRedirects(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RedirectSettings_NoRedirect value)?  noRedirect,TResult? Function( RedirectSettings_LimitedRedirects value)?  limitedRedirects,}){
final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect() when noRedirect != null:
return noRedirect(_that);case RedirectSettings_LimitedRedirects() when limitedRedirects != null:
return limitedRedirects(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noRedirect,TResult Function( int field0)?  limitedRedirects,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect() when noRedirect != null:
return noRedirect();case RedirectSettings_LimitedRedirects() when limitedRedirects != null:
return limitedRedirects(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noRedirect,required TResult Function( int field0)  limitedRedirects,}) {final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect():
return noRedirect();case RedirectSettings_LimitedRedirects():
return limitedRedirects(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noRedirect,TResult? Function( int field0)?  limitedRedirects,}) {final _that = this;
switch (_that) {
case RedirectSettings_NoRedirect() when noRedirect != null:
return noRedirect();case RedirectSettings_LimitedRedirects() when limitedRedirects != null:
return limitedRedirects(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class RedirectSettings_NoRedirect extends RedirectSettings {
  const RedirectSettings_NoRedirect(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedirectSettings_NoRedirect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RedirectSettings.noRedirect()';
}


}




/// @nodoc


class RedirectSettings_LimitedRedirects extends RedirectSettings {
  const RedirectSettings_LimitedRedirects(this.field0): super._();
  

 final  int field0;

/// Create a copy of RedirectSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedirectSettings_LimitedRedirectsCopyWith<RedirectSettings_LimitedRedirects> get copyWith => _$RedirectSettings_LimitedRedirectsCopyWithImpl<RedirectSettings_LimitedRedirects>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedirectSettings_LimitedRedirects&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RedirectSettings.limitedRedirects(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RedirectSettings_LimitedRedirectsCopyWith<$Res> implements $RedirectSettingsCopyWith<$Res> {
  factory $RedirectSettings_LimitedRedirectsCopyWith(RedirectSettings_LimitedRedirects value, $Res Function(RedirectSettings_LimitedRedirects) _then) = _$RedirectSettings_LimitedRedirectsCopyWithImpl;
@useResult
$Res call({
 int field0
});




}
/// @nodoc
class _$RedirectSettings_LimitedRedirectsCopyWithImpl<$Res>
    implements $RedirectSettings_LimitedRedirectsCopyWith<$Res> {
  _$RedirectSettings_LimitedRedirectsCopyWithImpl(this._self, this._then);

  final RedirectSettings_LimitedRedirects _self;
  final $Res Function(RedirectSettings_LimitedRedirects) _then;

/// Create a copy of RedirectSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RedirectSettings_LimitedRedirects(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
