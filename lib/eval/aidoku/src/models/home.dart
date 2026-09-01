import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
import 'filter_value.dart';
import 'listing.dart';
import 'manga.dart';
import 'chapter.dart';

sealed class LinkValue {
  const LinkValue();

  factory LinkValue.fromPostcard(PostcardReader reader) {
    final type = reader.readU8();
    switch (type) {
      case 0:
        return LinkValueUrl(reader.readString());
      case 1:
        return LinkValueListing(Listing.fromPostcard(reader));
      case 2:
        return LinkValueManga(Manga.fromPostcard(reader));
      default:
        throw FormatException('Invalid LinkValue type: $type');
    }
  }

  void toPostcard(PostcardWriter writer);
}

class LinkValueUrl extends LinkValue {
  const LinkValueUrl(this.url);
  final String url;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(0);
    writer.writeString(url);
  }
}

class LinkValueListing extends LinkValue {
  const LinkValueListing(this.listing);
  final Listing listing;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(1);
    listing.toPostcard(writer);
  }
}

class LinkValueManga extends LinkValue {
  const LinkValueManga(this.manga);
  final Manga manga;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(2);
    manga.toPostcard(writer);
  }
}

class Link {
  Link({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.value,
  });

  String title;
  String? subtitle;
  String? imageUrl;
  LinkValue? value;

  factory Link.fromPostcard(PostcardReader reader) {
    final title = reader.readString();
    final subtitle = reader.readOption((r) => r.readString());
    final imageUrl = reader.readOption((r) => r.readString());
    final value = reader.readOption((r) => LinkValue.fromPostcard(r));

    return Link(
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      value: value,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(title);
    writer.writeOption(subtitle, (w, s) => w.writeString(s));
    writer.writeOption(imageUrl, (w, s) => w.writeString(s));
    writer.writeOption(value, (w, v) => v.toPostcard(w));
  }

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

  factory FilterItem.fromPostcard(PostcardReader reader) {
    final title = reader.readString();
    final values = reader.readOption((r) => r.readList((r2) => FilterValue.fromPostcard(r2)));
    return FilterItem(title: title, values: values);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(title);
    writer.writeOption(
      values,
      (w, list) => w.writeList(list, (w2, fv) => fv.toPostcard(w2)),
    );
  }
}

class MangaWithChapter {
  MangaWithChapter({required this.manga, required this.chapter});
  final Manga manga;
  final Chapter chapter;

  factory MangaWithChapter.fromPostcard(PostcardReader reader) {
    final manga = Manga.fromPostcard(reader);
    final chapter = Chapter.fromPostcard(reader);
    return MangaWithChapter(manga: manga, chapter: chapter);
  }

  void toPostcard(PostcardWriter writer) {
    manga.toPostcard(writer);
    chapter.toPostcard(writer);
  }
}

sealed class HomeComponentValue {
  const HomeComponentValue();

  int get intValue;

  factory HomeComponentValue.fromPostcard(PostcardReader reader) {
    final type = reader.readU8();
    switch (type) {
      case 0:
        final links = reader.readList((r) => Link.fromPostcard(r));
        final autoScroll = reader.readOption((r) => r.readF32());
        final width = reader.readOption((r) => r.readI64());
        final height = reader.readOption((r) => r.readI64());
        return HomeComponentValueImageScroller(
          links: links,
          autoScrollInterval: autoScroll,
          width: width,
          height: height,
        );
      case 1:
        final entries = reader.readList((r) => Manga.fromPostcard(r));
        final autoScroll = reader.readOption((r) => r.readF32());
        return HomeComponentValueBigScroller(entries: entries, autoScrollInterval: autoScroll);
      case 2:
        final entries = reader.readList((r) => Link.fromPostcard(r));
        final listing = reader.readOption((r) => Listing.fromPostcard(r));
        return HomeComponentValueScroller(entries: entries, listing: listing);
      case 3:
        final ranking = reader.readBool();
        final pageSize = reader.readOption((r) => r.readI64());
        final entries = reader.readList((r) => Link.fromPostcard(r));
        final listing = reader.readOption((r) => Listing.fromPostcard(r));
        return HomeComponentValueMangaList(
          ranking: ranking,
          pageSize: pageSize,
          entries: entries,
          listing: listing,
        );
      case 4:
        final pageSize = reader.readOption((r) => r.readI64());
        final entries = reader.readList((r) => MangaWithChapter.fromPostcard(r));
        final listing = reader.readOption((r) => Listing.fromPostcard(r));
        return HomeComponentValueMangaChapterList(
          pageSize: pageSize,
          entries: entries,
          listing: listing,
        );
      case 5:
        final filters = reader.readList((r) => FilterItem.fromPostcard(r));
        return HomeComponentValueFilters(filters);
      case 6:
        final links = reader.readList((r) => Link.fromPostcard(r));
        return HomeComponentValueLinks(links);
      default:
        throw FormatException('Invalid HomeComponentValue type: $type');
    }
  }

