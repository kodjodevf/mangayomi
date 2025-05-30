//
//  Generated code. Do not modify.
//  source: BackupAniyomi.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupAnime.pb.dart' as $2;
import 'BackupCategory.pb.dart' as $1;
import 'BackupManga.pb.dart' as $0;
import 'BackupSource.pb.dart' as $3;

class BackupAniyomi extends $pb.GeneratedMessage {
  factory BackupAniyomi({
    $core.Iterable<$0.BackupManga>? backupManga,
    $core.Iterable<$1.BackupCategory>? backupCategories,
    $core.Iterable<$2.BackupAnime>? backupAnime,
    $core.Iterable<$1.BackupCategory>? backupAnimeCategories,
    $core.Iterable<$3.BackupSource>? backupSources,
    $core.Iterable<$3.BackupSource>? backupAnimeSources,
  }) {
    final $result = create();
    if (backupManga != null) {
      $result.backupManga.addAll(backupManga);
    }
    if (backupCategories != null) {
      $result.backupCategories.addAll(backupCategories);
    }
    if (backupAnime != null) {
      $result.backupAnime.addAll(backupAnime);
    }
    if (backupAnimeCategories != null) {
      $result.backupAnimeCategories.addAll(backupAnimeCategories);
    }
    if (backupSources != null) {
      $result.backupSources.addAll(backupSources);
    }
    if (backupAnimeSources != null) {
      $result.backupAnimeSources.addAll(backupAnimeSources);
    }
    return $result;
  }
  BackupAniyomi._() : super();
  factory BackupAniyomi.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupAniyomi.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupAniyomi',
      createEmptyInstance: create)
    ..pc<$0.BackupManga>(
        1, _omitFieldNames ? '' : 'backupManga', $pb.PbFieldType.PM,
        protoName: 'backupManga', subBuilder: $0.BackupManga.create)
    ..pc<$1.BackupCategory>(
        2, _omitFieldNames ? '' : 'backupCategories', $pb.PbFieldType.PM,
        protoName: 'backupCategories', subBuilder: $1.BackupCategory.create)
    ..pc<$2.BackupAnime>(
        3, _omitFieldNames ? '' : 'backupAnime', $pb.PbFieldType.PM,
        protoName: 'backupAnime', subBuilder: $2.BackupAnime.create)
    ..pc<$1.BackupCategory>(
        4, _omitFieldNames ? '' : 'backupAnimeCategories', $pb.PbFieldType.PM,
        protoName: 'backupAnimeCategories',
        subBuilder: $1.BackupCategory.create)
    ..pc<$3.BackupSource>(
        101, _omitFieldNames ? '' : 'backupSources', $pb.PbFieldType.PM,
        protoName: 'backupSources', subBuilder: $3.BackupSource.create)
    ..pc<$3.BackupSource>(
        103, _omitFieldNames ? '' : 'backupAnimeSources', $pb.PbFieldType.PM,
        protoName: 'backupAnimeSources', subBuilder: $3.BackupSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupAniyomi clone() => BackupAniyomi()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupAniyomi copyWith(void Function(BackupAniyomi) updates) =>
      super.copyWith((message) => updates(message as BackupAniyomi))
          as BackupAniyomi;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupAniyomi create() => BackupAniyomi._();
  BackupAniyomi createEmptyInstance() => create();
  static $pb.PbList<BackupAniyomi> createRepeated() =>
      $pb.PbList<BackupAniyomi>();
  @$core.pragma('dart2js:noInline')
  static BackupAniyomi getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupAniyomi>(create);
  static BackupAniyomi? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.BackupManga> get backupManga => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$1.BackupCategory> get backupCategories => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$2.BackupAnime> get backupAnime => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$1.BackupCategory> get backupAnimeCategories => $_getList(3);

  @$pb.TagNumber(101)
  $core.List<$3.BackupSource> get backupSources => $_getList(4);

  @$pb.TagNumber(103)
  $core.List<$3.BackupSource> get backupAnimeSources => $_getList(5);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
