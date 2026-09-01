import 'dart:typed_data';

import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
import '../store/global_store.dart';

typedef PageContext = Map<String, String>;

/// Sealed class representing the content of a page.
sealed class PageContent {
  const PageContent();

  factory PageContent.fromPostcard(PostcardReader reader, GlobalStore store) {
    final type = reader.readU8();
    switch (type) {
      case 0:
        final url = reader.readString();
        final hasContext = reader.readU8() == 1;
        PageContext? context;
        if (hasContext) {
          context = reader.readMap((r) => r.readString(), (r) => r.readString());
        }
        return PageContentUrl(url: url, context: context);
      case 1:
        final text = reader.readString();
        return PageContentText(text);
      case 2:
        final imageRef = reader.readI32();
        final img = store.fetch(imageRef);
        return PageContentImage(imageRef: imageRef, imageData: img is Uint8List ? img : null);
      case 3:
        final url = reader.readString();
        final filePath = reader.readString();
        return PageContentZipFile(url: url, filePath: filePath);
      default:
        throw FormatException('Invalid PageContent type: $type');
    }
  }

  void toPostcard(PostcardWriter writer, GlobalStore store);
}

class PageContentUrl extends PageContent {
  const PageContentUrl({required this.url, this.context});
  final String url;
  final PageContext? context;

  @override
  void toPostcard(PostcardWriter writer, GlobalStore store) {
    writer.writeU8(0);
    writer.writeString(url);
    if (context != null) {
      writer.writeU8(1);
      writer.writeMap(context!, (w, k) => w.writeString(k), (w, v) => w.writeString(v));
    } else {
      writer.writeU8(0);
    }
  }

  @override
  String toString() => 'PageContentUrl(url: $url, context: $context)';
}

class PageContentText extends PageContent {
  const PageContentText(this.text);
  final String text;

  @override
  void toPostcard(PostcardWriter writer, GlobalStore store) {
    writer.writeU8(1);
    writer.writeString(text);
  }

  @override
  String toString() => 'PageContentText($text)';
}

class PageContentImage extends PageContent {
  const PageContentImage({required this.imageRef, this.imageData});
  final int imageRef;
  final Uint8List? imageData;

  @override
  void toPostcard(PostcardWriter writer, GlobalStore store) {
    writer.writeU8(2);
    final ref = imageData != null ? store.store(imageData!) : imageRef;
    writer.writeI32(ref);
  }

  @override
  String toString() => 'PageContentImage(imageRef: $imageRef)';
}

class PageContentZipFile extends PageContent {
  const PageContentZipFile({required this.url, required this.filePath});
  final String url;
  final String filePath;

  @override
  void toPostcard(PostcardWriter writer, GlobalStore store) {
    writer.writeU8(3);
    writer.writeString(url);
    writer.writeString(filePath);
  }

  @override
  String toString() => 'PageContentZipFile(url: $url, filePath: $filePath)';
}

/// Represents a single page in a chapter.
class Page {
  Page({
    required this.content,
    this.thumbnail,
    this.hasDescription = false,
    this.description,
  });

  PageContent content;
  String? thumbnail;
  bool hasDescription;
  String? description;

  factory Page.fromPostcard(PostcardReader reader, GlobalStore store) {
    final content = PageContent.fromPostcard(reader, store);
    final thumbnail = reader.readOption((r) => r.readString());
    final hasDescription = reader.readBool();
    final description = reader.readOption((r) => r.readString());

    return Page(
      content: content,
      thumbnail: thumbnail,
      hasDescription: hasDescription,
      description: description,
    );
  }

  void toPostcard(PostcardWriter writer, GlobalStore store) {
    content.toPostcard(writer, store);
    writer.writeOption(thumbnail, (w, s) => w.writeString(s));
    writer.writeBool(hasDescription);
    writer.writeOption(description, (w, s) => w.writeString(s));
  }

  @override
  String toString() => 'Page(content: $content, thumbnail: $thumbnail)';
}
