import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:image/image.dart' as images;

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  static Future<images.Image?> readBookCover(EpubBookRef bookRef) async {
    EpubManifestItem? coverManifestItem =
        bookRef.Schema!.Package!.Manifest!.Items!.firstWhereOrNull(
      (i) => i.Properties == "cover-image",
    );

    if (coverManifestItem == null) {
      var metaItems = bookRef.Schema!.Package!.Metadata!.MetaItems;
      if (metaItems == null || metaItems.isEmpty) return null;

      var coverMetaItem = metaItems.firstWhereOrNull(
          (EpubMetadataMeta metaItem) =>
              metaItem.Name != null && metaItem.Name!.toLowerCase() == 'cover');
      if (coverMetaItem == null) return null;
      if (coverMetaItem.Content == null || coverMetaItem.Content!.isEmpty) {
        throw Exception(
            'Incorrect EPUB metadata: cover item content is missing.');
      }

      coverManifestItem = bookRef.Schema!.Package!.Manifest!.Items!
          .firstWhereOrNull((EpubManifestItem manifestItem) =>
              manifestItem.Id!.toLowerCase() ==
              coverMetaItem.Content!.toLowerCase());
    }

    if (coverManifestItem == null) {
      throw Exception('Incorrect EPUB manifest');
    }

    EpubByteContentFileRef? coverImageContentFileRef;
    if (!bookRef.Content!.Images!.containsKey(coverManifestItem.Href)) {
      throw Exception(
          'Incorrect EPUB manifest: item with href = \"${coverManifestItem.Href}\" is missing.');
    }

    coverImageContentFileRef = bookRef.Content!.Images![coverManifestItem.Href];
    var coverImageContent =
        await coverImageContentFileRef!.readContentAsBytes();
    var retval = images.decodeImage(Uint8List.fromList(coverImageContent));
    return retval;
  }
}
