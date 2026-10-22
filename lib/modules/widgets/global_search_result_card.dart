import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/in_library_badge.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

/// A search-result cover card: focusable/TV-navigable, watches the library
/// for a live favorite/custom-cover match against [manga], and calls
/// [onActivate] on tap or the TV select key.
///
/// Shared between the global search results grid and the migration source
/// picker, which used to hand-roll the identical focus/scale/StreamBuilder
/// shell twice and differed only in [padding]/[autofocus] and what
/// activating a card does.
class GlobalSearchResultCard extends ConsumerStatefulWidget {
  final MManga manga;
  final Source source;
  final EdgeInsetsGeometry padding;
  final bool autofocus;
  final VoidCallback onActivate;

  const GlobalSearchResultCard({
    super.key,
    required this.manga,
    required this.source,
    required this.padding,
    required this.onActivate,
    this.autofocus = false,
  });

  @override
  ConsumerState<GlobalSearchResultCard> createState() =>
      _GlobalSearchResultCardState();
}

class _GlobalSearchResultCardState extends ConsumerState<GlobalSearchResultCard>
    with AutomaticKeepAliveClientMixin<GlobalSearchResultCard> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final getMangaDetail = widget.manga;
    // A bare GestureDetector never takes focus, so on a remote these covers
    // were unreachable: the only focusable things on the screen were the source
    // headers, and the d-pad could never get down into the results. Focus also
    // scrolls the card into view, and ensureVisible walks every enclosing
    // scrollable, so it moves the horizontal strip and the source list both.
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
          widget.onActivate();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      // The padding sits outside the scale deliberately: it is the room the
      // focused cover grows into. Inside, it would scale along with the card
      // and buy nothing, which is why the block had to be stretched before.
      child: Padding(
        padding: widget.padding,
        child: AnimatedContainer(
          duration: ShioriMotion.fast,
          curve: Curves.easeOut,
          // Matches the library cover: accent ring plus a slight lift.
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ShioriShape.cover),
            border: Border.all(
              color: _focused
                  ? context.shiori.color.accentInk
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: widget.onActivate,
            child: StreamBuilder(
              stream: mangaRepository.watchByLangNameSource(
                widget.source.lang,
                getMangaDetail.name,
                widget.source.name,
              ),
              builder: (context, snapshot) {
                final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
                return Stack(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (hasData &&
                                  snapshot.data!.first.customCoverImage !=
                                      null) {
                                return Image.memory(
                                  snapshot.data!.first.customCoverImage
                                      as Uint8List,
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ShioriShape.cover,
                                ),
                                child: cachedNetworkImage(
                                  headers: ref.watch(
                                    headersProvider(
                                      source: widget.source.name!,
                                      lang: widget.source.lang!,
                                      sourceId: widget.source.id,
                                    ),
                                  ),
                                  imageUrl: toImgUrl(
                                    hasData
                                        ? snapshot
                                                  .data!
                                                  .first
                                                  .customCoverFromTracker ??
                                              snapshot.data!.first.imageUrl ??
                                              ""
                                        : getMangaDetail.imageUrl ?? "",
                                  ),
                                  width: 110,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          BottomTextWidget(
                            fontSize: context.shiori.text.meta.fontSize,
                            text: getMangaDetail.name!,
                            isLoading: true,
                            textColor: context.shiori.color.fg,
                            isComfortableGrid: true,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 150,
                      color: hasData && snapshot.data!.first.favorite!
                          ? inLibraryVeil
                          : null,
                    ),
                    if (hasData && snapshot.data!.first.favorite!)
                      const PositionedDirectional(
                        top: ShioriSpace.s4,
                        start: ShioriSpace.s4,
                        child: InLibraryBadge(),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
