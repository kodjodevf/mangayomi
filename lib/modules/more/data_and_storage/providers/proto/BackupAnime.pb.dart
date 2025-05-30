//
//  Generated code. Do not modify.
//  source: BackupAnime.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'BackupEpisode.pb.dart' as $0;
import 'BackupHistory.pb.dart' as $1;

class BackupAnime extends $pb.GeneratedMessage {
  factory BackupAnime({
    $core.int? source,
    $core.String? url,
    $core.String? title,
    $core.String? artist,
    $core.String? author,
    $core.String? description,
    $core.Iterable<$core.String>? genre,
    $core.int? status,
    $core.String? thumbnailUrl,
    $core.int? dateAdded,
    $core.Iterable<$0.BackupEpisode>? episodes,
    $core.Iterable<$core.int>? categories,
    $core.int? viewerFlags,
    $core.Iterable<$1.BackupHistory>? history,
    $core.int? lastModifiedAt,
  }) {
    final $result = create();
    if (source != null) {
      $result.source = source;
    }
    if (url != null) {
      $result.url = url;
    }
    if (title != null) {
      $result.title = title;
    }
    if (artist != null) {
      $result.artist = artist;
    }
    if (author != null) {
      $result.author = author;
    }
    if (description != null) {
      $result.description = description;
    }
    if (genre != null) {
      $result.genre.addAll(genre);
    }
    if (status != null) {
      $result.status = status;
    }
    if (thumbnailUrl != null) {
      $result.thumbnailUrl = thumbnailUrl;
    }
    if (dateAdded != null) {
      $result.dateAdded = dateAdded;
    }
    if (episodes != null) {
      $result.episodes.addAll(episodes);
    }
    if (categories != null) {
      $result.categories.addAll(categories);
    }
    if (viewerFlags != null) {
      $result.viewerFlags = viewerFlags;
    }
    if (history != null) {
      $result.history.addAll(history);
    }
    if (lastModifiedAt != null) {
      $result.lastModifiedAt = lastModifiedAt;
    }
    return $result;
  }
  BackupAnime._() : super();
  factory BackupAnime.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupAnime.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupAnime',
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'source', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'artist')
    ..aOS(5, _omitFieldNames ? '' : 'author')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..pPS(7, _omitFieldNames ? '' : 'genre')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(9, _omitFieldNames ? '' : 'thumbnailUrl', protoName: 'thumbnailUrl')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'dateAdded', $pb.PbFieldType.O3,
        protoName: 'dateAdded')
    ..pc<$0.BackupEpisode>(
        16, _omitFieldNames ? '' : 'episodes', $pb.PbFieldType.PM,
        subBuilder: $0.BackupEpisode.create)
    ..p<$core.int>(17, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.K3)
    ..a<$core.int>(
        103, _omitFieldNames ? '' : 'viewerFlags', $pb.PbFieldType.O3)
    ..pc<$1.BackupHistory>(
        104, _omitFieldNames ? '' : 'history', $pb.PbFieldType.PM,
        subBuilder: $1.BackupHistory.create)
    ..a<$core.int>(
        106, _omitFieldNames ? '' : 'lastModifiedAt', $pb.PbFieldType.O3,
        protoName: 'lastModifiedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupAnime clone() => BackupAnime()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupAnime copyWith(void Function(BackupAnime) updates) =>
      super.copyWith((message) => updates(message as BackupAnime))
          as BackupAnime;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupAnime create() => BackupAnime._();
  BackupAnime createEmptyInstance() => create();
  static $pb.PbList<BackupAnime> createRepeated() => $pb.PbList<BackupAnime>();
  @$core.pragma('dart2js:noInline')
  static BackupAnime getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupAnime>(create);
  static BackupAnime? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get source => $_getIZ(0);
  @$pb.TagNumber(1)
  set source($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get artist => $_getSZ(3);
  @$pb.TagNumber(4)
  set artist($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasArtist() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtist() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get author => $_getSZ(4);
  @$pb.TagNumber(5)
  set author($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.String> get genre => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get status => $_getIZ(7);
  @$pb.TagNumber(8)
  set status($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get thumbnailUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set thumbnailUrl($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasThumbnailUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearThumbnailUrl() => clearField(9);

  @$pb.TagNumber(13)
  $core.int get dateAdded => $_getIZ(9);
  @$pb.TagNumber(13)
  set dateAdded($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasDateAdded() => $_has(9);
  @$pb.TagNumber(13)
  void clearDateAdded() => clearField(13);

  @$pb.TagNumber(16)
  $core.List<$0.BackupEpisode> get episodes => $_getList(10);

  @$pb.TagNumber(17)
  $core.List<$core.int> get categories => $_getList(11);

  @$pb.TagNumber(103)
  $core.int get viewerFlags => $_getIZ(12);
  @$pb.TagNumber(103)
  set viewerFlags($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(103)
  $core.bool hasViewerFlags() => $_has(12);
  @$pb.TagNumber(103)
  void clearViewerFlags() => clearField(103);

  @$pb.TagNumber(104)
  $core.List<$1.BackupHistory> get history => $_getList(13);

  @$pb.TagNumber(106)
  $core.int get lastModifiedAt => $_getIZ(14);
  @$pb.TagNumber(106)
  set lastModifiedAt($core.int v) {
    $_setSignedInt32(14, v);
  }

  @$pb.TagNumber(106)
  $core.bool hasLastModifiedAt() => $_has(14);
  @$pb.TagNumber(106)
  void clearLastModifiedAt() => clearField(106);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
