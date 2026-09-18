import 'dart:math' as math;

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// Result of novel pagination containing pages, spreads, and mapping utilities.
class NovelPaginationResult {
  final List<String> pages;
  final Map<int, int> blockToPageMap;
  final int totalBlocks;

  const NovelPaginationResult({
    required this.pages,
    required this.blockToPageMap,
    required this.totalBlocks,
  });

  int get pageCount => pages.length;
  int get spreadCount => (pageCount / 2).ceil();

  String leftPageForSpread(int spreadIndex) {
    final leftPageIndex = spreadIndex * 2;
    if (leftPageIndex < pageCount) {
      return pages[leftPageIndex];
    }
    return '';
  }

  String? rightPageForSpread(int spreadIndex) {
    final rightPageIndex = spreadIndex * 2 + 1;
    if (rightPageIndex < pageCount) {
      return pages[rightPageIndex];
    }
    return null;
  }

  String pageLabelForSpread(int spreadIndex) {
    if (pageCount == 0) return '0 / 0';
    final p1 = spreadIndex * 2 + 1;
    final p2 = p1 + 1;
    if (p2 <= pageCount) {
      return '$p1-$p2 / $pageCount';
    }
    return '$p1 / $pageCount';
  }

  int spreadForProgress(double progress) {
    if (spreadCount <= 1) return 0;
    final targetSpread = ((progress * pageCount) / 2).floor();
    return targetSpread.clamp(0, spreadCount - 1);
  }

  double progressForSpread(int spreadIndex) {
    if (pageCount <= 1) return 0.0;
    return ((spreadIndex * 2) / pageCount).clamp(0.0, 1.0);
  }

  int spreadForBlock(int blockIndex) {
    final page = blockToPageMap[blockIndex] ?? 0;
    return (page ~/ 2).clamp(0, math.max(0, spreadCount - 1));
  }
}

/// Paginates HTML novel content into discrete pages sized to fit viewport dimensions.
class NovelPaginator {
  const NovelPaginator._();

