import 'dart:io';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:path/path.dart' as p;
import 'package:html/parser.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_html_content.g.dart';

@riverpod
Future<(String, EpubNovel?)> getHtmlContent(
  Ref ref, {
  required Chapter chapter,
}) async {
  final keepAlive = ref.keepAlive();
  (String, EpubNovel?)? result;
  try {
    if (!chapter.manga.isLoaded) {
      chapter.manga.loadSync();
    }
    if (chapter.archivePath != null && chapter.archivePath!.isNotEmpty) {
      try {
        final book = await parseEpubFromPath(
          epubPath: chapter.archivePath!,
          fullData: true,
        );
        String htmlContent = "";
        for (var subChapter in book.chapters) {
          htmlContent += "\n<hr/>\n${subChapter.content}";
        }
        result = (_buildHtml(htmlContent), book);
      } catch (_) {}

      result ??= (_buildHtml("Local epub file not found!"), null);
    }
    if (result == null) {
      final storageProvider = StorageProvider();
      final mangaMainDirectory = await storageProvider.getMangaMainDirectory(
        chapter,
      );
      final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
        chapter,
        mangaMainDirectory: mangaMainDirectory,
      ))!;

      final htmlPath = p.join(chapterDirectory.path, "${chapter.name}.html");

      final htmlFile = File(htmlPath);
      String? htmlContent;
      if (await htmlFile.exists()) {
        htmlContent = await htmlFile.readAsString();
      }
      final source = getSource(
        chapter.manga.value!.lang!,
        chapter.manga.value!.source!,
        chapter.manga.value!.sourceId,
      );
      final proxyServer = ref.read(androidProxyServerStateProvider);
      final html = await withExtensionService(source!, proxyServer, (
        service,
      ) async {
        if (htmlContent != null) {
          return await service.cleanHtmlContent(htmlContent);
        } else {
          return await service.getHtmlContent(
            chapter.manga.value!.name!,
            chapter.url!,
          );
        }
      });
      result = (_buildHtml(html.substring(1, html.length - 1)), null);
    }

    keepAlive.close();
    return result;
  } catch (e) {
    keepAlive.close();
    rethrow;
  }
}

String _buildHtml(String input) {
  // Decode basic escapes
  String cleaned = input
      .replaceAll("\\n", "")
      .replaceAll("\\t", "")
      .replaceAll("\\\"", "\"")
      .replaceAll("\\'", "'")
      .replaceAll("\\&quot;", "\"")
      .replaceAll("&quot;", "\"");

  // Parse HTML to clean it
  final document = parse(cleaned);

  // Remove unwanted elements (ads, tracking, etc.)
  document.querySelectorAll('iframe').forEach((el) => el.remove());
  document.querySelectorAll('script').forEach((el) => el.remove());
  document.querySelectorAll('[data-aa]').forEach((el) => el.remove());

  // Improve styles for EPUB tables
  document.querySelectorAll('table').forEach((table) {
    table.attributes['style'] =
        '${table.attributes['style'] ?? ''} border-collapse: collapse; width: 100%; margin: 10px 0;';
  });

  document.querySelectorAll('td, th').forEach((cell) {
    cell.attributes['style'] =
        '${cell.attributes['style'] ?? ''} border: 1px solid #ddd; padding: 8px;';
  });

  // Improve citations/blockquotes
  document.querySelectorAll('blockquote').forEach((quote) {
    quote.attributes['style'] =
        '${quote.attributes['style'] ?? ''} border-left: 4px solid #ccc; padding-left: 15px; margin: 10px 0; font-style: italic;';
  });

  // Get cleaned HTML
  String htmlContent = document.body?.innerHtml ?? cleaned;

  // Decode HTML entities while keeping HTML tags
  htmlContent = _decodeHtmlEntities(htmlContent);

  return '''<div id="readerViewContent">$htmlContent</div>''';
}

String _decodeHtmlEntities(String html) {
  // Decode numeric HTML entities (&#8220;, &#8217;, etc.)
  String decoded = html.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
    final charCode = int.tryParse(match.group(1)!);
    return charCode != null ? String.fromCharCode(charCode) : match.group(0)!;
  });

  // Decode hexadecimal HTML entities (&#x2019;, etc.)
  decoded = decoded.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
    final charCode = int.tryParse(match.group(1)!, radix: 16);
    return charCode != null ? String.fromCharCode(charCode) : match.group(0)!;
  });

  // Decode common named HTML entities
  final entities = {
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&nbsp;': ' ',
    '&quot;': '"',
    '&apos;': "'",
    '&ldquo;': '"',
    '&rdquo;': '"',
    '&lsquo;': ''',
    '&rsquo;': ''',
    '&mdash;': '—',
    '&ndash;': '–',
    '&hellip;': '…',
  };

  entities.forEach((entity, replacement) {
    decoded = decoded.replaceAll(entity, replacement);
  });

  return decoded;
}
