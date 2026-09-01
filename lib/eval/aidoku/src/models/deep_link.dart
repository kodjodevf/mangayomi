import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
import 'listing.dart';

class DeepLinkResult {
  DeepLinkResult({this.mangaKey, this.chapterKey, this.listing});

  String? mangaKey;
  String? chapterKey;
  Listing? listing;

  factory DeepLinkResult.fromPostcard(PostcardReader reader) {
    final mangaKey = reader.readOption((r) => r.readString());
    final chapterKey = reader.readOption((r) => r.readString());
    final listing = reader.readOption((r) => Listing.fromPostcard(r));
    return DeepLinkResult(
      mangaKey: mangaKey,
      chapterKey: chapterKey,
      listing: listing,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(mangaKey, (w, s) => w.writeString(s));
    writer.writeOption(chapterKey, (w, s) => w.writeString(s));
    writer.writeOption(listing, (w, l) => l.toPostcard(w));
  }

  @override
  String toString() => 'DeepLinkResult(manga: $mangaKey, chapter: $chapterKey, listing: $listing)';
}
