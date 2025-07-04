import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;
  const MangaDetailsView({
    super.key,
    required this.sourceExist,
    required this.manga,
    required this.checkForUpdate,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  Size measureText(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  double calculateDynamicButtonWidth(
    String text,
    TextStyle textStyle,
    double padding,
  ) {
    final textSize = measureText(text, textStyle);
    return textSize.width + padding;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    bool? isLocalArchive = widget.manga.isLocalArchive ?? false;
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final chaptersList = ref.watch(chaptersListttStateProvider);
          final isExtended = ref.watch(isExtendedStateProvider);
          return ref.watch(isLongPressedStateProvider) == true
              ? Container()
              : chaptersList.isNotEmpty &&
                    chaptersList
                        .where((element) => !element.isRead!)
                        .toList()
                        .isNotEmpty
              ? StreamBuilder(
                  stream: isar.historys
                      .filter()
                      .idIsNotNull()
                      .and()
                      .chapter(
                        (q) => q.manga(
                          (q) => q.itemTypeEqualTo(widget.manga.itemType),
                        ),
                      )
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    String buttonLabel = widget.manga.itemType != ItemType.anime
                        ? l10n.read
                        : l10n.watch;
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final incognitoMode = ref.watch(
                        incognitoModeStateProvider,
                      );
                      final entries = snapshot.data!
                          .where(
                            (element) => element.mangaId == widget.manga.id,
                          )
                          .toList()
                          .reversed
                          .toList();

                      if (entries.isNotEmpty && !incognitoMode) {
                        final chap = entries.first.chapter.value!;
                        return CustomFloatingActionBtn(
                          isExtended: !isExtended,
                          label: l10n.resume,
                          onPressed: () {
                            chap.pushToReaderView(context);
                          },
                          textWidth: measureText(
                            l10n.resume,
                            Theme.of(context).textTheme.labelLarge!,
                          ).width,
                          width: calculateDynamicButtonWidth(
                            l10n.resume,
                            Theme.of(context).textTheme.labelLarge!,
                            50,
                          ), // 50 Padding, else RenderFlex overflow Exception
                        );
                      }
                      return CustomFloatingActionBtn(
                        isExtended: !isExtended,
                        label: buttonLabel,
                        onPressed: () {
                          widget.manga.chapters
                              .toList()
                              .reversed
                              .toList()
                              .last
                              .pushToReaderView(context);
                        },
                        textWidth: measureText(
                          buttonLabel,
                          Theme.of(context).textTheme.labelLarge!,
                        ).width,
                        width: calculateDynamicButtonWidth(
                          buttonLabel,
                          Theme.of(context).textTheme.labelLarge!,
                          50,
                        ), // 50 Padding, else RenderFlex overflow Exception
                      );
                    }
                    return CustomFloatingActionBtn(
                      isExtended: !isExtended,
                      label: buttonLabel,
                      onPressed: () {
                        widget.manga.chapters
                            .toList()
                            .reversed
                            .toList()
                            .last
                            .pushToReaderView(context);
                      },
                      textWidth: measureText(
                        buttonLabel,
                        Theme.of(context).textTheme.labelLarge!,
                      ).width,
                      width: calculateDynamicButtonWidth(
                        buttonLabel,
                        Theme.of(context).textTheme.labelLarge!,
                        50,
                      ), // 50 Padding, else RenderFlex overflow Exception
                    );
                  },
                )
              : Container();
        },
      ),
      body: MangaDetailView(
        titleDescription: isLocalArchive
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.manga.author!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(getMangaStatusIcon(widget.manga.status), size: 14),
                      const SizedBox(width: 4),
                      Text(getMangaStatusName(widget.manga.status, context)),
                      const Text(' • '),
                      Text(widget.manga.source!),
                      Text(' (${widget.manga.lang!.toUpperCase()})'),
                      if (!widget.sourceExist)
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.warning_amber,
                            color: Colors.deepOrangeAccent,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
        action: widget.manga.favorite!
            ? SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                  ),
                  onPressed: () {
                    final model = widget.manga;
                    isar.writeTxnSync(() {
                      model.favorite = false;
                      model.dateAdded = 0;
                      model.updatedAt = DateTime.now().millisecondsSinceEpoch;
                      isar.mangas.putSync(model);
                    });
                  },
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        l10n.in_library,
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                ),
                onPressed: () {
                  final model = widget.manga;
                  final checkCategoryList = isar.categorys
                      .filter()
                      .idIsNotNull()
                      .and()
                      .forItemTypeEqualTo(model.itemType)
                      .isNotEmptySync();
                  if (checkCategoryList) {
                    showCategorySelectionDialog(
                      context: context,
                      ref: ref,
                      itemType: model.itemType,
                      singleManga: model,
                    );
                  } else {
                    isar.writeTxnSync(() {
                      model.favorite = true;
                      model.dateAdded = DateTime.now().millisecondsSinceEpoch;
                      model.updatedAt = DateTime.now().millisecondsSinceEpoch;
                      isar.mangas.putSync(model);
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 20,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.add_to_library,
                      style: TextStyle(
                        color: context.secondaryColor,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
        manga: widget.manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
        sourceExist: widget.sourceExist,
        checkForUpdate: widget.checkForUpdate,
        itemType: widget.manga.itemType,
      ),
    );
  }
}
