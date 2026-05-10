// This is a generated file - do not edit.
//
// Generated from BackupChapter.proto.

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

class BackupChapter extends $pb.GeneratedMessage {
  factory BackupChapter({
    $core.String? url,
    $core.String? name,
    $core.String? scanlator,
    $core.bool? read,
    $core.bool? bookmark,
    $fixnum.Int64? lastPageRead,
    $fixnum.Int64? dateFetch,
    $fixnum.Int64? dateUpload,
    $core.double? chapterNumber,
    $fixnum.Int64? sourceOrder,
    $fixnum.Int64? lastModifiedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (name != null) result.name = name;
    if (scanlator != null) result.scanlator = scanlator;
    if (read != null) result.read = read;
    if (bookmark != null) result.bookmark = bookmark;
    if (lastPageRead != null) result.lastPageRead = lastPageRead;
    if (dateFetch != null) result.dateFetch = dateFetch;
    if (dateUpload != null) result.dateUpload = dateUpload;
    if (chapterNumber != null) result.chapterNumber = chapterNumber;
    if (sourceOrder != null) result.sourceOrder = sourceOrder;
    if (lastModifiedAt != null) result.lastModifiedAt = lastModifiedAt;
    if (version != null) result.version = version;
    return result;
  }

  BackupChapter._();

  factory BackupChapter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupChapter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupChapter',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'scanlator')
    ..aOB(4, _omitFieldNames ? '' : 'read')
    ..aOB(5, _omitFieldNames ? '' : 'bookmark')
    ..aInt64(6, _omitFieldNames ? '' : 'lastPageRead',
        protoName: 'lastPageRead')
    ..aInt64(7, _omitFieldNames ? '' : 'dateFetch', protoName: 'dateFetch')
    ..aInt64(8, _omitFieldNames ? '' : 'dateUpload', protoName: 'dateUpload')
    ..aD(9, _omitFieldNames ? '' : 'chapterNumber',
        protoName: 'chapterNumber', fieldType: $pb.PbFieldType.OF)
    ..aInt64(10, _omitFieldNames ? '' : 'sourceOrder', protoName: 'sourceOrder')
    ..aInt64(11, _omitFieldNames ? '' : 'lastModifiedAt',
        protoName: 'lastModifiedAt')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupChapter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupChapter copyWith(void Function(BackupChapter) updates) =>
      super.copyWith((message) => updates(message as BackupChapter))
          as BackupChapter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupChapter create() => BackupChapter._();
  @$core.override
  BackupChapter createEmptyInstance() => create();
  static $pb.PbList<BackupChapter> createRepeated() =>
      $pb.PbList<BackupChapter>();
  @$core.pragma('dart2js:noInline')
  static BackupChapter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupChapter>(create);
  static BackupChapter? _defaultInstance;

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
  $core.bool get read => $_getBF(3);
  @$pb.TagNumber(4)
  set read($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRead() => $_has(3);
  @$pb.TagNumber(4)
  void clearRead() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get bookmark => $_getBF(4);
  @$pb.TagNumber(5)
  set bookmark($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBookmark() => $_has(4);
  @$pb.TagNumber(5)
  void clearBookmark() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastPageRead => $_getI64(5);
  @$pb.TagNumber(6)
  set lastPageRead($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastPageRead() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastPageRead() => $_clearField(6);

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
  $core.double get chapterNumber => $_getN(8);
  @$pb.TagNumber(9)
  set chapterNumber($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasChapterNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearChapterNumber() => $_clearField(9);

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
