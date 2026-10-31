import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/tracker_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:numberpicker/numberpicker.dart';

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

  Future<void> _init() async {
    // Yield to microtask queue so initState completes before async work
    await Future(() {});
    final findManga = await ref
        .read(
          trackStateProvider(
            track: widget.trackRes,
            itemType: widget.itemType,
            widgetRef: ref,
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
    final track = trackStateProvider(
      track: widget.trackRes,
      itemType: widget.itemType,
      widgetRef: ref,
    );
    return Container(
      decoration: BoxDecoration(
        color: context.shiori.color.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.sheet),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (!widget.hide)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ShioriSpace.s12,
                    vertical: ShioriSpace.s4,
                  ),
                  child: TrackerLogo(syncId: widget.syncId),
                ),
              Expanded(
                child: _elevatedButton(
                  context,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(ShioriShape.sheet),
                    topLeft: Radius.circular(ShioriShape.sheet),
                  ),
                  // The local tracker's entry is the series itself: there
                  // is no other match to pick.
                  onPressed:
                      !widget.hide &&
                          widget.syncId != TrackerProviders.local.syncId
                      ? () async {
                          final trackSearch = await trackersSearchDraggableMenu(
                            context,
                            itemType: widget.itemType,
                            track: widget.trackRes,
                          );
                          if (trackSearch != null) {
                            await ref
                                .read(
                                  trackStateProvider(
                                    track: null,
                                    itemType: widget.itemType,
                                    widgetRef: ref,
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
                          padding: const EdgeInsets.all(ShioriSpace.s8),
                          child: Text(
                            widget.trackRes.title!,
                            overflow: TextOverflow.ellipsis,
                            style: context.shiori.text.body.copyWith(
                              color: context.shiori.color.fg,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(context)
                            .closeButtonTooltip,
                        onPressed: () {
                          ref
                              .read(
                                tracksProvider(syncId: widget.syncId).notifier,
                              )
                              .deleteTrackManga(widget.trackRes);
                        },
                        icon: const Icon(Symbols.cancel_rounded),
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
                  onPressed: () async {
                    final status = await showShioriChoice<TrackStatus>(
                      context,
                      title: l10n!.status,
                      selected: toTrackStatus(
                        widget.trackRes.status,
                        widget.itemType,
                        widget.trackRes.syncId!,
                      ),
                      options: [
                        for (final status
                            in ref.read(track.notifier).getStatusList())
                          ShioriChoice(status, getTrackStatus(status, context)),
                      ],
                    );
                    if (status == null) return;
                    ref
                        .read(
                          trackStateProvider(
                            track: widget.trackRes..status = status,
                            itemType: widget.itemType,
                            widgetRef: ref,
                          ).notifier,
                        )
                        .updateManga();
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
                  onPressed: () async {
                    int currentIntValue = widget.trackRes.lastChapterRead!;
                    // A wheel, not a list: the count runs to the thousands.
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => ShioriDialog(
                        title: widget.itemType == ItemType.manga
                            ? l10n!.chapters
                            : l10n!.episodes,
                        content: StatefulBuilder(
                          builder: (context, setState) => NumberPicker(
                            value: currentIntValue,
                            minValue: 0,
                            maxValue: widget.trackRes.totalChapter != 0
                                ? widget.trackRes.totalChapter!
                                : 10000,
                            step: 1,
                            haptics: true,
                            selectedTextStyle: context.shiori.text.seriesTitle
                                .copyWith(
                                  color: context.shiori.color.accentInk,
                                ),
                            onChanged: (value) =>
                                setState(() => currentIntValue = value),
                          ),
                        ),
                        actions: dialogCancelConfirmActions(
                          dialogContext: dialogContext,
                          confirmLabel: l10n.ok,
                        ),
                      ),
                    );
                    if (confirmed != true) return;
                    ref
                        .read(
                          trackStateProvider(
                            track: widget.trackRes
                              ..lastChapterRead = currentIntValue,
                            itemType: widget.itemType,
                            widgetRef: ref,
                          ).notifier,
                        )
                        .updateManga();
                  },
                  text: widget.trackRes.totalChapter != 0
                      ? "${widget.trackRes.lastChapterRead}/${widget.trackRes.totalChapter}"
                      : "${widget.trackRes.lastChapterRead == 0 ? l10n!.not_started : widget.trackRes.lastChapterRead}",
                ),
              ),
              Expanded(
                child: _elevatedButton(
                  context,
                  onPressed: () async {
                    final notifier = ref.read(track.notifier);
                    final step = notifier.getScoreStep();
                    final score = await showShioriChoice<int>(
                      context,
                      title: l10n!.score,
                      selected: widget.trackRes.score,
                      options: [
                        for (
                          var v = 0;
                          v <= notifier.getScoreMaxValue();
                          v += step
                        )
                          ShioriChoice(v, notifier.getTextMapper('$v')),
                      ],
                    );
                    if (score == null) return;
                    ref
                        .read(
                          trackStateProvider(
                            track: widget.trackRes..score = score,
                            itemType: widget.itemType,
                            widgetRef: ref,
                          ).notifier,
                        )
                        .updateManga();
                  },
                  text: widget.trackRes.score != 0
                      ? ref
                            .read(
                              trackStateProvider(
                                track: widget.trackRes,
                                itemType: widget.itemType,
                                widgetRef: ref,
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
                    bottomLeft: Radius.circular(ShioriShape.sheet),
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
                            widgetRef: ref,
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
                    bottomRight: Radius.circular(ShioriShape.sheet),
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
                            widgetRef: ref,
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

/// One cell of the tracking card: a value to tap and change.
Widget _elevatedButton(
  BuildContext context, {
  required Function()? onPressed,
  String text = "",
  Widget? child,
  BorderRadiusGeometry? borderRadius,
}) {
  final tokens = context.shiori;
  return Material(
    type: MaterialType.transparency,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: tokens.color.hairline, width: 0.5),
      borderRadius: borderRadius ?? BorderRadius.zero,
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: tokens.density.minTarget),
        child: Center(
          child:
              child ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.row.copyWith(color: tokens.color.fg),
                ),
              ),
        ),
      ),
    ),
  );
}
