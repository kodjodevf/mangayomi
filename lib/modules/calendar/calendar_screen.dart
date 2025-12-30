import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/calendar/providers/calendar_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final ItemType? itemType;
  const CalendarScreen({super.key, this.itemType});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final ValueNotifier<List<Manga>> _selectedEntries;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  final firstDay = DateTime.now();
  final lastDay = DateTime.now().add(const Duration(days: 1000));
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late ItemType? itemType;
  late List<ItemType> _visibleTypes;

  @override
  void initState() {
    super.initState();
    _visibleTypes = hiddenItemTypes(ref.read(hideItemsStateProvider));
    final initialItemType = widget.itemType ?? ItemType.manga;
    if (_visibleTypes.contains(initialItemType)) {
      itemType = initialItemType;
    } else {
      itemType = _visibleTypes.isNotEmpty ? _visibleTypes.first : null;
    }
    _selectedDay = _focusedDay;
    _selectedEntries = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEntries.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = ref.watch(l10nLocaleStateProvider);
    final data = ref.watch(getCalendarStreamProvider(itemType: itemType));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendar)),
      body: data.when(
        data: (data) {
          if (_selectedDay != null) {
            _selectedEntries.value = _getEntriesForDay(_selectedDay!, data);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildWarningTile(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: SegmentedButton(
                                emptySelectionAllowed: true,
                                showSelectedIcon: false,
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                segments: _visibleTypes.map((type) {
                                  return ButtonSegment(
                                    value: type.index,
                                    label: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(type.localized(l10n)),
                                    ),
                                  );
                                }).toList(),
                                selected: {itemType?.index},
                                onSelectionChanged: (newSelection) {
                                  if (newSelection.isNotEmpty &&
                                      newSelection.first != null) {
                                    setState(() {
                                      itemType =
                                          ItemType.values[newSelection.first!];
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCalendar(data, locale),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                ValueListenableBuilder<List<Manga>>(
                  valueListenable: _selectedEntries,
                  builder: (context, value, _) {
                    return CustomSliverGroupedListView<Manga, String>(
                      elements: value,
                      groupBy: (element) {
                        return dateFormat(
                          _selectedDay?.millisecondsSinceEpoch.toString() ??
                              DateTime.now()
                                  .add(Duration(days: element.smartUpdateDays!))
                                  .millisecondsSinceEpoch
                                  .toString(),
                          context: context,
                          ref: ref,
                          forHistoryValue: true,
                          useRelativeTimesTamps: false,
                        );
                      },
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 12),
                        child: Row(
                          children: [
                            Text(
                              "${dateFormat(null, context: context, stringDate: groupByValue, ref: ref, useRelativeTimesTamps: true, showInDaysFuture: true)} - ${dateFormat(null, context: context, stringDate: groupByValue, ref: ref, useRelativeTimesTamps: false)}",
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, element) {
                        return CalendarListTileWidget(
                          manga: element,
                          selectedDay: _selectedDay,
                        );
                      },
                      order: GroupedListOrder.ASC,
                    );
                  },
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 15)),
              ],
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(l10n.calendar_no_data, textAlign: TextAlign.center),
            ),
          );
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
    );
  }

  Widget _buildWarningTile(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: context.secondaryColor),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                context.l10n.calendar_info,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 13, color: context.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(List<Manga> data, Locale locale) {
    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: _focusedDay,
      locale: locale.toLanguageTag(),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: (day) => _getEntriesForDay(day, data),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendTextStyle: TextStyle(color: context.primaryColor),
      ),
      onDaySelected: (selectedDay, focusedDay) =>
          _onDaySelected(selectedDay, focusedDay, data),
      onRangeSelected: (start, end, focusedDay) =>
          _onRangeSelected(start, end, focusedDay, data),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() => _calendarFormat = format);
        }
      },
      onPageChanged: (focusedDay) => _focusedDay = focusedDay,
    );
  }

  final Map<String, List<Manga>> _dayCache = {};

  List<Manga> _getEntriesForDay(DateTime day, List<Manga> data) {
    final key = "${day.year}-${day.month}-${day.day}";
    if (_dayCache.containsKey(key)) return _dayCache[key]!;
    final result = data.where((e) {
      final lastChapter = e.chapters
          .filter()
          .sortByDateUploadDesc()
          .findFirstSync();
      final lastDate = int.tryParse(lastChapter?.dateUpload ?? "");
      final start = lastDate != null
          ? DateTime.fromMillisecondsSinceEpoch(lastDate)
          : DateTime.now();
      final temp = start.add(Duration(days: e.smartUpdateDays!));
      return temp.year == day.year &&
          temp.month == day.month &&
          temp.day == day.day;
    }).toList();
    _dayCache[key] = result;
    return result;
  }

  List<Manga> _getEntriesForRange(
    DateTime start,
    DateTime end,
    List<Manga> data,
  ) {
    final days = _daysInRange(start, end);

    return [for (final d in days) ..._getEntriesForDay(d, data)];
  }

  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
    List<Manga> data,
  ) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEntries.value = _getEntriesForDay(selectedDay, data);
    }
  }

  void _onRangeSelected(
    DateTime? start,
    DateTime? end,
    DateTime focusedDay,
    List<Manga> data,
  ) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEntries.value = _getEntriesForRange(start, end, data);
    } else if (start != null) {
      _selectedEntries.value = _getEntriesForDay(start, data);
    } else if (end != null) {
      _selectedEntries.value = _getEntriesForDay(end, data);
    }
  }

  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}

class CalendarListTileWidget extends ConsumerWidget {
  final Manga manga;
  final DateTime? selectedDay;
  const CalendarListTileWidget({
    required this.manga,
    required this.selectedDay,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () => context.push('/manga-reader/detail', extra: manga.id),
        onLongPress: () {},
        onSecondaryTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          child: Container(
            height: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Material(
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                '/manga-reader/detail',
                                extra: manga.id,
                              );
                            },
                            child: Ink.image(
                              fit: BoxFit.cover,
                              width: 40,
                              height: 45,
                              image: manga.customCoverImage != null
                                  ? MemoryImage(
                                          manga.customCoverImage as Uint8List,
                                        )
                                        as ImageProvider
                                  : CustomExtendedNetworkImageProvider(
                                      toImgUrl(
                                        manga.customCoverFromTracker ??
                                            manga.imageUrl!,
                                      ),
                                      headers: ref.watch(
                                        headersProvider(
                                          source: manga.source!,
                                          lang: manga.lang!,
                                          sourceId: manga.sourceId,
                                        ),
                                      ),
                                    ),
                              child: InkWell(child: Container()),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                ),
                              ),
                              Text(
                                context.l10n.n_chapters(
                                  manga.chapters.countSync(),
                                ),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: context.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
