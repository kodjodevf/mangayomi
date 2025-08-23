import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
part 'source.g.dart';

@collection
@Name("Sources")
class Source {
  Id? id;

  String? name;

  String? baseUrl;

  String? lang;

  bool? isActive;

  bool? isAdded;

  bool? isPinned;

  bool? isNsfw;

  String? sourceCode;

  String? sourceCodeUrl;

  String? typeSource;

  String? iconUrl;

  bool? isFullData;

  bool? hasCloudflare;

  bool? lastUsed;

  String? dateFormat;

  String? dateFormatLocale;

  String? apiUrl;

  String? version;

  String? versionLast;

  String? headers;

  /// For Mihon ext
  bool? supportLatest;

  /// For Mihon ext
  String? filterList;

  /// For Mihon ext
  String? preferenceList;

  bool? isManga;

  @enumerated
  late ItemType itemType;

  String? appMinVerReq;

  String? additionalParams;

  bool? isLocal;

  bool? isObsolete;

  @enumerated
  SourceCodeLanguage sourceCodeLanguage = SourceCodeLanguage.dart;

  String? notes;

  Repo? repo;

  int? updatedAt;

  Source({
    this.id = 0,
    this.name = '',
    this.baseUrl = '',
    this.lang = '',
    this.typeSource = '',
    this.iconUrl = '',
    this.dateFormat = '',
    this.dateFormatLocale = '',
    this.isActive = true,
    this.isAdded = false,
    this.isNsfw = false,
    this.isFullData = false,
    this.hasCloudflare = false,
    this.isPinned = false,
    this.lastUsed = false,
    this.apiUrl = "",
    this.sourceCodeUrl = "",
    this.version = "0.0.1",
    this.versionLast = "0.0.1",
    this.sourceCode = '',
    this.headers = '',
    this.supportLatest,
    this.filterList,
    this.preferenceList,
    this.isManga,
    this.itemType = ItemType.manga,
    this.appMinVerReq = "",
    this.additionalParams = "",
    this.isLocal = false,
    this.isObsolete = false,
    this.notes = '',
    this.repo,
    this.updatedAt = 0,
  });

  FilterList? getFilterList() => filterList != null
      ? FilterList.fromJson(jsonDecode(filterList!) as Map<String, dynamic>)
      : null;

  Source.fromJson(Map<String, dynamic> json) {
    apiUrl = json['apiUrl'];
    appMinVerReq = json['appMinVerReq'];
    baseUrl = json['baseUrl'];
    dateFormat = json['dateFormat'];
    dateFormatLocale = json['dateFormatLocale'];
    hasCloudflare = json['hasCloudflare'];
    headers = json['headers'];
    supportLatest = json['supportLatest'];
    filterList = json['filterList'];
    preferenceList = json['preferenceList'];
    iconUrl = json['iconUrl'];
    id = json['id'];
    isActive = json['isActive'];
    isAdded = json['isAdded'];
    isFullData = json['isFullData'];
    isManga = json['isManga'];
    itemType = ItemType.values[json['itemType'] ?? 0];
    isNsfw = json['isNsfw'];
    isPinned = json['isPinned'];
    lang = json['lang'];
    lastUsed = json['lastUsed'];
    name = json['name'];
    sourceCode = json['sourceCode'];
    sourceCodeUrl = json['sourceCodeUrl'];
    typeSource = json['typeSource'];
    version = json['version'];
    versionLast = json['versionLast'];
    additionalParams = json['additionalParams'] ?? "";
    isObsolete = json['isObsolete'];
    isLocal = json['isLocal'];
    sourceCodeLanguage =
        SourceCodeLanguage.values[json['sourceCodeLanguage'] ?? 0];
    notes = json['notes'] ?? "";
    repo = json['repo'] != null ? Repo.fromJson(json['repo']) : null;
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
    'apiUrl': apiUrl,
    'appMinVerReq': appMinVerReq,
    'baseUrl': baseUrl,
    'dateFormat': dateFormat,
    'dateFormatLocale': dateFormatLocale,
    'hasCloudflare': hasCloudflare,
    'headers': headers,
    'supportLatest': supportLatest,
    'filterList': filterList,
    'preferenceList': preferenceList,
    'iconUrl': iconUrl,
    'id': id,
    'isActive': isActive,
    'isAdded': isAdded,
    'isFullData': isFullData,
    'isManga': isManga,
    'itemType': itemType.index,
    'isNsfw': isNsfw,
    'isPinned': isPinned,
    'lang': lang,
    'lastUsed': lastUsed,
    'name': name,
    'sourceCode': sourceCode,
    'sourceCodeUrl': sourceCodeUrl,
    'typeSource': typeSource,
    'version': version,
    'versionLast': versionLast,
    'additionalParams': additionalParams,
    'sourceCodeLanguage': sourceCodeLanguage.index,
    'isObsolete': isObsolete,
    'isLocal': isLocal,
    'notes': notes,
    'repo': repo?.toJson(),
    'updatedAt': updatedAt ?? 0,
  };

  bool get isTorrent => (typeSource?.toLowerCase() ?? "") == "torrent";

  MSource toMSource() {
    return MSource(
      id: id,
      name: name,
      hasCloudflare: hasCloudflare,
      isFullData: isFullData,
      lang: lang,
      baseUrl: baseUrl,
      apiUrl: apiUrl,
      dateFormat: dateFormat,
      dateFormatLocale: dateFormatLocale,
      additionalParams: additionalParams,
    );
  }
}

enum SourceCodeLanguage { dart, javascript, mihon }
