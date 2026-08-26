import 'dart:typed_data';

typedef PageContext = Map<String, String>;

/// Sealed class representing the content of a page.
sealed class PageContent {
  const PageContent();
}

class PageContentUrl extends PageContent {
  const PageContentUrl({required this.url, this.context});
  final String url;
  final PageContext? context;

  @override
  String toString() => 'PageContentUrl(url: $url, context: $context)';
}

class PageContentText extends PageContent {
  const PageContentText(this.text);
  final String text;

  @override
  String toString() => 'PageContentText(${text.length} chars)';
}

class PageContentImage extends PageContent {
  const PageContentImage({required this.imageRef, this.imageData});
  final int imageRef;
  final Uint8List? imageData;

  @override
  String toString() =>
      'PageContentImage(ref: $imageRef, bytes: ${imageData?.length ?? 0})';
}

class PageContentZipFile extends PageContent {
  const PageContentZipFile({required this.url, required this.filePath});
  final String url;
  final String filePath;

  @override
  String toString() => 'PageContentZipFile(url: $url, filePath: $filePath)';
}

/// Represents a single page within a chapter.
class Page {
  Page({
    required this.content,
    this.thumbnail,
    this.hasDescription = false,
    this.description,
  });

  /// The content of the page.
  PageContent content;

  /// Optional thumbnail image url for the page.
  String? thumbnail;

  /// Boolean indicating if the page has a description.
  bool hasDescription;

  /// Optional description text for the page.
  String? description;

  @override
  String toString() => 'Page(content: $content)';
}
