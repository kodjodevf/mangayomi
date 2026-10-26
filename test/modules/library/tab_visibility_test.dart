import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/base_library_tab_screen.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';

List<String> _hidden = [];

/// Keeps the hidden types in memory: the real notifier writes to Isar.
class _FakeHideItems extends HideItemsState {
  @override
  List<String> build() => _hidden;

  @override
  void set(List<String> values) {
    state = values;
  }
}

class _FakeAnimeOnlyTvMode extends AnimeOnlyTvMode {
  @override
  bool build() => false;
}

class _TabsHost extends ConsumerStatefulWidget {
  const _TabsHost();

  @override
  ConsumerState<_TabsHost> createState() => _TabsHostState();
}

class _TabsHostState extends BaseLibraryTabScreenState<_TabsHost> {
  @override
  String get title => 'Tabs';

  @override
  Widget buildTab(ItemType type) => Text('content-${type.name}');
}

void main() {
  Future<_TabsHostState> pump(WidgetTester tester, List<String> hidden) async {
    _hidden = hidden;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hideItemsStateProvider.overrideWith(_FakeHideItems.new),
          animeOnlyTvModeProvider.overrideWith(_FakeAnimeOnlyTvMode.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const _TabsHost(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state<_TabsHostState>(find.byType(_TabsHost));
  }

  void setHidden(WidgetTester tester, List<String> hidden) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(_TabsHost)),
    );
    container.read(hideItemsStateProvider.notifier).set(hidden);
  }

  testWidgets('shows every type when none is hidden', (tester) async {
    final state = await pump(tester, []);

    expect(state.visibleTabTypes, [
      ItemType.manga,
      ItemType.anime,
      ItemType.novel,
    ]);
    expect(state.tabController.length, 3);
  });

  testWidgets('drops a type hidden while the screen is open', (tester) async {
    final state = await pump(tester, []);

    setHidden(tester, ['/MangaLibrary']);
    await tester.pumpAndSettle();

    expect(state.visibleTabTypes, [ItemType.anime, ItemType.novel]);
    expect(state.tabController.length, 2);
    expect(find.text('content-manga'), findsNothing);
  });

  testWidgets('brings a hidden type back when it is shown again', (
    tester,
  ) async {
    final state = await pump(tester, ['/NovelLibrary']);
    expect(state.visibleTabTypes, [ItemType.manga, ItemType.anime]);

    setHidden(tester, []);
    await tester.pumpAndSettle();

    expect(state.visibleTabTypes, [
      ItemType.manga,
      ItemType.anime,
      ItemType.novel,
    ]);
    expect(state.tabController.length, 3);
  });

  testWidgets('keeps the selected tab when it stays visible', (tester) async {
    final state = await pump(tester, []);
    state.tabController.index = 1; // anime
    await tester.pumpAndSettle();

    setHidden(tester, ['/MangaLibrary']);
    await tester.pumpAndSettle();

    expect(state.visibleTabTypes[state.tabController.index], ItemType.anime);
  });

  testWidgets('falls back to the first tab when the selected one is hidden', (
    tester,
  ) async {
    final state = await pump(tester, []);
    state.tabController.index = 1; // anime

    setHidden(tester, ['/AnimeLibrary']);
    await tester.pumpAndSettle();

    expect(state.visibleTabTypes, [ItemType.manga, ItemType.novel]);
    expect(state.tabController.index, 0);
  });
}
