// This is a generated file - do not edit.
//
// Generated from BackupManga.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupChapter.pb.dart' as $0;
import 'BackupHistory.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupManga extends $pb.GeneratedMessage {
  factory BackupManga({
    $fixnum.Int64? source,
    $core.String? url,
    $core.String? title,
    $core.String? artist,
    $core.String? author,
    $core.String? description,
    $core.Iterable<$core.String>? genre,
    $core.int? status,
    $core.String? thumbnailUrl,
    $fixnum.Int64? dateAdded,
    $core.int? viewer,
    $core.Iterable<$0.BackupChapter>? chapters,
    $core.Iterable<$fixnum.Int64>? categories,
    $core.bool? favorite,
    $core.int? chapterFlags,
    $core.int? viewerFlags,
    $core.Iterable<$1.BackupHistory>? history,
    $core.int? updateStrategy,
    $fixnum.Int64? lastModifiedAt,
    $fixnum.Int64? favoriteModifiedAt,
    $core.Iterable<$core.String>? excludedScanlators,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (url != null) result.url = url;
    if (title != null) result.title = title;
    if (artist != null) result.artist = artist;
    if (author != null) result.author = author;
    if (description != null) result.description = description;
    if (genre != null) result.genre.addAll(genre);
    if (status != null) result.status = status;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (dateAdded != null) result.dateAdded = dateAdded;
    if (viewer != null) result.viewer = viewer;
    if (chapters != null) result.chapters.addAll(chapters);
    if (categories != null) result.categories.addAll(categories);
    if (favorite != null) result.favorite = favorite;
    if (chapterFlags != null) result.chapterFlags = chapterFlags;
    if (viewerFlags != null) result.viewerFlags = viewerFlags;
    if (history != null) result.history.addAll(history);
    if (updateStrategy != null) result.updateStrategy = updateStrategy;
    if (lastModifiedAt != null) result.lastModifiedAt = lastModifiedAt;
    if (favoriteModifiedAt != null)
      result.favoriteModifiedAt = favoriteModifiedAt;
    if (excludedScanlators != null)
      result.excludedScanlators.addAll(excludedScanlators);
    if (version != null) result.version = version;
    return result;
  }

  BackupManga._();

  factory BackupManga.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupManga.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupManga',
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'source')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'artist')
    ..aOS(5, _omitFieldNames ? '' : 'author')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..pPS(7, _omitFieldNames ? '' : 'genre')
    ..aI(8, _omitFieldNames ? '' : 'status')
    ..aOS(9, _omitFieldNames ? '' : 'thumbnailUrl', protoName: 'thumbnailUrl')
    ..aInt64(13, _omitFieldNames ? '' : 'dateAdded', protoName: 'dateAdded')
    ..aI(14, _omitFieldNames ? '' : 'viewer')
    ..pPM<$0.BackupChapter>(16, _omitFieldNames ? '' : 'chapters',
        subBuilder: $0.BackupChapter.create)
    ..p<$fixnum.Int64>(
        17, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.K6)
    ..aOB(100, _omitFieldNames ? '' : 'favorite')
    ..aI(101, _omitFieldNames ? '' : 'chapterFlags', protoName: 'chapterFlags')
    ..aI(103, _omitFieldNames ? '' : 'viewerFlags')
    ..pPM<$1.BackupHistory>(104, _omitFieldNames ? '' : 'history',
        subBuilder: $1.BackupHistory.create)
    ..aI(105, _omitFieldNames ? '' : 'updateStrategy',
        protoName: 'updateStrategy')
    ..aInt64(106, _omitFieldNames ? '' : 'lastModifiedAt',
        protoName: 'lastModifiedAt')
    ..aInt64(107, _omitFieldNames ? '' : 'favoriteModifiedAt',
        protoName: 'favoriteModifiedAt')
    ..pPS(108, _omitFieldNames ? '' : 'excludedScanlators',
        protoName: 'excludedScanlators')
    ..aInt64(109, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupManga clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupManga copyWith(void Function(BackupManga) updates) =>
      super.copyWith((message) => updates(message as BackupManga))
          as BackupManga;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupManga create() => BackupManga._();
  @$core.override
  BackupManga createEmptyInstance() => create();
  static $pb.PbList<BackupManga> createRepeated() => $pb.PbList<BackupManga>();
  @$core.pragma('dart2js:noInline')
  static BackupManga getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupManga>(create);
  static BackupManga? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get source => $_getI64(0);
  @$pb.TagNumber(1)
  set source($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get artist => $_getSZ(3);
  @$pb.TagNumber(4)
  set artist($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArtist() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtist() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get author => $_getSZ(4);
  @$pb.TagNumber(5)
  set author($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get genre => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get status => $_getIZ(7);
  @$pb.TagNumber(8)
  set status($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get thumbnailUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set thumbnailUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasThumbnailUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearThumbnailUrl() => $_clearField(9);

  @$pb.TagNumber(13)
  $fixnum.Int64 get dateAdded => $_getI64(9);
  @$pb.TagNumber(13)
  set dateAdded($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(13)
  $core.bool hasDateAdded() => $_has(9);
  @$pb.TagNumber(13)
  void clearDateAdded() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get viewer => $_getIZ(10);
  @$pb.TagNumber(14)
  set viewer($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(14)
  $core.bool hasViewer() => $_has(10);
  @$pb.TagNumber(14)
  void clearViewer() => $_clearField(14);

  @$pb.TagNumber(16)
  $pb.PbList<$0.BackupChapter> get chapters => $_getList(11);

  @$pb.TagNumber(17)
  $pb.PbList<$fixnum.Int64> get categories => $_getList(12);

  @$pb.TagNumber(100)
  $core.bool get favorite => $_getBF(13);
  @$pb.TagNumber(100)
  set favorite($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(100)
  $core.bool hasFavorite() => $_has(13);
  @$pb.TagNumber(100)
  void clearFavorite() => $_clearField(100);

  @$pb.TagNumber(101)
  $core.int get chapterFlags => $_getIZ(14);
  @$pb.TagNumber(101)
  set chapterFlags($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(101)
  $core.bool hasChapterFlags() => $_has(14);
  @$pb.TagNumber(101)
  void clearChapterFlags() => $_clearField(101);

  @$pb.TagNumber(103)
  $core.int get viewerFlags => $_getIZ(15);
  @$pb.TagNumber(103)
  set viewerFlags($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(103)
  $core.bool hasViewerFlags() => $_has(15);
  @$pb.TagNumber(103)
  void clearViewerFlags() => $_clearField(103);

  @$pb.TagNumber(104)
  $pb.PbList<$1.BackupHistory> get history => $_getList(16);

  @$pb.TagNumber(105)
  $core.int get updateStrategy => $_getIZ(17);
  @$pb.TagNumber(105)
  set updateStrategy($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(105)
  $core.bool hasUpdateStrategy() => $_has(17);
  @$pb.TagNumber(105)
  void clearUpdateStrategy() => $_clearField(105);

  @$pb.TagNumber(106)
  $fixnum.Int64 get lastModifiedAt => $_getI64(18);
  @$pb.TagNumber(106)
  set lastModifiedAt($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(106)
  $core.bool hasLastModifiedAt() => $_has(18);
  @$pb.TagNumber(106)
  void clearLastModifiedAt() => $_clearField(106);

  @$pb.TagNumber(107)
  $fixnum.Int64 get favoriteModifiedAt => $_getI64(19);
  @$pb.TagNumber(107)
  set favoriteModifiedAt($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(107)
  $core.bool hasFavoriteModifiedAt() => $_has(19);
  @$pb.TagNumber(107)
  void clearFavoriteModifiedAt() => $_clearField(107);

  @$pb.TagNumber(108)
  $pb.PbList<$core.String> get excludedScanlators => $_getList(20);

  @$pb.TagNumber(109)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(109)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(109)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(109)
  void clearVersion() => $_clearField(109);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
