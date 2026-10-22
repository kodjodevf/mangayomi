import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart' as dom;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/utils/novel_paginator.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:shiori/shiori.dart';

Color parseNovelColor(String hex, {Color? fallback}) {
  try {
    String hexColor = hex.trim().replaceAll('#', '');
    if (hexColor.length == 6) {
      return Color(int.parse('FF$hexColor', radix: 16));
    } else if (hexColor.length == 8) {
      return Color(int.parse(hexColor, radix: 16));
    }
  } catch (_) {}
  // shiori: the book's own styles, set against whatever page colour the reader chose
  return fallback ?? Colors.grey;
}

TextAlign getNovelTextAlign(NovelTextAlign textAlign) {
  switch (textAlign) {
    case NovelTextAlign.left:
      return TextAlign.left;
    case NovelTextAlign.center:
      return TextAlign.center;
    case NovelTextAlign.right:
      return TextAlign.right;
    case NovelTextAlign.block:
      return TextAlign.justify;
  }
}

/// Renders styled HTML content for the novel reader, including EPUB embedded
/// images and TTS paragraph/word highlighting.
class NovelHtmlContent extends StatelessWidget {
  final String htmlData;
  final String? fontFamily;
  final int fontSize;
  final double lineHeight;
  final int padding;
  final TextAlign textAlign;
  final bool removeExtraSpacing;
  final Color textColor;
  final Color backgroundColor;
  final bool showTts;
  final ({int paragraph, int wordStart, int wordEnd}) tts;
  final EpubNovel? epubBook;

  const NovelHtmlContent({
    super.key,
    required this.htmlData,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.padding,
    required this.textAlign,
    required this.removeExtraSpacing,
    required this.textColor,
    required this.backgroundColor,
    required this.showTts,
    required this.tts,
    required this.epubBook,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        "body": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          color: textColor,
          backgroundColor: backgroundColor,
          margin: Margins.zero,
          padding: HtmlPaddings.all(padding.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "p": Style(
          fontFamily: fontFamily,
          margin: removeExtraSpacing
              ? Margins.only(bottom: 4)
              : Margins.only(bottom: 8),
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "div": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "span": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
        ),
        "h1, h2, h3, h4, h5, h6": Style(
          fontFamily: fontFamily,
          color: textColor,
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "a": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          color: Colors.blue,
          textDecoration: TextDecoration.underline,
        ),
        "img": Style(width: Width(100, Unit.percent), height: Height.auto()),
        "table": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: Border.all(color: Colors.grey, width: 1),
          margin: Margins.symmetric(vertical: 10),
        ),
        "td, th": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: Border.all(color: Colors.grey, width: 0.5),
          padding: HtmlPaddings.all(8),
        ),
        "th": Style(
          fontWeight: FontWeight.bold,
          // shiori: the book's own styles, set against whatever page colour the reader chose
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
        ),
        "blockquote": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: const Border(left: BorderSide(color: Colors.grey, width: 4)),
          padding: HtmlPaddings.only(left: 15),
          margin: Margins.symmetric(vertical: 10),
          fontStyle: FontStyle.italic,
        ),
        "pre, code": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          padding: HtmlPaddings.all(8),
          fontFamily: 'monospace',
        ),
        "hr": Style(margin: Margins.symmetric(vertical: 20)),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-active]": Style(
            backgroundColor: context.shiori.color.accentInk.withValues(
              alpha: 0.10,
            ),
            border: Border(
              left: BorderSide(color: context.shiori.color.accentInk, width: 3),
            ),
            padding: HtmlPaddings.only(left: 8),
          ),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-word]": Style(
            backgroundColor: context.shiori.color.accentInk.withValues(
              alpha: 0.35,
            ),
            textDecoration: TextDecoration.underline,
            textDecorationColor: context.shiori.color.accentInk,
          ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img", "source"},
          builder: (extensionContext) {
            final element = extensionContext.node as dom.Element;
            final customWidget = _buildCustomWidgets(context, element);
            if (customWidget != null) {
              return customWidget;
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          context.push("/mangawebview", extra: {'url': url, 'title': url});
        }
      },
    );
  }

  Widget? _buildCustomWidgets(BuildContext context, dom.Element element) {
    if (epubBook == null) return null;

    if (element.localName == "img" && element.getSrc != null) {
      final src = element.getSrc!;
      final fileName = src.split("/").last;
      final image = epubBook!.images
          .firstWhereOrNull(
            (img) =>
                img.name.endsWith(fileName) ||
                img.name.contains(fileName.replaceAll('%20', ' ')),
          )
          ?.content;

      if (image != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
          child: widgets.Image(
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(ShioriSpace.s8),
              color: context.shiori.color.error.background,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.broken_image_rounded,
                    color: context.shiori.color.error.foreground,
                  ),
                  const SizedBox(width: ShioriSpace.s8),
                  Flexible(
                    child: Text(
                      'Image not loaded: $fileName',
                      style: TextStyle(
                        color: context.shiori.color.error.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fit: BoxFit.contain,
            image: MemoryImage(image) as ImageProvider,
          ),
        );
      }
    }

    return null;
  }
}

/// Bottom strip showing scroll percentage or current page/spread label in the
/// novel reader when enabled.
class NovelScrollProgressBanner extends StatelessWidget {
  final Stream<double> rebuildStream;
  final bool isContinuous;
  final NovelPaginationResult? Function() cachedPagination;
  final PageMode effectivePageMode;
  final int Function() currentSpreadIndex;
  final double Function() offset;
  final double Function() maxOffset;

  const NovelScrollProgressBanner({
    super.key,
    required this.rebuildStream,
    required this.isContinuous,
    required this.cachedPagination,
    required this.effectivePageMode,
    required this.currentSpreadIndex,
    required this.offset,
    required this.maxOffset,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: rebuildStream,
      builder: (context, asyncSnapshot) {
        return Consumer(
          builder: (context, ref, child) {
            final customBackgroundColor = ref.watch(
              novelReaderThemeStateProvider,
            );
            final customTextColor = ref.watch(
              novelReaderTextColorStateProvider,
            );
            final pagination = cachedPagination();
            final String displayLabel;
            if (!isContinuous &&
                pagination != null &&
                pagination.pageCount > 0) {
              displayLabel = effectivePageMode == PageMode.doublePage
                  ? pagination.pageLabelForSpread(currentSpreadIndex())
                  : pagination.pageLabelForIndex(currentSpreadIndex());
            } else {
              final curMax = maxOffset();
              final scrollPercentage = curMax > 0
                  ? ((offset() / curMax) * 100).clamp(0, 100).toInt()
                  : 0;
              displayLabel = '$scrollPercentage %';
            }
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(
                      int.parse(
                        'FF${customBackgroundColor.replaceAll('#', '')}',
                        radix: 16,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(ShioriSpace.s4),
                        child: Text(
                          displayLabel,
                          style: TextStyle(
                            color: Color(
                              int.parse(
                                'FF${customTextColor.replaceAll('#', '')}',
                                radix: 16,
                              ),
                            ),
                            fontSize: context.shiori.text.row.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