  static NovelPaginationResult paginate({
    required String htmlContent,
    required double pageWidth,
    required double pageHeight,
    required double fontSize,
    required double lineHeight,
    double padding = 16.0,
  }) {
    if (htmlContent.trim().isEmpty) {
      return const NovelPaginationResult(
        pages: [''],
        blockToPageMap: {},
        totalBlocks: 0,
      );
    }

    final safeWidth = math.max(150.0, pageWidth - (padding * 2));
    final safeHeight = math.max(200.0, pageHeight - (padding * 2));
    final effectiveLineHeight = math.max(12.0, fontSize * lineHeight);

    // Approximate characters per line for average proportional fonts (0.52 width factor)
    final charsPerLine = math.max(15, (safeWidth / (fontSize * 0.52)).floor());
    final maxLinesPerPage = math.max(
      5,
      (safeHeight / effectiveLineHeight).floor(),
    );
    final maxContentHeight = maxLinesPerPage * effectiveLineHeight;

    final document = html_parser.parse(htmlContent);
    final body = document.body;
    if (body == null) {
      return NovelPaginationResult(
        pages: [htmlContent],
        blockToPageMap: {},
        totalBlocks: 0,
      );
    }

    final container = body.querySelector('#readerViewContent') ?? body;
    final children = container.children.isNotEmpty
        ? container.children
        : [container];

    final pages = <String>[];
    final blockToPageMap = <int, int>{};
    var totalBlocks = 0;

    var currentPageNodes = <dom.Element>[];
    var currentPageHeight = 0.0;

    void flushCurrentPage() {
      if (currentPageNodes.isEmpty) return;
      final buffer = StringBuffer('<div id="readerViewContent">');
      for (final node in currentPageNodes) {
        buffer.write(node.outerHtml);
      }
      buffer.write('</div>');
      pages.add(buffer.toString());
      currentPageNodes = [];
      currentPageHeight = 0.0;
    }

    void recordBlockIndices(dom.Element element, int pageIndex) {
      final ttsIdxAttr = element.attributes['data-tts-index'];
      if (ttsIdxAttr != null) {
        final idx = int.tryParse(ttsIdxAttr);
        if (idx != null) {
          blockToPageMap[idx] = pageIndex;
          if (idx >= totalBlocks) {
            totalBlocks = idx + 1;
          }
        }
      }
      for (final child in element.querySelectorAll('[data-tts-index]')) {
        final idx = int.tryParse(child.attributes['data-tts-index'] ?? '');
        if (idx != null) {
          blockToPageMap[idx] = pageIndex;
          if (idx >= totalBlocks) {
            totalBlocks = idx + 1;
          }
        }
      }
    }

    double estimateElementHeight(dom.Element el) {
      final tagName = el.localName?.toLowerCase() ?? '';
      if (tagName == 'img' || el.querySelector('img') != null) {
        return 220.0;
      }
      if (tagName == 'table' || el.querySelector('table') != null) {
        return 180.0;
      }
      if (tagName == 'hr') {
        return 24.0;
      }

      final text = el.text.trim();
      if (text.isEmpty) {
        return 10.0;
      }

      final isHeading = tagName.startsWith('h') && tagName.length == 2;
      final headingScale = isHeading ? 1.4 : 1.0;
      final lineH = effectiveLineHeight * headingScale;
      final charsLine = isHeading
          ? math.max(10, (charsPerLine / headingScale).floor())
          : charsPerLine;

      final estimatedLines = math.max(1, (text.length / charsLine).ceil());
      final blockMargin = isHeading ? 18.0 : 10.0;
      return (estimatedLines * lineH) + blockMargin;
    }

    List<dom.Element> splitLargeElement(dom.Element element, double maxHeight) {
      final text = element.text;
      final estimatedHeight = estimateElementHeight(element);
      if (estimatedHeight <= maxHeight || text.length < 200) {
        return [element];
      }

      final sentences = RegExp(r'[^.!?]+[.!?]+|\s*[^.!?]+$')
          .allMatches(text)
          .map((m) => m.group(0) ?? '')
          .where((s) => s.trim().isNotEmpty)
          .toList();

      if (sentences.length <= 1) {
        return [element];
      }

      final result = <dom.Element>[];
      var currentChunk = StringBuffer();
      var currentChunkLength = 0;
      final maxChunkChars = (maxLinesPerPage * charsPerLine * 0.85).floor();

      for (final s in sentences) {
        if (currentChunkLength + s.length > maxChunkChars &&
            currentChunk.isNotEmpty) {
          final newEl = dom.Element.tag(element.localName ?? 'p');
          element.attributes.forEach((k, v) => newEl.attributes[k] = v);
          newEl.text = currentChunk.toString().trim();
          result.add(newEl);
          currentChunk = StringBuffer();
          currentChunkLength = 0;
        }
        currentChunk.write('$s ');
        currentChunkLength += s.length + 1;
      }

      if (currentChunk.isNotEmpty) {
        final newEl = dom.Element.tag(element.localName ?? 'p');
        element.attributes.forEach((k, v) => newEl.attributes[k] = v);
        newEl.text = currentChunk.toString().trim();
        result.add(newEl);
      }

      return result.isNotEmpty ? result : [element];
    }

    for (final child in children) {
      final chunks = splitLargeElement(child, maxContentHeight);
      for (final chunk in chunks) {
        final h = estimateElementHeight(chunk);
        if (currentPageHeight + h > maxContentHeight &&
            currentPageNodes.isNotEmpty) {
          flushCurrentPage();
        }
        currentPageNodes.add(chunk);
        currentPageHeight += h;
        recordBlockIndices(chunk, pages.length);
      }
    }

    flushCurrentPage();

    if (pages.isEmpty) {
      pages.add(htmlContent);
    }

    return NovelPaginationResult(
      pages: pages,
      blockToPageMap: blockToPageMap,
      totalBlocks: totalBlocks,
    );
  }
}
