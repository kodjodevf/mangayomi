import 'dart:io';
import 'package:mangayomi/src/rust/api/epub.dart';
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
        if (chapter.url != null && chapter.url!.isNotEmpty) {
          // Load specific chapter by its spine idref
          final matches = book.chapters.where((c) => c.path == chapter.url);
          if (matches.isNotEmpty) {
            htmlContent = matches.first.content;
          } else {
            // Fallback: try via Rust direct access
            htmlContent = await getChapterContent(
              epubPath: chapter.archivePath!,
              chapterPath: chapter.url!,
            );
          }
        } else {
          // Legacy: no chapter url, concatenate all (old single-chapter imports)
          for (var subChapter in book.chapters) {
            htmlContent += "\n<hr/>\n${subChapter.content}";
          }
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

      // Locate the downloaded file by globbing for the single *.html in the
      // chapter directory rather than reconstructing its name. The downloader
      // sanitises forbidden characters to spaces while getMangaChapterDirectory
      // uses underscores, and the old lookup used the raw chapter.name, so any
      // title containing a colon (etc.) never matched: htmlFile.exists() was
      // always false and offline reading fell through to the network and hung.
      // A folder holds exactly one file, so a glob is correct regardless of
      // which sanitiser wrote it. See #817.
      File? localFile;
      if (chapterDirectory.existsSync()) {
        for (final entity in chapterDirectory.listSync()) {
          if (entity is File && entity.path.toLowerCase().endsWith('.html')) {
            localFile = entity;
            break;
          }
        }
      }

      if (localFile != null) {
        // Downloaded: render straight from disk, so it works fully offline with
        // no extension service or network. The file holds the raw getHtmlContent
        // output (quote-wrapped, like the network path); routing it back through
        // cleanHtmlContent renders a blank page, so strip the outer quotes and
        // hand it to _buildHtml directly.
        final raw = await localFile.readAsString();
        final stripped =
            raw.length >= 2 && raw.startsWith('"') && raw.endsWith('"')
            ? raw.substring(1, raw.length - 1)
            : raw;
        result = (_buildHtml(stripped), null);
      } else {
        // Not downloaded: fetch from the source (needs network).
        final source = getSource(
          chapter.manga.value!.lang!,
          chapter.manga.value!.source!,
          chapter.manga.value!.sourceId,
        );
        final proxyServer = ref.read(androidProxyServerStateProvider);
        final html = await withExtensionService(
          source!,
          proxyServer,
          (service) async => await service.getHtmlContent(
            chapter.manga.value!.name!,
            chapter.url!,
          ),
        );
        result = (_buildHtml(html.substring(1, html.length - 1)), null);
      }
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
