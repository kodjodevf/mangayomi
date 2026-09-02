import 'listing.dart';

class DeepLinkResult {
  DeepLinkResult({this.mangaKey, this.chapterKey, this.listing});

  String? mangaKey;
  String? chapterKey;
  Listing? listing;

  @override
  String toString() =>
      'DeepLinkResult(manga: $mangaKey, chapter: $chapterKey, listing: $listing)';
}
