// This is a generated file - do not edit.
//
// Generated from BackupCategory.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupCategory extends $pb.GeneratedMessage {
  factory BackupCategory({
    $core.String? name,
    $fixnum.Int64? order,
    $fixnum.Int64? id,
    $fixnum.Int64? flags,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (order != null) result.order = order;
    if (id != null) result.id = id;
    if (flags != null) result.flags = flags;
    return result;
  }

  BackupCategory._();

  factory BackupCategory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupCategory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupCategory',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'order')
    ..aInt64(3, _omitFieldNames ? '' : 'id')
    ..aInt64(100, _omitFieldNames ? '' : 'flags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupCategory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupCategory copyWith(void Function(BackupCategory) updates) =>
      super.copyWith((message) => updates(message as BackupCategory))
          as BackupCategory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupCategory create() => BackupCategory._();
  @$core.override
  BackupCategory createEmptyInstance() => create();
  static $pb.PbList<BackupCategory> createRepeated() =>
      $pb.PbList<BackupCategory>();
  @$core.pragma('dart2js:noInline')
  static BackupCategory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupCategory>(create);
  static BackupCategory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get order => $_getI64(1);
  @$pb.TagNumber(2)
  set order($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get id => $_getI64(2);
  @$pb.TagNumber(3)
  set id($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);

  @$pb.TagNumber(100)
  $fixnum.Int64 get flags => $_getI64(3);
  @$pb.TagNumber(100)
  set flags($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(100)
  $core.bool hasFlags() => $_has(3);
  @$pb.TagNumber(100)
  void clearFlags() => $_clearField(100);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
