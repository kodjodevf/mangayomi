import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  final bool isManga;
  const UpdatesScreen({required this.isManga, super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  Future<void> _updateLibrary() async {
    setState(() {
      _isLoading = true;
    });
    botToast(context.l10n.updating_library,
        fontSize: 13, second: 1600, alignY: !context.isTablet ? 0.85 : 1);
    final mangaList = isar.mangas
        .filter()
        .idIsNotNull()
        .favoriteEqualTo(true)
        .and()
        .isMangaEqualTo(widget.isManga)
        .findAllSync();
    int numbers = 0;

    for (var manga in mangaList) {
      try {
        await ref.read(
            updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
      } catch (_) {}
      numbers++;
    }
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mangaList.length == numbers) {
        return false;
      }
      return true;
    });
    BotToast.cleanAll();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  List<History> entriesData = [];
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
              onPressed: () => context
                  .go(widget.isManga ? '/browse/manga' : '/browse/anime')),
          title: _isSearch
              ? null
              : Text(
                  l10n.updates,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
          actions: [
            _isSearch
                ? SeachFormTextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSuffixPressed: () {
                      _textEditingController.clear();
                      setState(() {});
                    },
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                      _textEditingController.clear();
                    },
                    controller: _textEditingController,
                  )
                : IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      setState(() {
                        _isSearch = true;
                      });
                    },
                    icon: Icon(Icons.search_outlined,
                        color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  _updateLibrary();
                },
                icon: Icon(Icons.refresh_outlined,
                    color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            l10n.remove_everything,
                          ),
                          content: Text(l10n.remove_all_update_msg),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(l10n.cancel)),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      List<Update> updates = isar.updates
                                          .filter()
                                          .idIsNotNull()
                                          .chapter((q) => q.manga((q) =>
                                              q.isMangaEqualTo(widget.isManga)))
                                          .findAllSync()
                                          .toList();
                                      isar.writeTxnSync(() {
                                        for (var update in updates) {
                                          isar.updates.deleteSync(update.id!);
                                        }
                                      });
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(l10n.ok)),
                              ],
                            )
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete_sweep_outlined,
                    color: Theme.of(context).hintColor)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: UpdateTab(
              isManga: widget.isManga,
              textEditingController: _textEditingController,
              isLoading: _isLoading),
        ));
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final bool isManga;
  final TextEditingController textEditingController;
  final bool isLoading;
  const UpdateTab(
      {required this.isManga,
      required this.textEditingController,
      required this.isLoading,
      super.key});

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final update =
        ref.watch(getAllUpdateStreamProvider(isManga: widget.isManga));
    return Scaffold(
        body: Stack(
      children: [
        update.when(
          data: (data) {
            final entries = data
                .where((element) => widget.textEditingController.text.isNotEmpty
                    ? element.chapter.value!.manga.value!.name!
                        .toLowerCase()
                        .contains(
                            widget.textEditingController.text.toLowerCase())
                    : true)
                .toList();
            final lastUpdatedList = data
                .map((e) => e.chapter.value!.manga.value!.lastUpdate!)
                .toList();
            lastUpdatedList.sort((a, b) => a.compareTo(b));
            final lastUpdated = lastUpdatedList.firstOrNull;
            if (entries.isNotEmpty) {
              return CustomScrollView(
                slivers: [
                  if (lastUpdated != null)
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 20),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                        Text(
                            l10n.library_last_updated(dateFormat(
                                lastUpdated.toString(),
                                ref: ref,
                                context: context,
                                showHOURorMINUTE: true)),
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: context.secondaryColor))
                      ])),
                    ),
                  SliverGroupedListView<Update, String>(
                    elements: entries,
                    groupBy: (element) => dateFormat(element.date!,
                        context: context,
                        ref: ref,
                        forHistoryValue: true,
                        useRelativeTimesTamps: false),
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 12),
                      child: Row(
                        children: [
                          Text(dateFormat(
                            null,
                            context: context,
                            stringDate: groupByValue,
                            ref: ref,
                          )),
                        ],
                      ),
                    ),
                    itemBuilder: (context, element) {
                      final chapter = element.chapter.value!;
                      return UpdateChapterListTileWidget(
                          chapter: chapter, sourceExist: true);
                    },
                    itemComparator: (item1, item2) =>
                        item1.date!.compareTo(item2.date!),
                    order: GroupedListOrder.DESC,
                  ),
                ],
              );
            }
            return Center(
              child: Text(l10n.no_recent_updates),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorText(error);
          },
          loading: () {
            return const ProgressCenter();
          },
        ),
        if (widget.isLoading)
          const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: RefreshProgressIndicator(),
                ),
              )),
      ],
    ));
  }
}
