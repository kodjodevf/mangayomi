//
//  Generated code. Do not modify.
//  source: BackupEpisode.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class BackupEpisode extends $pb.GeneratedMessage {
  factory BackupEpisode({
    $core.String? url,
    $core.String? name,
    $core.String? scanlator,
    $core.bool? seen,
    $core.bool? bookmark,
    $core.int? lastSecondSeen,
    $core.int? dateFetch,
    $core.int? dateUpload,
    $core.double? episodeNumber,
    $core.int? sourceOrder,
    $core.int? lastModifiedAt,
    $core.int? version,
    $core.int? totalSeconds,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (name != null) {
      $result.name = name;
    }
    if (scanlator != null) {
      $result.scanlator = scanlator;
    }
    if (seen != null) {
      $result.seen = seen;
    }
    if (bookmark != null) {
      $result.bookmark = bookmark;
    }
    if (lastSecondSeen != null) {
      $result.lastSecondSeen = lastSecondSeen;
    }
    if (dateFetch != null) {
      $result.dateFetch = dateFetch;
    }
    if (dateUpload != null) {
      $result.dateUpload = dateUpload;
    }
    if (episodeNumber != null) {
      $result.episodeNumber = episodeNumber;
    }
    if (sourceOrder != null) {
      $result.sourceOrder = sourceOrder;
    }
    if (lastModifiedAt != null) {
      $result.lastModifiedAt = lastModifiedAt;
    }
    if (version != null) {
      $result.version = version;
    }
    if (totalSeconds != null) {
      $result.totalSeconds = totalSeconds;
    }
    return $result;
  }
  BackupEpisode._() : super();
  factory BackupEpisode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BackupEpisode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupEpisode', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'scanlator')
    ..aOB(4, _omitFieldNames ? '' : 'seen')
    ..aOB(5, _omitFieldNames ? '' : 'bookmark')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'lastSecondSeen', $pb.PbFieldType.O3, protoName: 'lastSecondSeen')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'dateFetch', $pb.PbFieldType.O3, protoName: 'dateFetch')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'dateUpload', $pb.PbFieldType.O3, protoName: 'dateUpload')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'episodeNumber', $pb.PbFieldType.OF, protoName: 'episodeNumber')
    ..a<$core.int>(10, _omitFieldNames ? '' : 'sourceOrder', $pb.PbFieldType.O3, protoName: 'sourceOrder')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'lastModifiedAt', $pb.PbFieldType.O3, protoName: 'lastModifiedAt')
    ..a<$core.int>(12, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(16, _omitFieldNames ? '' : 'totalSeconds', $pb.PbFieldType.O3, protoName: 'totalSeconds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BackupEpisode clone() => BackupEpisode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BackupEpisode copyWith(void Function(BackupEpisode) updates) => super.copyWith((message) => updates(message as BackupEpisode)) as BackupEpisode;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupEpisode create() => BackupEpisode._();
  BackupEpisode createEmptyInstance() => create();
  static $pb.PbList<BackupEpisode> createRepeated() => $pb.PbList<BackupEpisode>();
  @$core.pragma('dart2js:noInline')
  static BackupEpisode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupEpisode>(create);
  static BackupEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get scanlator => $_getSZ(2);
  @$pb.TagNumber(3)
  set scanlator($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasScanlator() => $_has(2);
  @$pb.TagNumber(3)
  void clearScanlator() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get seen => $_getBF(3);
  @$pb.TagNumber(4)
  set seen($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSeen() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeen() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get bookmark => $_getBF(4);
  @$pb.TagNumber(5)
  set bookmark($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBookmark() => $_has(4);
  @$pb.TagNumber(5)
  void clearBookmark() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lastSecondSeen => $_getIZ(5);
  @$pb.TagNumber(6)
  set lastSecondSeen($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLastSecondSeen() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSecondSeen() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get dateFetch => $_getIZ(6);
  @$pb.TagNumber(7)
  set dateFetch($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDateFetch() => $_has(6);
  @$pb.TagNumber(7)
  void clearDateFetch() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get dateUpload => $_getIZ(7);
  @$pb.TagNumber(8)
  set dateUpload($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDateUpload() => $_has(7);
  @$pb.TagNumber(8)
  void clearDateUpload() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get episodeNumber => $_getN(8);
  @$pb.TagNumber(9)
  set episodeNumber($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEpisodeNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearEpisodeNumber() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get sourceOrder => $_getIZ(9);
  @$pb.TagNumber(10)
  set sourceOrder($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceOrder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceOrder() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get lastModifiedAt => $_getIZ(10);
  @$pb.TagNumber(11)
  set lastModifiedAt($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasLastModifiedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastModifiedAt() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get version => $_getIZ(11);
  @$pb.TagNumber(12)
  set version($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => clearField(12);

  @$pb.TagNumber(16)
  $core.int get totalSeconds => $_getIZ(12);
  @$pb.TagNumber(16)
  set totalSeconds($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(16)
  $core.bool hasTotalSeconds() => $_has(12);
  @$pb.TagNumber(16)
  void clearTotalSeconds() => clearField(16);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
