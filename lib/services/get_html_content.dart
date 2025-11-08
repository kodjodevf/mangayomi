import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_html_content.g.dart';

@riverpod
Future<(String, EpubBook?)> getHtmlContent(
  Ref ref, {
  required Chapter chapter,
}) async {
  final keepAlive = ref.keepAlive();
  (String, EpubBook?) result;
  try {
    if (!chapter.manga.isLoaded) {
      chapter.manga.loadSync();
    }
    if (chapter.archivePath != null && chapter.archivePath!.isNotEmpty) {
      final htmlFile = File(chapter.archivePath!);
      if (await htmlFile.exists()) {
        final bytes = await htmlFile.readAsBytes();
        final book = await EpubReader.readBook(bytes);
        final tempChapter = book.Chapters?.where(
          (element) => element.Title!.isNotEmpty
              ? element.Title == chapter.name
              : "Book" == chapter.name,
        ).firstOrNull;
        result = (_buildHtml(tempChapter?.HtmlContent ?? "No content"), book);
      }
      result = (_buildHtml("Local epub file not found!"), null);
    }
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
    String? html;
    final proxyServer = ref.read(androidProxyServerStateProvider);
    if (htmlContent != null) {
      html = await getExtensionService(
        source!,
        proxyServer,
      ).cleanHtmlContent(htmlContent);
    } else {
      html = await getExtensionService(
        source!,
        proxyServer,
      ).getHtmlContent(chapter.manga.value!.name!, chapter.url!);
    }
    result = (_buildHtml(html.substring(1, html.length - 1)), null);
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

  // Remove unwanted elements
  document.querySelectorAll('iframe').forEach((el) => el.remove());
  document.querySelectorAll('script').forEach((el) => el.remove());
  document.querySelectorAll('[data-aa]').forEach((el) => el.remove());

  // Get cleaned HTML
  String htmlContent = document.body?.innerHtml ?? cleaned;

  // Decode HTML entities while keeping HTML tags
  htmlContent = _decodeHtmlEntities(htmlContent);

  return '''<div id="readerViewContent"><div style="padding: 2em;">$htmlContent</div></div>''';
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
