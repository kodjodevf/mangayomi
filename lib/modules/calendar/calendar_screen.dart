import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/calendar/models/upcoming_ui_model.dart';
import 'package:mangayomi/modules/calendar/providers/calendar_provider.dart';
import 'package:mangayomi/modules/calendar/widgets/upcoming_calendar.dart';
import 'package:mangayomi/modules/calendar/widgets/upcoming_item.dart'
    as widgets;
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/fetch_interval.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final ItemType? itemType;
  const CalendarScreen({super.key, this.itemType});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late ItemType? itemType;
  late List<ItemType> _visibleTypes;

  /// Currently displayed year/month on the calendar.
  late DateTime _selectedYearMonth;

  /// Header GlobalKeys so clicking a calendar day scrolls to that date.
  final Map<DateTime, GlobalKey> _headerKeys = {};

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
    final now = DateTime.now();
    _selectedYearMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = ref.watch(getCalendarStreamProvider(itemType: itemType));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n.calendar_info,
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: Text(l10n.calendar_info),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: data.when(
        data: (mangaList) {
          final upcomingData = _buildUpcomingData(mangaList);
          final items = upcomingData.items;
          final events = upcomingData.events;

          // Build header keys
          _headerKeys.clear();
          for (final date in upcomingData.headerIndexes.keys) {
            _headerKeys[date] = GlobalKey();
          }

          return _buildContent(items, events);
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(l10n.calendar_no_data, textAlign: TextAlign.center),
            ),
          );
        },
        loading: () => const ProgressCenter(),
      ),
    );
  }

  Widget _buildContent(List<UpcomingUIModel> items, Map<DateTime, int> events) {
    final l10n = context.l10n;

    return CustomScrollView(
      slivers: [
        // Item type selector
        if (_visibleTypes.length > 1)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  if (newSelection.isNotEmpty && newSelection.first != null) {
                    setState(() {
                      itemType = ItemType.values[newSelection.first!];
                    });
                  }
                },
              ),
            ),
          ),

        SliverToBoxAdapter(
          child: UpcomingCalendar(
            selectedYearMonth: _selectedYearMonth,
            events: events,
            setSelectedYearMonth: (yearMonth) {
              setState(() {
                _selectedYearMonth = yearMonth;
              });
            },
            onClickDay: (date) => _scrollToDate(date),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // All upcoming items (date headers + manga tiles)
        if (items.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  l10n.calendar_no_data,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              return switch (item) {
                UpcomingHeader(:final date, :final mangaCount) => _DateHeading(
                  key: _headerKeys[date],
                  date: date,
                  mangaCount: mangaCount,
                ),
                UpcomingItem(:final manga) => widgets.UpcomingItem(
                  manga: manga,
                  onTap: () =>
                      context.push('/manga-reader/detail', extra: manga.id),
                ),
              };
            }, childCount: items.length),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  /// Scrolls to the header for [date] using Scrollable.ensureVisible.
  void _scrollToDate(DateTime date) {
    final key = _headerKeys[date];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Builds the upcoming UI model list, events map, and header indexes
  /// from the raw manga list.
  _UpcomingData _buildUpcomingData(List<Manga> mangaList) {
    // 1. Compute expected next update date for each manga
    final List<({Manga manga, DateTime expectedDate})> mangaWithDates = [];
    for (final manga in mangaList) {
      final expectedDate = _computeExpectedDate(manga);
      if (expectedDate != null) {
        mangaWithDates.add((manga: manga, expectedDate: expectedDate));
      }
    }

    // 2. Sort by date ascending
    mangaWithDates.sort((a, b) => a.expectedDate.compareTo(b.expectedDate));

    // 3. Group by date and build UI models with headers
    final List<UpcomingUIModel> items = [];
    final Map<DateTime, int> events = {};
    final Map<DateTime, int> headerIndexes = {};

    DateTime? lastDate;
    int countForGroup = 0;
    int headerIndex = -1;

    for (final entry in mangaWithDates) {
      final date = DateTime(
        entry.expectedDate.year,
        entry.expectedDate.month,
        entry.expectedDate.day,
      );

      if (lastDate == null || date != lastDate) {
        // Finalize count for previous group
        if (headerIndex >= 0) {
          final prevHeader = items[headerIndex] as UpcomingHeader;
          items[headerIndex] = UpcomingHeader(
            date: prevHeader.date,
            mangaCount: countForGroup,
          );
          events[prevHeader.date] = countForGroup;
        }

        // Start new group
        headerIndex = items.length;
        headerIndexes[date] = headerIndex;
        items.add(UpcomingHeader(date: date, mangaCount: 0));
        countForGroup = 0;
        lastDate = date;
      }

      items.add(UpcomingItem(manga: entry.manga, expectedDate: date));
      countForGroup++;
    }

    // Finalize last group
    if (headerIndex >= 0 && headerIndex < items.length) {
      final lastHeader = items[headerIndex] as UpcomingHeader;
      items[headerIndex] = UpcomingHeader(
        date: lastHeader.date,
        mangaCount: countForGroup,
      );
      events[lastHeader.date] = countForGroup;
    }

    return _UpcomingData(
      items: items,
      events: events,
      headerIndexes: headerIndexes,
    );
  }

  /// Computes the expected next update date for a mang
  DateTime? _computeExpectedDate(Manga manga) {
    if (manga.smartUpdateDays == null || manga.smartUpdateDays! <= 0) {
      return null;
    }
    final lastChapter = manga.chapters
        .filter()
        .sortByDateUploadDesc()
        .findFirstSync();
    final lastChapterMs = int.tryParse(lastChapter?.dateUpload ?? '');
    return FetchInterval.computeExpectedDate(
      lastChapterDateMs: lastChapterMs,
      lastUpdateMs: manga.lastUpdate,
      interval: manga.smartUpdateDays,
    );
  }
}

/// Internal data class for computed upcoming state.
class _UpcomingData {
  final List<UpcomingUIModel> items;
  final Map<DateTime, int> events;
  final Map<DateTime, int> headerIndexes;

  const _UpcomingData({
    required this.items,
    required this.events,
    required this.headerIndexes,
  });
}

/// Date heading with relative date text + count badge.
class _DateHeading extends ConsumerWidget {
  final DateTime date;
  final int mangaCount;

  const _DateHeading({super.key, required this.date, required this.mangaCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            dateFormat(
              date.millisecondsSinceEpoch.toString(),
              context: context,
              ref: ref,
              useRelativeTimesTamps: true,
              showInDaysFuture: true,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Badge(
            backgroundColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onPrimary,
            label: Text('$mangaCount'),
          ),
        ],
      ),
    );
  }
}
