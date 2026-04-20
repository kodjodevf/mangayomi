// This is a generated file - do not edit.
//
// Generated from BackupHistory.proto.

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

class BackupHistory extends $pb.GeneratedMessage {
  factory BackupHistory({
    $core.String? url,
    $fixnum.Int64? lastRead,
    $fixnum.Int64? readDuration,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (lastRead != null) result.lastRead = lastRead;
    if (readDuration != null) result.readDuration = readDuration;
    return result;
  }

  BackupHistory._();

  factory BackupHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupHistory',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aInt64(2, _omitFieldNames ? '' : 'lastRead', protoName: 'lastRead')
    ..aInt64(3, _omitFieldNames ? '' : 'readDuration',
        protoName: 'readDuration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupHistory copyWith(void Function(BackupHistory) updates) =>
      super.copyWith((message) => updates(message as BackupHistory))
          as BackupHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupHistory create() => BackupHistory._();
  @$core.override
  BackupHistory createEmptyInstance() => create();
  static $pb.PbList<BackupHistory> createRepeated() =>
      $pb.PbList<BackupHistory>();
  @$core.pragma('dart2js:noInline')
  static BackupHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupHistory>(create);
  static BackupHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastRead => $_getI64(1);
  @$pb.TagNumber(2)
  set lastRead($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastRead() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastRead() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get readDuration => $_getI64(2);
  @$pb.TagNumber(3)
  set readDuration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReadDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadDuration() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
