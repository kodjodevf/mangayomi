//
//  Generated code. Do not modify.
//  source: BackupMihon.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupCategory.pb.dart' as $1;
import 'BackupManga.pb.dart' as $0;
import 'BackupSource.pb.dart' as $2;

class BackupMihon extends $pb.GeneratedMessage {
  factory BackupMihon({
    $core.Iterable<$0.BackupManga>? backupManga,
    $core.Iterable<$1.BackupCategory>? backupCategories,
    $core.Iterable<$2.BackupSource>? backupSources,
  }) {
    final $result = create();
    if (backupManga != null) {
      $result.backupManga.addAll(backupManga);
    }
    if (backupCategories != null) {
      $result.backupCategories.addAll(backupCategories);
    }
    if (backupSources != null) {
      $result.backupSources.addAll(backupSources);
    }
    return $result;
  }
  BackupMihon._() : super();
  factory BackupMihon.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BackupMihon.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupMihon', createEmptyInstance: create)
    ..pc<$0.BackupManga>(1, _omitFieldNames ? '' : 'backupManga', $pb.PbFieldType.PM, protoName: 'backupManga', subBuilder: $0.BackupManga.create)
    ..pc<$1.BackupCategory>(2, _omitFieldNames ? '' : 'backupCategories', $pb.PbFieldType.PM, protoName: 'backupCategories', subBuilder: $1.BackupCategory.create)
    ..pc<$2.BackupSource>(101, _omitFieldNames ? '' : 'backupSources', $pb.PbFieldType.PM, protoName: 'backupSources', subBuilder: $2.BackupSource.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BackupMihon clone() => BackupMihon()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BackupMihon copyWith(void Function(BackupMihon) updates) => super.copyWith((message) => updates(message as BackupMihon)) as BackupMihon;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupMihon create() => BackupMihon._();
  BackupMihon createEmptyInstance() => create();
  static $pb.PbList<BackupMihon> createRepeated() => $pb.PbList<BackupMihon>();
  @$core.pragma('dart2js:noInline')
  static BackupMihon getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupMihon>(create);
  static BackupMihon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.BackupManga> get backupManga => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$1.BackupCategory> get backupCategories => $_getList(1);

  @$pb.TagNumber(101)
  $core.List<$2.BackupSource> get backupSources => $_getList(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
