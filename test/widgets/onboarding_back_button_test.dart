import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/onboarding_screen.dart';

/// Mounted the way main.dart mounts it: from the builder of a routed app, so
/// there is a real Router and a real back button dispatcher above it. A plain
/// MaterialApp has neither, which is why the first attempt at this could not
/// tell a working guard from a decorative one.
void main() {
  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          for (final type in ItemType.values)
            extensionsRepoStateProvider(type)
                .overrideWith(() => _StubRepoState()),
          // Reads Isar, which is not open in a test.
          localFoldersStateProvider.overrideWith(_StubLocalFolders.new),
          hideItemsStateProvider.overrideWith(_StubHideItems.new),
          mergeLibraryNavMobileStateProvider.overrideWith(_StubMergeNav.new),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
            ],
          ),
          builder: (context, child) => const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> systemBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  testWidgets('goes back a step instead of popping the router underneath', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pumpAndSettle();
    expect(find.text('Your libraries'), findsOneWidget);

    await systemBack(tester);
    expect(find.text('Welcome to Mangayomi'), findsOneWidget);
  });

  testWidgets('does nothing on the first step, where Skip is the way out', (
    tester,
  ) async {
    await pump(tester);
    await systemBack(tester);
    // Still here, and the app has not been left from behind an unfinished
    // first run.
    expect(find.text('Welcome to Mangayomi'), findsOneWidget);
  });
}

class _StubRepoState extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => const [];

  @override
  void set(List<Repo> value) => state = value;
}

class _StubLocalFolders extends LocalFoldersState {
  @override
  List<LocalFolder> build() => const [];

  @override
  void set(List<LocalFolder> value) => state = value;
}

class _StubHideItems extends HideItemsState {
  @override
  List<String> build() => const ['/trackerLibrary'];

  @override
  void set(List<String> values) => state = values;
}

class _StubMergeNav extends MergeLibraryNavMobileState {
  @override
  bool build() => false;

  @override
  void set(bool value) => state = value;
}
