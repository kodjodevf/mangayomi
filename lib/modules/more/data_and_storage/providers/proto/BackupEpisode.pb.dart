// This is a generated file - do not edit.
//
// Generated from BackupEpisode.proto.

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

class BackupEpisode extends $pb.GeneratedMessage {
  factory BackupEpisode({
    $core.String? url,
    $core.String? name,
    $core.String? scanlator,
    $core.bool? seen,
    $core.bool? bookmark,
    $fixnum.Int64? lastSecondSeen,
    $fixnum.Int64? dateFetch,
    $fixnum.Int64? dateUpload,
    $core.double? episodeNumber,
    $fixnum.Int64? sourceOrder,
    $fixnum.Int64? lastModifiedAt,
    $fixnum.Int64? version,
    $fixnum.Int64? totalSeconds,
    $core.bool? fillermark,
    $core.String? summary,
    $core.String? previewUrl,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (name != null) result.name = name;
    if (scanlator != null) result.scanlator = scanlator;
    if (seen != null) result.seen = seen;
    if (bookmark != null) result.bookmark = bookmark;
    if (lastSecondSeen != null) result.lastSecondSeen = lastSecondSeen;
    if (dateFetch != null) result.dateFetch = dateFetch;
    if (dateUpload != null) result.dateUpload = dateUpload;
    if (episodeNumber != null) result.episodeNumber = episodeNumber;
    if (sourceOrder != null) result.sourceOrder = sourceOrder;
    if (lastModifiedAt != null) result.lastModifiedAt = lastModifiedAt;
    if (version != null) result.version = version;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (fillermark != null) result.fillermark = fillermark;
    if (summary != null) result.summary = summary;
    if (previewUrl != null) result.previewUrl = previewUrl;
    return result;
  }

  BackupEpisode._();

  factory BackupEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupEpisode',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'scanlator')
    ..aOB(4, _omitFieldNames ? '' : 'seen')
    ..aOB(5, _omitFieldNames ? '' : 'bookmark')
    ..aInt64(6, _omitFieldNames ? '' : 'lastSecondSeen',
        protoName: 'lastSecondSeen')
    ..aInt64(7, _omitFieldNames ? '' : 'dateFetch', protoName: 'dateFetch')
    ..aInt64(8, _omitFieldNames ? '' : 'dateUpload', protoName: 'dateUpload')
    ..aD(9, _omitFieldNames ? '' : 'episodeNumber',
        protoName: 'episodeNumber', fieldType: $pb.PbFieldType.OF)
    ..aInt64(10, _omitFieldNames ? '' : 'sourceOrder', protoName: 'sourceOrder')
    ..aInt64(11, _omitFieldNames ? '' : 'lastModifiedAt',
        protoName: 'lastModifiedAt')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..aInt64(16, _omitFieldNames ? '' : 'totalSeconds',
        protoName: 'totalSeconds')
    ..aOB(501, _omitFieldNames ? '' : 'fillermark')
    ..aOS(502, _omitFieldNames ? '' : 'summary')
    ..aOS(503, _omitFieldNames ? '' : 'previewUrl', protoName: 'previewUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupEpisode copyWith(void Function(BackupEpisode) updates) =>
      super.copyWith((message) => updates(message as BackupEpisode))
          as BackupEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupEpisode create() => BackupEpisode._();
  @$core.override
  BackupEpisode createEmptyInstance() => create();
  static $pb.PbList<BackupEpisode> createRepeated() =>
      $pb.PbList<BackupEpisode>();
  @$core.pragma('dart2js:noInline')
  static BackupEpisode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupEpisode>(create);
  static BackupEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scanlator => $_getSZ(2);
  @$pb.TagNumber(3)
  set scanlator($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScanlator() => $_has(2);
  @$pb.TagNumber(3)
  void clearScanlator() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get seen => $_getBF(3);
  @$pb.TagNumber(4)
  set seen($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSeen() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeen() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get bookmark => $_getBF(4);
  @$pb.TagNumber(5)
  set bookmark($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBookmark() => $_has(4);
  @$pb.TagNumber(5)
  void clearBookmark() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastSecondSeen => $_getI64(5);
  @$pb.TagNumber(6)
  set lastSecondSeen($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastSecondSeen() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSecondSeen() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get dateFetch => $_getI64(6);
  @$pb.TagNumber(7)
  set dateFetch($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDateFetch() => $_has(6);
  @$pb.TagNumber(7)
  void clearDateFetch() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get dateUpload => $_getI64(7);
  @$pb.TagNumber(8)
  set dateUpload($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDateUpload() => $_has(7);
  @$pb.TagNumber(8)
  void clearDateUpload() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get episodeNumber => $_getN(8);
  @$pb.TagNumber(9)
  set episodeNumber($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEpisodeNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearEpisodeNumber() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get sourceOrder => $_getI64(9);
  @$pb.TagNumber(10)
  set sourceOrder($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSourceOrder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceOrder() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get lastModifiedAt => $_getI64(10);
  @$pb.TagNumber(11)
  set lastModifiedAt($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLastModifiedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastModifiedAt() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);

  @$pb.TagNumber(16)
  $fixnum.Int64 get totalSeconds => $_getI64(12);
  @$pb.TagNumber(16)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(16)
  $core.bool hasTotalSeconds() => $_has(12);
  @$pb.TagNumber(16)
  void clearTotalSeconds() => $_clearField(16);

  @$pb.TagNumber(501)
  $core.bool get fillermark => $_getBF(13);
  @$pb.TagNumber(501)
  set fillermark($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(501)
  $core.bool hasFillermark() => $_has(13);
  @$pb.TagNumber(501)
  void clearFillermark() => $_clearField(501);

  @$pb.TagNumber(502)
  $core.String get summary => $_getSZ(14);
  @$pb.TagNumber(502)
  set summary($core.String value) => $_setString(14, value);
  @$pb.TagNumber(502)
  $core.bool hasSummary() => $_has(14);
  @$pb.TagNumber(502)
  void clearSummary() => $_clearField(502);

  @$pb.TagNumber(503)
  $core.String get previewUrl => $_getSZ(15);
  @$pb.TagNumber(503)
  set previewUrl($core.String value) => $_setString(15, value);
  @$pb.TagNumber(503)
  $core.bool hasPreviewUrl() => $_has(15);
  @$pb.TagNumber(503)
  void clearPreviewUrl() => $_clearField(503);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
