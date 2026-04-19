// This is a generated file - do not edit.
//
// Generated from BackupMihon.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupCategory.pb.dart' as $1;
import 'BackupManga.pb.dart' as $0;
import 'BackupSource.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupMihon extends $pb.GeneratedMessage {
  factory BackupMihon({
    $core.Iterable<$0.BackupManga>? backupManga,
    $core.Iterable<$1.BackupCategory>? backupCategories,
    $core.Iterable<$2.BackupSource>? backupSources,
  }) {
    final result = create();
    if (backupManga != null) result.backupManga.addAll(backupManga);
    if (backupCategories != null)
      result.backupCategories.addAll(backupCategories);
    if (backupSources != null) result.backupSources.addAll(backupSources);
    return result;
  }

  BackupMihon._();

  factory BackupMihon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupMihon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupMihon',
      createEmptyInstance: create)
    ..pPM<$0.BackupManga>(1, _omitFieldNames ? '' : 'backupManga',
        protoName: 'backupManga', subBuilder: $0.BackupManga.create)
    ..pPM<$1.BackupCategory>(2, _omitFieldNames ? '' : 'backupCategories',
        protoName: 'backupCategories', subBuilder: $1.BackupCategory.create)
    ..pPM<$2.BackupSource>(101, _omitFieldNames ? '' : 'backupSources',
        protoName: 'backupSources', subBuilder: $2.BackupSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupMihon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupMihon copyWith(void Function(BackupMihon) updates) =>
      super.copyWith((message) => updates(message as BackupMihon))
          as BackupMihon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupMihon create() => BackupMihon._();
  @$core.override
  BackupMihon createEmptyInstance() => create();
  static $pb.PbList<BackupMihon> createRepeated() => $pb.PbList<BackupMihon>();
  @$core.pragma('dart2js:noInline')
  static BackupMihon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupMihon>(create);
  static BackupMihon? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.BackupManga> get backupManga => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$1.BackupCategory> get backupCategories => $_getList(1);

  @$pb.TagNumber(101)
  $pb.PbList<$2.BackupSource> get backupSources => $_getList(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
