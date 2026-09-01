import 'listing.dart';

enum SourceContentRating {
  safe(0),
  containsNsfw(1),
  primarilyNsfw(2);

  const SourceContentRating(this.value);
  final int value;

  static SourceContentRating fromValue(int val) {
    for (final r in values) {
      if (r.value == val) return r;
    }
    return SourceContentRating.safe;
  }
}

enum LanguageSelectType { single, multiple }

class Info {
  Info({
    required this.id,
    required this.name,
    this.altNames,
    required this.version,
    this.url,
    this.urls,
    this.contentRating,
    required this.languages,
  });

  final String id;
  final String name;
  final List<String>? altNames;
  final int version;
  final String? url;
  final List<String>? urls;
  final SourceContentRating? contentRating;
  final List<String> languages;

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      altNames: (json['altNames'] as List<dynamic>?)?.cast<String>(),
      version: json['version'] as int? ?? 1,
      url: json['url'] as String?,
      urls: (json['urls'] as List<dynamic>?)?.cast<String>(),
      contentRating: json['contentRating'] != null
          ? SourceContentRating.fromValue(json['contentRating'] as int)
          : null,
      languages: (json['languages'] as List<dynamic>?)?.cast<String>() ?? const ['en'],
    );
  }
}

class SourceConfiguration {
  SourceConfiguration({
    this.languageSelectType,
    this.supportsArtistSearch,
    this.supportsAuthorSearch,
    this.supportsTagSearch,
    this.allowsBaseUrlSelect,
    this.breakingChangeVersion,
    this.hidesFiltersWhileSearching,
    this.maximumParallelRequests,
  });

  final LanguageSelectType? languageSelectType;
  final bool? supportsArtistSearch;
  final bool? supportsAuthorSearch;
  final bool? supportsTagSearch;
  final bool? allowsBaseUrlSelect;
  final int? breakingChangeVersion;
  final bool? hidesFiltersWhileSearching;
  final int? maximumParallelRequests;

  factory SourceConfiguration.fromJson(Map<String, dynamic> json) {
    return SourceConfiguration(
      languageSelectType: json['languageSelectType'] != null
          ? LanguageSelectType.values.byName(json['languageSelectType'] as String)
          : null,
      supportsArtistSearch: json['supportsArtistSearch'] as bool?,
      supportsAuthorSearch: json['supportsAuthorSearch'] as bool?,
      supportsTagSearch: json['supportsTagSearch'] as bool?,
      allowsBaseUrlSelect: json['allowsBaseUrlSelect'] as bool?,
      breakingChangeVersion: json['breakingChangeVersion'] as int?,
      hidesFiltersWhileSearching: json['hidesFiltersWhileSearching'] as bool?,
      maximumParallelRequests: json['maximumParallelRequests'] as int?,
    );
  }
}

class SourceInfo {
  SourceInfo({
    required this.info,
    this.listings,
    this.config,
  });

  final Info info;
  final List<Listing>? listings;
  final SourceConfiguration? config;

  factory SourceInfo.fromJson(Map<String, dynamic> json) {
    final infoJson = json['info'] as Map<String, dynamic>? ?? json;
    final listingsJson = json['listings'] as List<dynamic>?;
    final configJson = json['config'] as Map<String, dynamic>?;

    final listings = listingsJson?.map((e) {
      if (e is String) {
        return Listing(id: e, name: e);
      } else if (e is Map<String, dynamic>) {
        return Listing(
          id: e['id'] as String? ?? '',
          name: e['name'] as String? ?? '',
          kind: ListingKind.fromValue(e['kind'] as int? ?? 0),
        );
      }
      return Listing(id: '$e', name: '$e');
    }).toList();

    return SourceInfo(
      info: Info.fromJson(infoJson),
      listings: listings,
      config: configJson != null ? SourceConfiguration.fromJson(configJson) : null,
    );
  }
}
