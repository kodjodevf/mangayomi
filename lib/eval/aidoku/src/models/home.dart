import 'chapter.dart';
import 'filter_value.dart';
import 'listing.dart';
import 'manga.dart';

sealed class LinkValue {
  const LinkValue();
}

class LinkValueUrl extends LinkValue {
  const LinkValueUrl(this.url);
  final String url;
}

class LinkValueListing extends LinkValue {
  const LinkValueListing(this.listing);
  final Listing listing;
}

class LinkValueManga extends LinkValue {
  const LinkValueManga(this.manga);
  final Manga manga;
}

class Link {
  Link({required this.title, this.subtitle, this.imageUrl, this.value});

  String title;
  String? subtitle;
  String? imageUrl;
  LinkValue? value;

  void setSourceKey(String sourceKey) {
    final v = value;
    if (v is LinkValueManga) {
      v.manga.sourceKey = sourceKey;
    }
  }
}

class FilterItem {
  FilterItem({required this.title, this.values});
  final String title;
  final List<FilterValue>? values;
}

class MangaWithChapter {
  MangaWithChapter({required this.manga, required this.chapter});
  final Manga manga;
  final Chapter chapter;
}

sealed class HomeComponentValue {
  const HomeComponentValue();

  int get intValue;
}

class HomeComponentValueImageScroller extends HomeComponentValue {
  const HomeComponentValueImageScroller({
    required this.links,
    this.autoScrollInterval,
    this.width,
    this.height,
  });
  final List<Link> links;
  final double? autoScrollInterval;
  final int? width;
  final int? height;
  @override
  int get intValue => 0;
}

class HomeComponentValueBigScroller extends HomeComponentValue {
  const HomeComponentValueBigScroller({
    required this.entries,
    this.autoScrollInterval,
  });
  final List<Manga> entries;
  final double? autoScrollInterval;
  @override
  int get intValue => 1;
}

class HomeComponentValueScroller extends HomeComponentValue {
  const HomeComponentValueScroller({required this.entries, this.listing});
  final List<Link> entries;
  final Listing? listing;
  @override
  int get intValue => 2;
}

class HomeComponentValueMangaList extends HomeComponentValue {
  const HomeComponentValueMangaList({
    this.ranking = false,
    this.pageSize,
    required this.entries,
    this.listing,
  });
  final bool ranking;
  final int? pageSize;
  final List<Link> entries;
  final Listing? listing;
  @override
  int get intValue => 3;
}

class HomeComponentValueMangaChapterList extends HomeComponentValue {
  const HomeComponentValueMangaChapterList({
    this.pageSize,
    required this.entries,
    this.listing,
  });
  final int? pageSize;
  final List<MangaWithChapter> entries;
  final Listing? listing;
  @override
  int get intValue => 4;
}

class HomeComponentValueFilters extends HomeComponentValue {
  const HomeComponentValueFilters(this.filters);
  final List<FilterItem> filters;
  @override
  int get intValue => 5;
}

class HomeComponentValueLinks extends HomeComponentValue {
  const HomeComponentValueLinks(this.links);
  final List<Link> links;
  @override
  int get intValue => 6;
}

class HomeComponent {
  HomeComponent({this.title, this.subtitle, required this.value});

  String? title;
  String? subtitle;
  HomeComponentValue value;

  void setSourceKey(String sourceKey) {
    final v = value;
    if (v is HomeComponentValueBigScroller) {
      for (final manga in v.entries) {
        manga.sourceKey = sourceKey;
      }
    } else if (v is HomeComponentValueScroller) {
      for (final link in v.entries) {
        link.setSourceKey(sourceKey);
      }
    } else if (v is HomeComponentValueMangaList) {
      for (final link in v.entries) {
        link.setSourceKey(sourceKey);
      }
    } else if (v is HomeComponentValueMangaChapterList) {
      for (final item in v.entries) {
        item.manga.sourceKey = sourceKey;
      }
    } else if (v is HomeComponentValueLinks) {
      for (final link in v.links) {
        link.setSourceKey(sourceKey);
      }
    }
  }
}

class Home {
  Home({required this.components});

  List<HomeComponent> components;

  void setSourceKey(String sourceKey) {
    for (final c in components) {
      c.setSourceKey(sourceKey);
    }
  }
}

sealed class HomePartialResult {
  const HomePartialResult();
}

class HomePartialResultLayout extends HomePartialResult {
  const HomePartialResultLayout(this.home);
  final Home home;
}

class HomePartialResultComponent extends HomePartialResult {
  const HomePartialResultComponent(this.component);
  final HomeComponent component;
}