  void toPostcard(PostcardWriter writer);
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(0);
    writer.writeList(links, (w, l) => l.toPostcard(w));
    writer.writeOption(autoScrollInterval, (w, v) => w.writeF32(v));
    writer.writeOption(width, (w, v) => w.writeI64(v));
    writer.writeOption(height, (w, v) => w.writeI64(v));
  }
}

class HomeComponentValueBigScroller extends HomeComponentValue {
  const HomeComponentValueBigScroller({required this.entries, this.autoScrollInterval});
  final List<Manga> entries;
  final double? autoScrollInterval;
  @override
  int get intValue => 1;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(1);
    writer.writeList(entries, (w, m) => m.toPostcard(w));
    writer.writeOption(autoScrollInterval, (w, v) => w.writeF32(v));
  }
}

class HomeComponentValueScroller extends HomeComponentValue {
  const HomeComponentValueScroller({required this.entries, this.listing});
  final List<Link> entries;
  final Listing? listing;
  @override
  int get intValue => 2;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(2);
    writer.writeList(entries, (w, l) => l.toPostcard(w));
    writer.writeOption(listing, (w, l) => l.toPostcard(w));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(3);
    writer.writeBool(ranking);
    writer.writeOption(pageSize, (w, v) => w.writeI64(v));
    writer.writeList(entries, (w, l) => l.toPostcard(w));
    writer.writeOption(listing, (w, l) => l.toPostcard(w));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(4);
    writer.writeOption(pageSize, (w, v) => w.writeI64(v));
    writer.writeList(entries, (w, mc) => mc.toPostcard(w));
    writer.writeOption(listing, (w, l) => l.toPostcard(w));
  }
}

class HomeComponentValueFilters extends HomeComponentValue {
  const HomeComponentValueFilters(this.filters);
  final List<FilterItem> filters;
  @override
  int get intValue => 5;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(5);
    writer.writeList(filters, (w, f) => f.toPostcard(w));
  }
}

class HomeComponentValueLinks extends HomeComponentValue {
  const HomeComponentValueLinks(this.links);
  final List<Link> links;
  @override
  int get intValue => 6;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(6);
    writer.writeList(links, (w, l) => l.toPostcard(w));
  }
}

class HomeComponent {
  HomeComponent({this.title, this.subtitle, required this.value});

  String? title;
  String? subtitle;
  HomeComponentValue value;

  factory HomeComponent.fromPostcard(PostcardReader reader) {
    final title = reader.readOption((r) => r.readString());
    final subtitle = reader.readOption((r) => r.readString());
    final value = HomeComponentValue.fromPostcard(reader);
    return HomeComponent(title: title, subtitle: subtitle, value: value);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(title, (w, s) => w.writeString(s));
    writer.writeOption(subtitle, (w, s) => w.writeString(s));
    value.toPostcard(writer);
  }

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

  factory Home.fromPostcard(PostcardReader reader) {
    final components = reader.readList((r) => HomeComponent.fromPostcard(r));
    return Home(components: components);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeList(components, (w, c) => c.toPostcard(w));
  }

  void setSourceKey(String sourceKey) {
    for (final c in components) {
      c.setSourceKey(sourceKey);
    }
  }
}

sealed class HomePartialResult {
  const HomePartialResult();

  factory HomePartialResult.fromPostcard(PostcardReader reader) {
    final type = reader.readU8();
    switch (type) {
      case 0:
        return HomePartialResultLayout(Home.fromPostcard(reader));
      case 1:
        return HomePartialResultComponent(HomeComponent.fromPostcard(reader));
      default:
        throw FormatException('Invalid HomePartialResult type: $type');
    }
  }

  void toPostcard(PostcardWriter writer);
}

class HomePartialResultLayout extends HomePartialResult {
  const HomePartialResultLayout(this.home);
  final Home home;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(0);
    home.toPostcard(writer);
  }
}

class HomePartialResultComponent extends HomePartialResult {
  const HomePartialResultComponent(this.component);
  final HomeComponent component;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(1);
    component.toPostcard(writer);
  }
}
