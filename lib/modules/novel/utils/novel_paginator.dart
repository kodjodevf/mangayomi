import 'dart:math' as math;

import 'package:flutter/widgets.dart';
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

  String spreadLabelForSpread(int spreadIndex) {
    if (pageCount == 0) return '0';
    final p1 = spreadIndex * 2 + 1;
    final p2 = p1 + 1;
    if (p2 <= pageCount) {
      return '$p1-$p2';
    }
    return '$p1';
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

  String pageForIndex(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < pageCount) {
      return pages[pageIndex];
    }
    return '';
  }

  String pageLabelForIndex(int pageIndex) {
    if (pageCount == 0) return '0 / 0';
    return '${pageIndex + 1} / $pageCount';
  }

  int pageForProgress(double progress) {
    if (pageCount <= 1) return 0;
    final targetPage = (progress * (pageCount - 1)).round();
    return targetPage.clamp(0, pageCount - 1);
  }

  double progressForPage(int pageIndex) {
    if (pageCount <= 1) return 0.0;
    return (pageIndex / (pageCount - 1)).clamp(0.0, 1.0);
  }

  int pageForBlock(int blockIndex) {
    final page = blockToPageMap[blockIndex] ?? 0;
    return page.clamp(0, math.max(0, pageCount - 1));
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
    String? fontFamily,
    bool removeExtraSpacing = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    if (htmlContent.trim().isEmpty) {
      return const NovelPaginationResult(
        pages: [''],
        blockToPageMap: {},
        totalBlocks: 0,
      );
    }

    final safeWidth = math.max(100.0, pageWidth - (padding * 2));
    final safeHeight = math.max(150.0, pageHeight - (padding * 2));
    final paragraphMargin = removeExtraSpacing ? 4.0 : 8.0;

    // Safety buffer to ensure that flutter_html never overflows the viewport by even a fraction of a pixel.
    final maxContentHeight = math.max(50.0, safeHeight - 8.0);

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

    // Collect block-level elements recursively unwrapping containers and preserving
    // bare text nodes and <br> line breaks commonly used in web novels.
    final List<dom.Element> blockElements = [];

    void processContainer(dom.Element element) {
      final nodes = element.nodes;
      var currentParagraphNodes = <dom.Node>[];

      void flushParagraph() {
        if (currentParagraphNodes.isEmpty) return;
        final combinedText =
            currentParagraphNodes.map((n) => n.text ?? '').join().trim();
        if (combinedText.isNotEmpty) {
          final p = dom.Element.tag('p');
          if (element.attributes.containsKey('data-tts-index')) {
            p.attributes['data-tts-index'] =
                element.attributes['data-tts-index']!;
          }
          for (final n in currentParagraphNodes) {
            p.append(n.clone(true));
          }
          blockElements.add(p);
        }
        currentParagraphNodes = [];
      }

      for (int i = 0; i < nodes.length; i++) {
        final node = nodes[i];
        if (node is dom.Element) {
          final tag = node.localName?.toLowerCase() ?? '';
          if (tag == 'br') {
            flushParagraph();
          } else if (tag == 'div') {
            flushParagraph();
            processContainer(node);
          } else if (tag == 'p' ||
              tag.startsWith('h') && tag.length == 2 ||
              tag == 'hr' ||
              tag == 'blockquote' ||
              tag == 'table' ||
              tag == 'img' ||
              tag == 'ul' ||
              tag == 'ol' ||
              tag == 'li') {
            flushParagraph();
            if (tag == 'p') {
              final hasBr = node.querySelectorAll('br').isNotEmpty;
              if (hasBr) {
                processContainer(node);
              } else {
                if (node.text.trim().isNotEmpty ||
                    node.querySelector('img') != null) {
                  blockElements.add(node);
                }
              }
            } else {
              blockElements.add(node);
            }
          } else {
            // Inline formatting tags (span, b, i, em, strong, a, etc.)
            currentParagraphNodes.add(node);
          }
        } else if (node is dom.Text) {
          final text = node.text;
          if (text.contains('\n')) {
            final lines = text.split('\n');
            for (int j = 0; j < lines.length; j++) {
              final line = lines[j].trim();
              if (line.isNotEmpty) {
                currentParagraphNodes.add(dom.Text(line));
              }
              if (j < lines.length - 1) {
                flushParagraph();
              }
            }
          } else {
            final trimmed = text.trim();
            if (trimmed.isNotEmpty) {
              currentParagraphNodes.add(dom.Text(trimmed));
            }
          }
        }
      }
      flushParagraph();
    }

    processContainer(container);
    if (blockElements.isEmpty) {
      if (container.children.isNotEmpty) {
        blockElements.addAll(container.children);
      } else {
        blockElements.add(container);
      }
    }

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

    double measureText(String text, {double scale = 1.0}) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) return 0.0;
      final painter = TextPainter(
        text: TextSpan(
          text: trimmed,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize * scale,
            height: lineHeight,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: textAlign,
      )..layout(maxWidth: safeWidth);
      final h = painter.size.height;
      painter.dispose();
      return h;
    }

    double estimateElementHeight(dom.Element el) {
      final tagName = el.localName?.toLowerCase() ?? '';
      if (tagName == 'img' || el.querySelector('img') != null) {
        return 220.0 + paragraphMargin;
      }
      if (tagName == 'table' || el.querySelector('table') != null) {
        return 180.0 + paragraphMargin;
      }
      if (tagName == 'hr') {
        return 16.0 + paragraphMargin;
      }

      final text = el.text.trim();
      if (text.isEmpty) {
        return 0.0;
      }

      final isHeading = tagName.startsWith('h') && tagName.length == 2;
      final headingScale = isHeading ? 1.4 : 1.0;
      final textH = measureText(text, scale: headingScale);
      final blockMargin = isHeading ? (paragraphMargin * 1.5) : paragraphMargin;
      return textH + blockMargin;
    }

    List<dom.Element> splitLargeElement(dom.Element element, double maxHeight) {
      final text = element.text.trim();
      final estimatedHeight = estimateElementHeight(element);
      if (estimatedHeight <= maxHeight) {
        return [element];
      }

      // Sentence boundaries: period, exclamation, question mark, ellipsis, newline
      final sentences = RegExp(r'[^.!?\n…]+[.!?\n…]*|\s*[^.!?\n…]+$')
          .allMatches(text)
          .map((m) => m.group(0)?.trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();

      if (sentences.isEmpty) {
        return [element];
      }

      final atomicUnits = <String>[];
      for (final s in sentences) {
        final sHeight = measureText(s) + paragraphMargin;
        if (sHeight > maxHeight) {
          final clauses = RegExp(r'[^,;:]+[,;:]*|\s*[^,;:]+$')
              .allMatches(s)
              .map((m) => m.group(0)?.trim() ?? '')
              .where((c) => c.isNotEmpty)
              .toList();
          if (clauses.length > 1) {
            atomicUnits.addAll(clauses);
          } else {
            final words = s.split(' ');
            if (words.length > 1) {
              atomicUnits.addAll(words);
            } else {
              for (int i = 0; i < s.length; i += 40) {
                atomicUnits.add(s.substring(i, math.min(i + 40, s.length)));
              }
            }
          }
        } else {
          atomicUnits.add(s);
        }
      }

      final result = <dom.Element>[];
      var currentChunk = StringBuffer();

      dom.Element createChunkElement(String chunkText) {
        final newEl = dom.Element.tag(element.localName ?? 'p');
        element.attributes.forEach((k, v) => newEl.attributes[k] = v);
        newEl.text = chunkText;
        return newEl;
      }

      for (final unit in atomicUnits) {
        final candidate = currentChunk.isEmpty
            ? unit
            : '${currentChunk.toString()} $unit';
        final candidateHeight = measureText(candidate) + paragraphMargin;

        if (currentChunk.isNotEmpty && candidateHeight > maxHeight) {
          result.add(createChunkElement(currentChunk.toString()));
          currentChunk = StringBuffer(unit);
        } else {
          if (currentChunk.isNotEmpty) currentChunk.write(' ');
          currentChunk.write(unit);
        }
      }

      if (currentChunk.isNotEmpty) {
        result.add(createChunkElement(currentChunk.toString()));
      }

      return result.isNotEmpty ? result : [element];
    }

    for (final child in blockElements) {
      final childHeight = estimateElementHeight(child);

      if (childHeight > maxContentHeight) {
        final chunks = splitLargeElement(child, maxContentHeight);
        for (final chunk in chunks) {
          final chunkHeight = estimateElementHeight(chunk);
          if (currentPageHeight + chunkHeight > maxContentHeight &&
              currentPageNodes.isNotEmpty) {
            flushCurrentPage();
          }
          currentPageNodes.add(chunk);
          currentPageHeight += chunkHeight;
          recordBlockIndices(chunk, pages.length);
        }
      } else {
        if (currentPageHeight + childHeight > maxContentHeight &&
            currentPageNodes.isNotEmpty) {
          flushCurrentPage();
        }
        currentPageNodes.add(child);
        currentPageHeight += childHeight;
        recordBlockIndices(child, pages.length);
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
