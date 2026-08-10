// Generated Dart Protobuf definitions for Mihon ExtensionStore (.pb)

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ExtensionStoreContact extends $pb.GeneratedMessage {
  factory ExtensionStoreContact({
    $core.String? website,
    $core.String? discord,
  }) {
    final result = create();
    if (website != null) result.website = website;
    if (discord != null) result.discord = discord;
    return result;
  }

  ExtensionStoreContact._();

  factory ExtensionStoreContact.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory ExtensionStoreContact.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'ExtensionStoreContact',
        createEmptyInstance: create,
      )
        ..aOS(1, _omitFieldNames ? '' : 'website')
        ..aOS(2, _omitFieldNames ? '' : 'discord')
        ..hasRequiredFields = false;

  @$core.override
  ExtensionStoreContact clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreContact create() => ExtensionStoreContact._();

  @$core.override
  ExtensionStoreContact createEmptyInstance() => create();

  static $pb.PbList<ExtensionStoreContact> createRepeated() =>
      $pb.PbList<ExtensionStoreContact>();

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreContact getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        ExtensionStoreContact
      >(create);
  static ExtensionStoreContact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get website => $_getSZ(0);
  @$pb.TagNumber(1)
  set website($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(2)
  $core.String get discord => $_getSZ(1);
  @$pb.TagNumber(2)
  set discord($core.String v) {
    $_setString(1, v);
  }
}

class ExtensionStoreResources extends $pb.GeneratedMessage {
  factory ExtensionStoreResources({
    $core.String? apkUrl,
    $core.String? iconUrl,
  }) {
    final result = create();
    if (apkUrl != null) result.apkUrl = apkUrl;
    if (iconUrl != null) result.iconUrl = iconUrl;
    return result;
  }

  ExtensionStoreResources._();

  factory ExtensionStoreResources.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory ExtensionStoreResources.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'ExtensionStoreResources',
        createEmptyInstance: create,
      )
        ..aOS(1, _omitFieldNames ? '' : 'apkUrl', protoName: 'apkUrl')
        ..aOS(2, _omitFieldNames ? '' : 'iconUrl', protoName: 'iconUrl')
        ..hasRequiredFields = false;

  @$core.override
  ExtensionStoreResources clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreResources create() => ExtensionStoreResources._();

  @$core.override
  ExtensionStoreResources createEmptyInstance() => create();

  static $pb.PbList<ExtensionStoreResources> createRepeated() =>
      $pb.PbList<ExtensionStoreResources>();

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreResources getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        ExtensionStoreResources
      >(create);
  static ExtensionStoreResources? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get apkUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set apkUrl($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(2)
  $core.String get iconUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconUrl($core.String v) {
    $_setString(1, v);
  }
}

class ExtensionStoreSource extends $pb.GeneratedMessage {
  factory ExtensionStoreSource({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? language,
    $core.String? homeUrl,
    $core.Iterable<$core.String>? mirrorUrls,
    $core.String? message,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (language != null) result.language = language;
    if (homeUrl != null) result.homeUrl = homeUrl;
    if (mirrorUrls != null) result.mirrorUrls.addAll(mirrorUrls);
    if (message != null) result.message = message;
    return result;
  }

  ExtensionStoreSource._();

  factory ExtensionStoreSource.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory ExtensionStoreSource.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'ExtensionStoreSource',
        createEmptyInstance: create,
      )
        ..aInt64(1, _omitFieldNames ? '' : 'id')
        ..aOS(2, _omitFieldNames ? '' : 'name')
        ..aOS(3, _omitFieldNames ? '' : 'language')
        ..aOS(4, _omitFieldNames ? '' : 'homeUrl', protoName: 'homeUrl')
        ..pPS(5, _omitFieldNames ? '' : 'mirrorUrls', protoName: 'mirrorUrls')
        ..aOS(7, _omitFieldNames ? '' : 'message')
        ..hasRequiredFields = false;

  @$core.override
  ExtensionStoreSource clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreSource create() => ExtensionStoreSource._();

  @$core.override
  ExtensionStoreSource createEmptyInstance() => create();

