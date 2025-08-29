import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class TrackerWidget extends ConsumerStatefulWidget {
  final ItemType itemType;
  final Track trackRes;
  final int mangaId;
  final int syncId;
  final bool hide;
  const TrackerWidget({
    super.key,
    required this.itemType,
    required this.syncId,
    required this.trackRes,
    required this.mangaId,
    this.hide = false,
  });

  @override
  ConsumerState<TrackerWidget> createState() => _TrackerWidgetState();
}

class _TrackerWidgetState extends ConsumerState<TrackerWidget> {
  @override
  initState() {
    super.initState();
    _init();
  }

  _init() async {
    await Future.delayed(const Duration(microseconds: 100));
    final findManga = await ref
        .read(
          trackStateProvider(
            track: widget.trackRes,
            itemType: widget.itemType,
          ).notifier,
        )
        .findManga();
    if (mounted) {
      ref
          .read(tracksProvider(syncId: widget.syncId).notifier)
          .updateTrackManga(findManga!, widget.itemType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    final l10nLocale = ref.watch(l10nLocaleStateProvider);
    return Container(
      decoration: BoxDecoration(
        color: context.isLight
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (!widget.hide)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: trackInfos(widget.syncId).$3,
                    ),
                    width: 50,
                    height: 45,
                    child: Image.asset(
                      trackInfos(widget.syncId).$1,
                      height: 30,
                    ),
                  ),
                ),
              Expanded(
                child: _elevatedButton(
                  context,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  onPressed: !widget.hide
                      ? () async {
                          final trackSearch =
                              await trackersSearchraggableMenu(
                                    context,
                                    itemType: widget.itemType,
                                    track: widget.trackRes,
                                  )
                                  as TrackSearch?;
                          if (trackSearch != null) {
                            await ref
                                .read(
                                  trackStateProvider(
                                    track: null,
                                    itemType: widget.itemType,
                                  ).notifier,
                                )
                                .setTrackSearch(
                                  trackSearch,
                                  widget.mangaId,
                                  widget.syncId,
                                );
                          }
                        }
                      : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.trackRes.title!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(
                                tracksProvider(syncId: widget.syncId).notifier,
                              )
                              .deleteTrackManga(widget.trackRes);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _elevatedButton(
                  context,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(l10n!.status),
                          content: SizedBox(
                            width: context.width(0.8),
                            child: RadioGroup(
                              groupValue: toTrackStatus(
                                widget.trackRes.status,
                                widget.itemType,
                                widget.trackRes.syncId!,
                              ),
                              onChanged: (value) {
                                // Individual RadioListTile will handle the change
                              },
                              child: SuperListView.builder(
                                shrinkWrap: true,
                                itemCount: ref
                                    .read(
                                      trackStateProvider(
                                        track: widget.trackRes,
                                        itemType: widget.itemType,
                                      ).notifier,
                                    )
                                    .getStatusList()
                                    .length,
                                itemBuilder: (context, index) {
                                  final status = ref
                                      .read(
                                        trackStateProvider(
                                          track: widget.trackRes,
                                          itemType: widget.itemType,
                                        ).notifier,
                                      )
                                      .getStatusList()[index];
                                  return RadioListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: status,
                                    // ignore: deprecated_member_use
                                    onChanged: (value) {
                                      ref
                                          .read(
                                            trackStateProvider(
                                              track: widget.trackRes
                                                ..status = status,
                                              itemType: widget.itemType,
                                            ).notifier,
                                          )
                                          .updateManga();
                                      Navigator.pop(context);
                                    },
                                    title: Text(
                                      getTrackStatus(status, context),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: getTrackStatus(
                    toTrackStatus(
                      widget.trackRes.status,
                      widget.itemType,
                      widget.trackRes.syncId!,
                    ),
                    context,
                  ),
                ),
              ),
              Expanded(
                child: _elevatedButton(
                  context,
                  onPressed: () {
                    int currentIntValue = widget.trackRes.lastChapterRead!;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            widget.itemType == ItemType.manga
                                ? l10n!.chapters
                                : l10n!.episodes,
                          ),
                          content: StatefulBuilder(
                            builder: (context, setState) => SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NumberPicker(
                                    value: currentIntValue,
                                    minValue: 0,
                                    maxValue: widget.trackRes.totalChapter != 0
                                        ? widget.trackRes.totalChapter!
                                        : 10000,
                                    step: 1,
                                    haptics: true,
                                    onChanged: (value) =>
                                        setState(() => currentIntValue = value),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    ref
                                        .read(
                                          trackStateProvider(
                                            track: widget.trackRes
                                              ..lastChapterRead =
                                                  currentIntValue,
                                            itemType: widget.itemType,
                                          ).notifier,
                                        )
                                        .updateManga();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.ok,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: widget.trackRes.totalChapter != 0
                      ? "${widget.trackRes.lastChapterRead}/${widget.trackRes.totalChapter}"
                      : "${widget.trackRes.lastChapterRead == 0 ? l10n!.not_started : widget.trackRes.lastChapterRead}",
                ),
              ),
              Expanded(
                child: _elevatedButton(
                  context,
                  onPressed: () {
                    int currentIntValue = widget.trackRes.score!;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(l10n!.score),
                          content: StatefulBuilder(
                            builder: (context, setState) => SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NumberPicker(
                                    value: currentIntValue,
                                    minValue: 0,
                                    maxValue: ref
                                        .read(
                                          trackStateProvider(
                                            track: widget.trackRes,
                                            itemType: widget.itemType,
                                          ).notifier,
                                        )
                                        .getScoreMaxValue(),
                                    textMapper: (numberText) {
                                      return ref
                                          .read(
                                            trackStateProvider(
                                              track: widget.trackRes,
                                              itemType: widget.itemType,
                                            ).notifier,
                                          )
                                          .getTextMapper(numberText);
                                    },
                                    step: ref
                                        .read(
                                          trackStateProvider(
                                            track: widget.trackRes,
                                            itemType: widget.itemType,
                                          ).notifier,
                                        )
                                        .getScoreStep(),
                                    haptics: true,
                                    onChanged: (value) =>
                                        setState(() => currentIntValue = value),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    ref
                                        .read(
                                          trackStateProvider(
                                            track: widget.trackRes
                                              ..score = currentIntValue,
                                            itemType: widget.itemType,
                                          ).notifier,
                                        )
                                        .updateManga();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.ok,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: widget.trackRes.score != 0
                      ? ref
                            .read(
                              trackStateProvider(
                                track: widget.trackRes,
                                itemType: widget.itemType,
                              ).notifier,
                            )
                            .displayScore(widget.trackRes.score!)
                      : l10n!.score,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _elevatedButton(
                  context,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      helpText: l10n!.start_date,
                      locale: l10nLocale,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) return;
                    ref
                        .read(
                          trackStateProvider(
                            track: widget.trackRes
                              ..startedReadingDate =
                                  newDate.millisecondsSinceEpoch,
                            itemType: widget.itemType,
                          ).notifier,
                        )
                        .updateManga();
                  },
                  text:
                      widget.trackRes.startedReadingDate != null &&
                          widget.trackRes.startedReadingDate! >
                              DateTime.utc(1970).millisecondsSinceEpoch
                      ? dateFormat(
                          widget.trackRes.startedReadingDate.toString(),
                          ref: ref,
                          useRelativeTimesTamps: false,
                          context: context,
                        )
                      : l10n!.start_date,
                ),
              ),
              Expanded(
                child: _elevatedButton(
                  context,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      helpText: l10n!.finish_date,
                      locale: l10nLocale,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) return;
                    ref
                        .read(
                          trackStateProvider(
                            track: widget.trackRes
                              ..finishedReadingDate =
                                  newDate.millisecondsSinceEpoch,
                            itemType: widget.itemType,
                          ).notifier,
                        )
                        .updateManga();
                  },
                  text:
                      widget.trackRes.finishedReadingDate != null &&
                          widget.trackRes.finishedReadingDate! >
                              DateTime.utc(1970).millisecondsSinceEpoch
                      ? dateFormat(
                          widget.trackRes.finishedReadingDate.toString(),
                          ref: ref,
                          useRelativeTimesTamps: false,
                          context: context,
                        )
                      : l10n!.finish_date,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _elevatedButton(
  BuildContext context, {
  required Function()? onPressed,
  String text = "",
  Widget? child,
  BorderRadiusGeometry? borderRadius,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      backgroundColor: context.isLight
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.black,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0,
          color: context.secondaryColor.withValues(alpha: 0.1),
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(0),
      ),
    ),
    onPressed: onPressed,
    child:
        child ??
        Text(
          text,
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium!.color!.withValues(alpha: 0.9),
          ),
        ),
  );
}
