import 'dart:io';

import 'package:epubx/epubx.dart';
import 'package:html/parser.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_html_content.g.dart';

@riverpod
Future<(String, EpubBook?)> getHtmlContent(
  Ref ref, {
  required Chapter chapter,
}) async {
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
      return (_buildHtml(tempChapter?.HtmlContent ?? "No content"), book);
    }
    return (_buildHtml("Local epub file not found!"), null);
  }
  final storageProvider = StorageProvider();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(chapter);
  final htmlPath = "${mangaDirectory!.path}${chapter.name}.html";
  final htmlFile = File(htmlPath);
  String? htmlContent;
  if (await htmlFile.exists()) {
    htmlContent = await htmlFile.readAsString();
    final temp = parse(htmlContent);
    temp.getElementsByTagName("script").forEach((el) => el.remove());
    htmlContent = temp.outerHtml;
  }
  final source = getSource(
    chapter.manga.value!.lang!,
    chapter.manga.value!.source!,
  );
  String? html;
  if (htmlContent != null) {
    html = await getExtensionService(source!).cleanHtmlContent(htmlContent);
  } else {
    html = await getExtensionService(
      source!,
    ).getHtmlContent(chapter.manga.value!.name!, chapter.url!);
  }
  return (_buildHtml(html.substring(1, html.length - 1)), null);
}

String _buildHtml(String input) {
  return '''<div id="readerViewContent"><div style="padding: 2em;">$input</div></div>'''
      .replaceAll("\\n", "")
      .replaceAll("\\t", "")
      .replaceAll("\\\"", "\"");
}
