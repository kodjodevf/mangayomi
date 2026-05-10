// This is a generated file - do not edit.
//
// Generated from BackupAniyomi.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupAnime.pb.dart' as $2;
import 'BackupCategory.pb.dart' as $1;
import 'BackupManga.pb.dart' as $0;
import 'BackupSource.pb.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupAniyomi extends $pb.GeneratedMessage {
  factory BackupAniyomi({
    $core.Iterable<$0.BackupManga>? backupManga,
    $core.Iterable<$1.BackupCategory>? backupCategories,
    $core.Iterable<$2.BackupAnime>? legacyBackupAnime,
    $core.Iterable<$1.BackupCategory>? legacyBackupAnimeCategories,
    $core.Iterable<$3.BackupSource>? backupSources,
    $core.Iterable<$3.BackupSource>? legacyBackupAnimeSources,
    $core.bool? isLegacy,
    $core.Iterable<$2.BackupAnime>? backupAnime,
    $core.Iterable<$1.BackupCategory>? backupAnimeCategories,
    $core.Iterable<$3.BackupSource>? backupAnimeSources,
  }) {
    final result = create();
    if (backupManga != null) result.backupManga.addAll(backupManga);
    if (backupCategories != null)
      result.backupCategories.addAll(backupCategories);
    if (legacyBackupAnime != null)
      result.legacyBackupAnime.addAll(legacyBackupAnime);
    if (legacyBackupAnimeCategories != null)
      result.legacyBackupAnimeCategories.addAll(legacyBackupAnimeCategories);
    if (backupSources != null) result.backupSources.addAll(backupSources);
    if (legacyBackupAnimeSources != null)
      result.legacyBackupAnimeSources.addAll(legacyBackupAnimeSources);
    if (isLegacy != null) result.isLegacy = isLegacy;
    if (backupAnime != null) result.backupAnime.addAll(backupAnime);
    if (backupAnimeCategories != null)
      result.backupAnimeCategories.addAll(backupAnimeCategories);
    if (backupAnimeSources != null)
      result.backupAnimeSources.addAll(backupAnimeSources);
    return result;
  }

  BackupAniyomi._();

  factory BackupAniyomi.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupAniyomi.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupAniyomi',
      createEmptyInstance: create)
    ..pPM<$0.BackupManga>(1, _omitFieldNames ? '' : 'backupManga',
        protoName: 'backupManga', subBuilder: $0.BackupManga.create)
    ..pPM<$1.BackupCategory>(2, _omitFieldNames ? '' : 'backupCategories',
        protoName: 'backupCategories', subBuilder: $1.BackupCategory.create)
    ..pPM<$2.BackupAnime>(3, _omitFieldNames ? '' : 'legacyBackupAnime',
        protoName: 'legacyBackupAnime', subBuilder: $2.BackupAnime.create)
    ..pPM<$1.BackupCategory>(
        4, _omitFieldNames ? '' : 'legacyBackupAnimeCategories',
        protoName: 'legacyBackupAnimeCategories',
        subBuilder: $1.BackupCategory.create)
    ..pPM<$3.BackupSource>(101, _omitFieldNames ? '' : 'backupSources',
        protoName: 'backupSources', subBuilder: $3.BackupSource.create)
    ..pPM<$3.BackupSource>(
        103, _omitFieldNames ? '' : 'legacyBackupAnimeSources',
        protoName: 'legacyBackupAnimeSources',
        subBuilder: $3.BackupSource.create)
    ..aOB(500, _omitFieldNames ? '' : 'isLegacy', protoName: 'isLegacy')
    ..pPM<$2.BackupAnime>(501, _omitFieldNames ? '' : 'backupAnime',
        protoName: 'backupAnime', subBuilder: $2.BackupAnime.create)
    ..pPM<$1.BackupCategory>(
        502, _omitFieldNames ? '' : 'backupAnimeCategories',
        protoName: 'backupAnimeCategories',
        subBuilder: $1.BackupCategory.create)
    ..pPM<$3.BackupSource>(503, _omitFieldNames ? '' : 'backupAnimeSources',
        protoName: 'backupAnimeSources', subBuilder: $3.BackupSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupAniyomi clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupAniyomi copyWith(void Function(BackupAniyomi) updates) =>
      super.copyWith((message) => updates(message as BackupAniyomi))
          as BackupAniyomi;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupAniyomi create() => BackupAniyomi._();
  @$core.override
  BackupAniyomi createEmptyInstance() => create();
  static $pb.PbList<BackupAniyomi> createRepeated() =>
      $pb.PbList<BackupAniyomi>();
  @$core.pragma('dart2js:noInline')
  static BackupAniyomi getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupAniyomi>(create);
  static BackupAniyomi? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.BackupManga> get backupManga => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$1.BackupCategory> get backupCategories => $_getList(1);

  /// Legacy Aniyomi backups stored anime fields alongside the Mihon fields.
  @$pb.TagNumber(3)
  $pb.PbList<$2.BackupAnime> get legacyBackupAnime => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$1.BackupCategory> get legacyBackupAnimeCategories => $_getList(3);

  @$pb.TagNumber(101)
  $pb.PbList<$3.BackupSource> get backupSources => $_getList(4);

  @$pb.TagNumber(103)
  $pb.PbList<$3.BackupSource> get legacyBackupAnimeSources => $_getList(5);

  /// New Aniyomi backups moved Aniyomi-only fields to a separate range.
  @$pb.TagNumber(500)
  $core.bool get isLegacy => $_getBF(6);
  @$pb.TagNumber(500)
  set isLegacy($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(500)
  $core.bool hasIsLegacy() => $_has(6);
  @$pb.TagNumber(500)
  void clearIsLegacy() => $_clearField(500);

  @$pb.TagNumber(501)
  $pb.PbList<$2.BackupAnime> get backupAnime => $_getList(7);

  @$pb.TagNumber(502)
  $pb.PbList<$1.BackupCategory> get backupAnimeCategories => $_getList(8);

  @$pb.TagNumber(503)
  $pb.PbList<$3.BackupSource> get backupAnimeSources => $_getList(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
