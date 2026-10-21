import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/settings_index.dart';
import 'package:shiori/shiori.dart';

/// [text] folded for matching: lower case, accents dropped, so "theme"
/// finds "Thème" and "ecran" finds "écran".
String foldForSearch(String text) {
  const from = 'àâäáãåçéèêëíìîïñóòôöõúùûüýÿœæ';
  const to = 'aaaaaaceeeeiiiinooooouuuuyyoa';
  final lower = text.toLowerCase();
  final out = StringBuffer();
  for (final ch in lower.split('')) {
    final i = from.indexOf(ch);
    out.write(i < 0 ? ch : to[i]);
  }
  return out.toString();
}

/// The entries of [index] matching [query]: every word of the query must
/// appear in the title, the subtitle or the screen. Titles that match come
/// before entries that only match on their description.
List<SettingsEntry> searchSettings(
  String query,
  AppLocalizations l10n, {
  List<SettingsEntry>? index,
}) {
  final words = foldForSearch(query)
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return const [];
  final titleHits = <SettingsEntry>[];
  final otherHits = <SettingsEntry>[];
  for (final entry in index ?? settingsIndex) {
    final title = foldForSearch(entry.title(l10n));
    final haystack = [
      title,
      foldForSearch(entry.subtitle?.call(l10n) ?? ''),
      foldForSearch(entry.section(l10n)),
    ].join(' ');
    if (!words.every(haystack.contains)) continue;
    (words.every(title.contains) ? titleHits : otherHits).add(entry);
  }
  return [...titleHits, ...otherHits];
}

/// Search across every settings screen, from the top of Settings.
class SettingsSearchDelegate extends SearchDelegate<void> {
  SettingsSearchDelegate(this.l10n)
    : super(searchFieldLabel: l10n.search_settings);

  final AppLocalizations l10n;

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
        onPressed: () => query = '',
        icon: const Icon(Symbols.close_rounded),
      ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    onPressed: () => close(context, null),
    icon: const Icon(Symbols.arrow_back_rounded),
  );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    if (query.trim().isEmpty) {
      return ShioriEmptyState(
        icon: Symbols.search_rounded,
        title: l10n.search_settings_hint,
        compact: true,
      );
    }
    final hits = searchSettings(query, l10n);
    if (hits.isEmpty) {
      return ShioriEmptyState(
        icon: Symbols.search_off_rounded,
        title: l10n.no_result,
        compact: true,
      );
    }
    return ListView.builder(
      itemCount: hits.length,
      itemBuilder: (context, i) {
        final entry = hits[i];
        final subtitle = entry.subtitle?.call(l10n);
        return ListTile(
          title: Text(entry.title(l10n)),
          subtitle: Text(
            [entry.section(l10n), ?subtitle].join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Symbols.chevron_forward_rounded),
          onTap: () {
            close(context, null);
            context.push(entry.route, extra: entry.extra);
          },
        );
      },
    );
  }
}
