import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/source_repositories.dart';

void main() {
  testWidgets('uses a neutral icon for GitHub repositories', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          extensionsRepoStateProvider(ItemType.anime)
              .overrideWith(_GitHubRepoState.new),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SourceRepositories(itemType: ItemType.anime),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Curated extensions'), findsOneWidget);
    expect(find.byKey(const Key('repository-icon')), findsOneWidget);
    expect(find.byIcon(Symbols.source_rounded), findsOneWidget);
  });

  testWidgets('says how many sources a repository offers', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          extensionsRepoStateProvider(ItemType.anime)
              .overrideWith(_GitHubRepoState.new),
          repoSourceCountsProvider(ItemType.anime)
              .overrideWith((ref) => Stream.value({_url: 12})),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SourceRepositories(itemType: ItemType.anime),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('12 sources · $_url'), findsOneWidget);
  });
}

const _url =
    'https://raw.githubusercontent.com/example/extensions/main/anime_index.json';

class _GitHubRepoState extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => [
    Repo(name: 'Curated extensions', jsonUrl: _url),
  ];
}
