// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_title.dart';
import 'package:mangayomi/modules/tracker_library/tracker_section_screen.dart';
import 'package:mangayomi/modules/tracker_library/tracker_sections_builder.dart';
import 'package:mangayomi/modules/tracker_library/tracker_switch_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/tracker_library_cache_repository.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:shiori/shiori.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

export 'package:mangayomi/models/track.dart' show TrackerProviders;

class TrackerLibraryScreen extends ConsumerStatefulWidget {
  final String? presetInput;
  const TrackerLibraryScreen({required this.presetInput, super.key});

  @override
  ConsumerState<TrackerLibraryScreen> createState() =>
      _TrackerLibraryScreenState();
}

class _TrackerLibraryScreenState extends ConsumerState<TrackerLibraryScreen> {
  late final _textEditingController = TextEditingController();
  late String _query = "";
  late bool _isSearch = false;
  List<TrackLibrarySection> _sections = [];
  List<TrackPreference> _preferences = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final lastLocation = ref.watch(lastTrackerLibraryLocationStateProvider);
    final trackerProvider =
        TrackerProviders.values.firstWhereOrNull(
          (t) => t.syncId == lastLocation.$1,
        ) ??
        TrackerProviders.myAnimeList;
    final itemType = lastLocation.$2 ? ItemType.manga : ItemType.anime;

    _sections = buildTrackerSections(
      ref: ref,
      trackerProvider: trackerProvider,
      itemType: itemType,
      searchQuery: _isSearch ? _query : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: TrackerLibraryTitle(
          text:
              (trackerProvider.syncId == TrackerProviders.simkl.syncId ||
                  trackerProvider.syncId == TrackerProviders.trakt.syncId)
              ? trackerProvider.name
              : "${trackerProvider.name} | ${itemType.localized(l10n)}",
          syncId: trackerProvider.syncId,
        ),
        leading: !_isSearch ? null : Container(),
        actions: [
          _isSearch
              ? SeachFormTextField(
                  onFieldSubmitted: (submit) {
                    setState(() {
                      if (submit.isNotEmpty) {
                        _query = submit;
                      }
                    });
                  },
                  onChanged: (value) {},
                  onSuffixPressed: () {
                    _query = "";
                    _textEditingController.clear();
                    setState(() {});
                  },
                  onPressed: () {
                    setState(() {
                      _isSearch = false;
                      _query = "";
                      _textEditingController.clear();
                    });
                  },
                  controller: _textEditingController,
                )
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                  },
                  icon: Icon(
                    Symbols.search_rounded,
                    fill: 1,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
          IconButton(
            tooltip: context.l10n.refresh,
            splashRadius: 20,
            onPressed: () async => await _resetData(trackerProvider, itemType),
            icon: Icon(
              Symbols.refresh_rounded,
              color: context.shiori.color.fgMuted,
            ),
          ),
          IconButton(
            tooltip: l10n.switch_tracker,
            splashRadius: 20,
            onPressed: () {
              showTrackerSwitchProviderDialog(
                context,
                ref,
                preferences: _preferences,
                l10n: l10n,
              );
            },
            icon: CircleAvatar(
              radius: 14,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ShioriShape.card),
                  color: trackInfos(trackerProvider.syncId).$3,
                ),
                width: 60,
                height: 70,
                child: Image.asset(
                  trackInfos(trackerProvider.syncId).$1,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s16,
          vertical: ShioriSpace.s4,
        ),
        child: StreamBuilder(
          stream: trackRepository.watchAllNotRefreshing(),
          builder: (context, snapshot) {
            _preferences = snapshot.hasData ? snapshot.data ?? [] : [];
            return _preferences.any((p) => p.syncId == trackerProvider.syncId)
                ? RefreshIndicator(
                    onRefresh: () async {
                      await _resetData(trackerProvider, itemType);
                    },
                    child: SuperListView.builder(
                      itemCount: _sections.length,
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      itemBuilder: (context, index) {
                        final section = _sections[index];
                        return SizedBox(
                          height: 260,
                          child: TrackerSectionScreen(
                            key: ValueKey(section.name),
                            section: section,
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(l10n.track_library_not_logged)],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Future<void> _resetData(
    TrackerProviders trackerProvider,
    ItemType itemType,
  ) async {
    final temp = Track(
      syncId: trackerProvider.syncId,
      status: TrackStatus.completed,
    );
    await ref
        .read(
          trackStateProvider(
            track: temp,
            itemType: null,
            widgetRef: ref,
          ).notifier,
        )
        .checkRefresh();
    await trackerLibraryCacheRepository.deleteByPrefix(
      "${trackerProvider.syncId}-${itemType.name}-",
    );
    setState(() {});
  }
}
