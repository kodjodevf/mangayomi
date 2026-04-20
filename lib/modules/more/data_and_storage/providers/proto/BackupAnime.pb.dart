// This is a generated file - do not edit.
//
// Generated from BackupAnime.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupEpisode.pb.dart' as $0;
import 'BackupHistory.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupAnime extends $pb.GeneratedMessage {
  factory BackupAnime({
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
    $core.Iterable<$0.BackupEpisode>? episodes,
    $core.Iterable<$fixnum.Int64>? categories,
    $core.bool? favorite,
    $core.int? episodeFlags,
    $core.int? viewerFlags,
    $core.Iterable<$1.BackupHistory>? history,
    $core.int? updateStrategy,
    $fixnum.Int64? lastModifiedAt,
    $fixnum.Int64? favoriteModifiedAt,
    $fixnum.Int64? version,
    $core.String? backgroundUrl,
    $fixnum.Int64? parentId,
    $fixnum.Int64? id,
    $fixnum.Int64? seasonFlags,
    $core.double? seasonNumber,
    $fixnum.Int64? seasonSourceOrder,
    $core.int? fetchType,
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
    if (episodes != null) result.episodes.addAll(episodes);
    if (categories != null) result.categories.addAll(categories);
    if (favorite != null) result.favorite = favorite;
    if (episodeFlags != null) result.episodeFlags = episodeFlags;
    if (viewerFlags != null) result.viewerFlags = viewerFlags;
    if (history != null) result.history.addAll(history);
    if (updateStrategy != null) result.updateStrategy = updateStrategy;
    if (lastModifiedAt != null) result.lastModifiedAt = lastModifiedAt;
    if (favoriteModifiedAt != null)
      result.favoriteModifiedAt = favoriteModifiedAt;
    if (version != null) result.version = version;
    if (backgroundUrl != null) result.backgroundUrl = backgroundUrl;
    if (parentId != null) result.parentId = parentId;
    if (id != null) result.id = id;
    if (seasonFlags != null) result.seasonFlags = seasonFlags;
    if (seasonNumber != null) result.seasonNumber = seasonNumber;
    if (seasonSourceOrder != null) result.seasonSourceOrder = seasonSourceOrder;
    if (fetchType != null) result.fetchType = fetchType;
    return result;
  }

  BackupAnime._();

  factory BackupAnime.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BackupAnime.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupAnime',
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
    ..pPM<$0.BackupEpisode>(16, _omitFieldNames ? '' : 'episodes',
        subBuilder: $0.BackupEpisode.create)
    ..p<$fixnum.Int64>(
        17, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.K6)
    ..aOB(100, _omitFieldNames ? '' : 'favorite')
    ..aI(101, _omitFieldNames ? '' : 'episodeFlags', protoName: 'episodeFlags')
    ..aI(103, _omitFieldNames ? '' : 'viewerFlags')
    ..pPM<$1.BackupHistory>(104, _omitFieldNames ? '' : 'history',
        subBuilder: $1.BackupHistory.create)
    ..aI(105, _omitFieldNames ? '' : 'updateStrategy',
        protoName: 'updateStrategy')
    ..aInt64(106, _omitFieldNames ? '' : 'lastModifiedAt',
        protoName: 'lastModifiedAt')
    ..aInt64(107, _omitFieldNames ? '' : 'favoriteModifiedAt',
        protoName: 'favoriteModifiedAt')
    ..aInt64(109, _omitFieldNames ? '' : 'version')
    ..aOS(500, _omitFieldNames ? '' : 'backgroundUrl',
        protoName: 'backgroundUrl')
    ..aInt64(502, _omitFieldNames ? '' : 'parentId', protoName: 'parentId')
    ..aInt64(503, _omitFieldNames ? '' : 'id')
    ..aInt64(504, _omitFieldNames ? '' : 'seasonFlags',
        protoName: 'seasonFlags')
    ..aD(505, _omitFieldNames ? '' : 'seasonNumber', protoName: 'seasonNumber')
    ..aInt64(506, _omitFieldNames ? '' : 'seasonSourceOrder',
        protoName: 'seasonSourceOrder')
    ..aI(507, _omitFieldNames ? '' : 'fetchType', protoName: 'fetchType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupAnime clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupAnime copyWith(void Function(BackupAnime) updates) =>
      super.copyWith((message) => updates(message as BackupAnime))
          as BackupAnime;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupAnime create() => BackupAnime._();
  @$core.override
  BackupAnime createEmptyInstance() => create();
  static $pb.PbList<BackupAnime> createRepeated() => $pb.PbList<BackupAnime>();
  @$core.pragma('dart2js:noInline')
  static BackupAnime getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupAnime>(create);
  static BackupAnime? _defaultInstance;

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

  @$pb.TagNumber(16)
  $pb.PbList<$0.BackupEpisode> get episodes => $_getList(10);

  @$pb.TagNumber(17)
  $pb.PbList<$fixnum.Int64> get categories => $_getList(11);

  @$pb.TagNumber(100)
  $core.bool get favorite => $_getBF(12);
  @$pb.TagNumber(100)
  set favorite($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(100)
  $core.bool hasFavorite() => $_has(12);
  @$pb.TagNumber(100)
  void clearFavorite() => $_clearField(100);

  @$pb.TagNumber(101)
  $core.int get episodeFlags => $_getIZ(13);
  @$pb.TagNumber(101)
  set episodeFlags($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(101)
  $core.bool hasEpisodeFlags() => $_has(13);
  @$pb.TagNumber(101)
  void clearEpisodeFlags() => $_clearField(101);

  @$pb.TagNumber(103)
  $core.int get viewerFlags => $_getIZ(14);
  @$pb.TagNumber(103)
  set viewerFlags($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(103)
  $core.bool hasViewerFlags() => $_has(14);
  @$pb.TagNumber(103)
  void clearViewerFlags() => $_clearField(103);

  @$pb.TagNumber(104)
  $pb.PbList<$1.BackupHistory> get history => $_getList(15);

  @$pb.TagNumber(105)
  $core.int get updateStrategy => $_getIZ(16);
  @$pb.TagNumber(105)
  set updateStrategy($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(105)
  $core.bool hasUpdateStrategy() => $_has(16);
  @$pb.TagNumber(105)
  void clearUpdateStrategy() => $_clearField(105);

  @$pb.TagNumber(106)
  $fixnum.Int64 get lastModifiedAt => $_getI64(17);
  @$pb.TagNumber(106)
  set lastModifiedAt($fixnum.Int64 value) => $_setInt64(17, value);
  @$pb.TagNumber(106)
  $core.bool hasLastModifiedAt() => $_has(17);
  @$pb.TagNumber(106)
  void clearLastModifiedAt() => $_clearField(106);

  @$pb.TagNumber(107)
  $fixnum.Int64 get favoriteModifiedAt => $_getI64(18);
  @$pb.TagNumber(107)
  set favoriteModifiedAt($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(107)
  $core.bool hasFavoriteModifiedAt() => $_has(18);
  @$pb.TagNumber(107)
  void clearFavoriteModifiedAt() => $_clearField(107);

  @$pb.TagNumber(109)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(109)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(109)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(109)
  void clearVersion() => $_clearField(109);

  @$pb.TagNumber(500)
  $core.String get backgroundUrl => $_getSZ(20);
  @$pb.TagNumber(500)
  set backgroundUrl($core.String value) => $_setString(20, value);
  @$pb.TagNumber(500)
  $core.bool hasBackgroundUrl() => $_has(20);
  @$pb.TagNumber(500)
  void clearBackgroundUrl() => $_clearField(500);

  @$pb.TagNumber(502)
  $fixnum.Int64 get parentId => $_getI64(21);
  @$pb.TagNumber(502)
  set parentId($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(502)
  $core.bool hasParentId() => $_has(21);
  @$pb.TagNumber(502)
  void clearParentId() => $_clearField(502);

  @$pb.TagNumber(503)
  $fixnum.Int64 get id => $_getI64(22);
  @$pb.TagNumber(503)
  set id($fixnum.Int64 value) => $_setInt64(22, value);
  @$pb.TagNumber(503)
  $core.bool hasId() => $_has(22);
  @$pb.TagNumber(503)
  void clearId() => $_clearField(503);

  @$pb.TagNumber(504)
  $fixnum.Int64 get seasonFlags => $_getI64(23);
  @$pb.TagNumber(504)
  set seasonFlags($fixnum.Int64 value) => $_setInt64(23, value);
  @$pb.TagNumber(504)
  $core.bool hasSeasonFlags() => $_has(23);
  @$pb.TagNumber(504)
  void clearSeasonFlags() => $_clearField(504);

  @$pb.TagNumber(505)
  $core.double get seasonNumber => $_getN(24);
  @$pb.TagNumber(505)
  set seasonNumber($core.double value) => $_setDouble(24, value);
  @$pb.TagNumber(505)
  $core.bool hasSeasonNumber() => $_has(24);
  @$pb.TagNumber(505)
  void clearSeasonNumber() => $_clearField(505);

  @$pb.TagNumber(506)
  $fixnum.Int64 get seasonSourceOrder => $_getI64(25);
  @$pb.TagNumber(506)
  set seasonSourceOrder($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(506)
  $core.bool hasSeasonSourceOrder() => $_has(25);
  @$pb.TagNumber(506)
  void clearSeasonSourceOrder() => $_clearField(506);

  @$pb.TagNumber(507)
  $core.int get fetchType => $_getIZ(26);
  @$pb.TagNumber(507)
  set fetchType($core.int value) => $_setSignedInt32(26, value);
  @$pb.TagNumber(507)
  $core.bool hasFetchType() => $_has(26);
  @$pb.TagNumber(507)
  void clearFetchType() => $_clearField(507);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
