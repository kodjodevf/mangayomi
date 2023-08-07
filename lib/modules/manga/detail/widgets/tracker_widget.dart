import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';

class TrackerWidget extends ConsumerStatefulWidget {
  final bool isManga;
  final Track trackRes;
  final int mangaId;
  final TrackPreference trackPreference;
  const TrackerWidget(
      {super.key,
      required this.isManga,
      required this.trackPreference,
      required this.trackRes,
      required this.mangaId});

  @override
  ConsumerState<TrackerWidget> createState() => _TrackerWidgetState();
}

class _TrackerWidgetState extends ConsumerState<TrackerWidget> {
  @override
  initState() {
    _init();
    super.initState();
  }

  _init() async {
    await Future.delayed(const Duration(microseconds: 100));
    final findManga = await ref
        .read(
            trackStateProvider(track: widget.trackRes, isManga: widget.isManga)
                .notifier)
        .findManga();
    if (mounted) {
      ref
          .read(tracksProvider(syncId: widget.trackPreference.syncId!).notifier)
          .updateTrackManga(findManga!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    final l10nLocale = ref.watch(l10nLocaleStateProvider);
    return Container(
      decoration: BoxDecoration(
          color: isLight(context)
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.black,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: const Color.fromRGBO(18, 25, 35, 1),
                    width: 70,
                    child: Image.asset(
                      trackInfos(widget.trackPreference.syncId!).$1,
                      height: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _elevatedButton(
                  context,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20)),
                  onPressed: () async {
                    final trackSearch = await trackersSearchraggableMenu(
                        context,
                        isManga: widget.isManga,
                        track: widget.trackRes) as TrackSearch?;
                    if (trackSearch != null) {
                      await ref
                          .read(trackStateProvider(
                                  track: null, isManga: widget.isManga)
                              .notifier)
                          .setTrackSearch(trackSearch, widget.mangaId,
                              widget.trackPreference.syncId!);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.trackRes.title!,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(tracksProvider(
                                        syncId: widget.trackPreference.syncId!)
                                    .notifier)
                                .deleteTrackManga(widget.trackRes);
                          },
                          icon: const Icon(Icons.cancel_outlined))
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _elevatedButton(context, onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            l10n!.status,
                          ),
                          content: SizedBox(
                              width: mediaWidth(context, 0.8),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ref
                                    .read(trackStateProvider(
                                            track: widget.trackRes,
                                            isManga: widget.isManga)
                                        .notifier)
                                    .getStatusList()
                                    .length,
                                itemBuilder: (context, index) {
                                  final status = ref
                                      .read(trackStateProvider(
                                              track: widget.trackRes,
                                              isManga: widget.isManga)
                                          .notifier)
                                      .getStatusList()[index];
                                  return RadioListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: status,
                                    groupValue: toStatus(
                                        widget.trackRes.status,
                                        widget.isManga,
                                        widget.trackRes.syncId!),
                                    onChanged: (value) {
                                      ref
                                          .read(trackStateProvider(
                                                  track: widget.trackRes
                                                    ..status = status,
                                                  isManga: widget.isManga)
                                              .notifier)
                                          .updateManga();
                                      Navigator.pop(context);
                                    },
                                    title:
                                        Text(getTrackStatus(status, context)),
                                  );
                                },
                              )),
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
                                          color: primaryColor(context)),
                                    )),
                              ],
                            )
                          ],
                        );
                      });
                },
                    text: getTrackStatus(
                        toStatus(widget.trackRes.status, widget.isManga,
                            widget.trackRes.syncId!),
                        context)),
              ),
              Expanded(
                child: _elevatedButton(context, onPressed: () {
                  int currentIntValue = widget.trackRes.lastChapterRead!;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            widget.isManga ? l10n!.chapters : l10n!.episodes,
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
                                          color: primaryColor(context)),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      ref
                                          .read(trackStateProvider(
                                                  track: widget.trackRes
                                                    ..lastChapterRead =
                                                        currentIntValue,
                                                  isManga: widget.isManga)
                                              .notifier)
                                          .updateManga();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      l10n.ok,
                                      style: TextStyle(
                                          color: primaryColor(context)),
                                    )),
                              ],
                            )
                          ],
                        );
                      });
                },
                    text: widget.trackRes.totalChapter != 0
                        ? "${widget.trackRes.lastChapterRead}/${widget.trackRes.totalChapter}"
                        : "${widget.trackRes.lastChapterRead == 0 ? l10n!.not_started : widget.trackRes.lastChapterRead}"),
              ),
              Expanded(
                child: _elevatedButton(context, onPressed: () {
                  int currentIntValue = widget.trackRes.score!;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            l10n!.score,
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
                                    maxValue: ref
                                        .read(trackStateProvider(
                                                track: widget.trackRes,
                                                isManga: widget.isManga)
                                            .notifier)
                                        .getScoreMaxValue(),
                                    textMapper: (numberText) {
                                      return ref
                                          .read(trackStateProvider(
                                                  track: widget.trackRes,
                                                  isManga: widget.isManga)
                                              .notifier)
                                          .getTextMapper(numberText);
                                    },
                                    step: ref
                                        .read(trackStateProvider(
                                                track: widget.trackRes,
                                                isManga: widget.isManga)
                                            .notifier)
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
                                          color: primaryColor(context)),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      ref
                                          .read(trackStateProvider(
                                                  track: widget.trackRes
                                                    ..score = currentIntValue,
                                                  isManga: widget.isManga)
                                              .notifier)
                                          .updateManga();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      l10n.ok,
                                      style: TextStyle(
                                          color: primaryColor(context)),
                                    )),
                              ],
                            )
                          ],
                        );
                      });
                },
                    text: widget.trackRes.score != 0
                        ? ref
                            .read(trackStateProvider(
                                    track: widget.trackRes,
                                    isManga: widget.isManga)
                                .notifier)
                            .displayScore(widget.trackRes.score!)
                        : l10n!.score),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _elevatedButton(context,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20)), onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                      helpText: l10n!.start_date,
                      locale: l10nLocale,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (newDate == null) return;
                  ref
                      .read(trackStateProvider(
                              track: widget.trackRes
                                ..startedReadingDate =
                                    newDate.millisecondsSinceEpoch,
                              isManga: widget.isManga)
                          .notifier)
                      .updateManga();
                },
                    text: widget.trackRes.startedReadingDate != null &&
                            widget.trackRes.startedReadingDate! >
                                DateTime(1970).millisecondsSinceEpoch
                        ? dateFormat(
                            widget.trackRes.startedReadingDate.toString(),
                            ref: ref,
                            useRelativeTimesTamps: false,
                            context: context)
                        : l10n!.start_date),
              ),
              Expanded(
                child: _elevatedButton(context,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20)), onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                      helpText: l10n!.finish_date,
                      locale: l10nLocale,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (newDate == null) return;
                  ref
                      .read(trackStateProvider(
                              track: widget.trackRes
                                ..finishedReadingDate =
                                    newDate.millisecondsSinceEpoch,
                              isManga: widget.isManga)
                          .notifier)
                      .updateManga();
                },
                    text: widget.trackRes.finishedReadingDate != null &&
                            widget.trackRes.finishedReadingDate! >
                                DateTime(1970).millisecondsSinceEpoch
                        ? dateFormat(
                            widget.trackRes.finishedReadingDate.toString(),
                            ref: ref,
                            useRelativeTimesTamps: false,
                            context: context)
                        : l10n!.finish_date),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget _elevatedButton(BuildContext context,
    {required VoidCallback onPressed,
    String text = "",
    Widget? child,
    BorderRadiusGeometry? borderRadius}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: isLight(context)
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0, color: secondaryColor(context).withOpacity(0.1)),
              borderRadius: borderRadius ?? BorderRadius.circular(0))),
      onPressed: onPressed,
      child: child ??
          Text(
            text,
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.9)),
          ));
}