  static $pb.PbList<ExtensionStoreSource> createRepeated() =>
      $pb.PbList<ExtensionStoreSource>();

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreSource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        ExtensionStoreSource
      >(create);
  static ExtensionStoreSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.String get language => $_getSZ(2);
  @$pb.TagNumber(3)
  set language($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  $core.String get homeUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set homeUrl($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(5)
  $core.List<$core.String> get mirrorUrls => $_getList(4);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(5);
  @$pb.TagNumber(7)
  set message($core.String v) {
    $_setString(5, v);
  }
}

class ExtensionStoreItem extends $pb.GeneratedMessage {
  factory ExtensionStoreItem({
    $core.String? name,
    $core.String? packageName,
    ExtensionStoreResources? resources,
    $core.String? extensionLib,
    $fixnum.Int64? versionCode,
    $core.String? versionName,
    $core.int? contentWarning,
    $core.Iterable<ExtensionStoreSource>? sources,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (packageName != null) result.packageName = packageName;
    if (resources != null) result.resources = resources;
    if (extensionLib != null) result.extensionLib = extensionLib;
    if (versionCode != null) result.versionCode = versionCode;
    if (versionName != null) result.versionName = versionName;
    if (contentWarning != null) result.contentWarning = contentWarning;
    if (sources != null) result.sources.addAll(sources);
    return result;
  }

  ExtensionStoreItem._();

  factory ExtensionStoreItem.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory ExtensionStoreItem.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'ExtensionStoreItem',
        createEmptyInstance: create,
      )
        ..aOS(1, _omitFieldNames ? '' : 'name')
        ..aOS(2, _omitFieldNames ? '' : 'packageName', protoName: 'packageName')
        ..aOM<ExtensionStoreResources>(
          3,
          _omitFieldNames ? '' : 'resources',
          subBuilder: ExtensionStoreResources.create,
        )
        ..aOS(4, _omitFieldNames ? '' : 'extensionLib', protoName: 'extensionLib')
        ..aInt64(5, _omitFieldNames ? '' : 'versionCode', protoName: 'versionCode')
        ..aOS(6, _omitFieldNames ? '' : 'versionName', protoName: 'versionName')
        ..a<$core.int>(
          7,
          _omitFieldNames ? '' : 'contentWarning',
          $pb.PbFieldType.O3,
          protoName: 'contentWarning',
        )
        ..pc<ExtensionStoreSource>(
          8,
          _omitFieldNames ? '' : 'sources',
          $pb.PbFieldType.PM,
          subBuilder: ExtensionStoreSource.create,
        )
        ..hasRequiredFields = false;

  @$core.override
  ExtensionStoreItem clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreItem create() => ExtensionStoreItem._();

  @$core.override
  ExtensionStoreItem createEmptyInstance() => create();

  static $pb.PbList<ExtensionStoreItem> createRepeated() =>
      $pb.PbList<ExtensionStoreItem>();

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        ExtensionStoreItem
      >(create);
  static ExtensionStoreItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(2)
  $core.String get packageName => $_getSZ(1);
  @$pb.TagNumber(2)
  set packageName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  ExtensionStoreResources get resources => $_getN(2);
  @$pb.TagNumber(3)
  set resources(ExtensionStoreResources v) {
    setField(3, v);
  }

  @$pb.TagNumber(4)
  $core.String get extensionLib => $_getSZ(3);
  @$pb.TagNumber(4)
  set extensionLib($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(5)
  $fixnum.Int64 get versionCode => $_getI64(4);
  @$pb.TagNumber(5)
  set versionCode($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(6)
  $core.String get versionName => $_getSZ(5);
  @$pb.TagNumber(6)
  set versionName($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(7)
  $core.int get contentWarning => $_getIZ(6);
  @$pb.TagNumber(7)
  set contentWarning($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(8)
  $core.List<ExtensionStoreSource> get sources => $_getList(7);
}

class ExtensionStoreExtensionList extends $pb.GeneratedMessage {
  factory ExtensionStoreExtensionList({
    $core.Iterable<ExtensionStoreItem>? extensions,
  }) {
    final result = create();
    if (extensions != null) result.extensions.addAll(extensions);
    return result;
  }

  ExtensionStoreExtensionList._();

  factory ExtensionStoreExtensionList.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory ExtensionStoreExtensionList.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'ExtensionStoreExtensionList',
        createEmptyInstance: create,
      )
        ..pc<ExtensionStoreItem>(
          1,
          _omitFieldNames ? '' : 'extensions',
          $pb.PbFieldType.PM,
          subBuilder: ExtensionStoreItem.create,
        )
        ..hasRequiredFields = false;

  @$core.override
  ExtensionStoreExtensionList clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreExtensionList create() =>
      ExtensionStoreExtensionList._();

  @$core.override
  ExtensionStoreExtensionList createEmptyInstance() => create();

  static $pb.PbList<ExtensionStoreExtensionList> createRepeated() =>
      $pb.PbList<ExtensionStoreExtensionList>();

  @$core.pragma('dart2js:noInline')
  static ExtensionStoreExtensionList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        ExtensionStoreExtensionList
      >(create);
  static ExtensionStoreExtensionList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ExtensionStoreItem> get extensions => $_getList(0);
}

class NetworkExtensionStore extends $pb.GeneratedMessage {
  factory NetworkExtensionStore({
    $core.String? name,
    $core.String? badgeLabel,
    $core.String? signingKey,
    ExtensionStoreContact? contact,
    ExtensionStoreExtensionList? extensionList,
    $core.String? extensionListUrl,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (badgeLabel != null) result.badgeLabel = badgeLabel;
    if (signingKey != null) result.signingKey = signingKey;
    if (contact != null) result.contact = contact;
    if (extensionList != null) result.extensionList = extensionList;
    if (extensionListUrl != null) result.extensionListUrl = extensionListUrl;
    return result;
  }

  NetworkExtensionStore._();

  factory NetworkExtensionStore.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory NetworkExtensionStore.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(json, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
        _omitMessageNames ? '' : 'NetworkExtensionStore',
        createEmptyInstance: create,
      )
        ..aOS(1, _omitFieldNames ? '' : 'name')
        ..aOS(2, _omitFieldNames ? '' : 'badgeLabel', protoName: 'badgeLabel')
        ..aOS(3, _omitFieldNames ? '' : 'signingKey', protoName: 'signingKey')
        ..aOM<ExtensionStoreContact>(
          4,
          _omitFieldNames ? '' : 'contact',
          subBuilder: ExtensionStoreContact.create,
        )
        ..aOM<ExtensionStoreExtensionList>(
          101,
          _omitFieldNames ? '' : 'extensionList',
          protoName: 'extensionList',
          subBuilder: ExtensionStoreExtensionList.create,
        )
        ..aOS(
          102,
          _omitFieldNames ? '' : 'extensionListUrl',
          protoName: 'extensionListUrl',
        )
        ..hasRequiredFields = false;

  @$core.override
  NetworkExtensionStore clone() => create()..mergeFromMessage(this);

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NetworkExtensionStore create() => NetworkExtensionStore._();

  @$core.override
  NetworkExtensionStore createEmptyInstance() => create();

  static $pb.PbList<NetworkExtensionStore> createRepeated() =>
      $pb.PbList<NetworkExtensionStore>();

  @$core.pragma('dart2js:noInline')
  static NetworkExtensionStore getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
        NetworkExtensionStore
      >(create);
  static NetworkExtensionStore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(2)
  $core.String get badgeLabel => $_getSZ(1);
  @$pb.TagNumber(2)
  set badgeLabel($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.String get signingKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set signingKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  ExtensionStoreContact get contact => $_getN(3);
  @$pb.TagNumber(4)
  set contact(ExtensionStoreContact v) {
    setField(4, v);
  }

  @$pb.TagNumber(101)
  ExtensionStoreExtensionList get extensionList => $_getN(4);
  @$pb.TagNumber(101)
  set extensionList(ExtensionStoreExtensionList v) {
    setField(101, v);
  }

  @$pb.TagNumber(102)
  $core.String get extensionListUrl => $_getSZ(5);
  @$pb.TagNumber(102)
  set extensionListUrl($core.String v) {
    $_setString(5, v);
  }
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
