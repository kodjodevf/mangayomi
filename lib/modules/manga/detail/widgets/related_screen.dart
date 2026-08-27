import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/related_titles.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

/// Covers are 2:3, matching the recommendation screen so the two read as the
/// same kind of list.
const double _coverWidth = 64;
const double _coverHeight = 96;

/// What the manga being read is related to.
///
/// Opening one searches the sources installed for its medium, so an anime
/// adaptation found here leads to somewhere it can actually be watched rather
/// than to a database entry.
class RelatedScreen extends StatefulWidget {
  const RelatedScreen({super.key, required this.name, required this.itemType});

  final String name;
  final ItemType itemType;

  @override
  State<RelatedScreen> createState() => _RelatedScreenState();
}

class _RelatedScreenState extends State<RelatedScreen> {
  late Future<List<RelatedTitle>> _future = _load();

  Future<List<RelatedTitle>> _load() =>
      fetchRelatedTitles(widget.name, widget.itemType);

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.related_titles)),
      body: FutureBuilder<List<RelatedTitle>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const ProgressCenter();
          }
          if (snapshot.hasError) {
            return ErrorState(
              // The real message, not "no result": a lookup that failed and a
              // title with nothing related to it are different answers.
              message: snapshot.error.toString(),
              onRetry: () => setState(() => _future = _load()),
            );
          }

          final titles = snapshot.data ?? const <RelatedTitle>[];
          if (titles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.related_none,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.secondaryColor),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) =>
                _RelatedTile(title: titles[index], from: widget.itemType),
          );
        },
      ),
    );
  }
}

class _RelatedTile extends StatelessWidget {
  const _RelatedTile({required this.title, required this.from});

  final RelatedTitle title;
  final ItemType from;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final cover = title.coverImage;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: SizedBox(
        width: _coverWidth,
        height: _coverHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: cover == null
              ? Container(
                  color: context.secondaryColor.withValues(alpha: 0.12),
                  child: const Icon(Icons.image_not_supported_outlined),
                )
              : Image(
                  image: coverProvider(cover),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.broken_image_outlined),
                ),
        ),
      ),
      title: Text(title.title),
      subtitle: Text(
        [
          _relationLabel(l10n, title.relation),
          if (title.format != null) _prettyFormat(title.format!),
        ].join(' · '),
        style: TextStyle(color: context.secondaryColor, fontSize: 12),
      ),
      // The medium is the thing worth spotting at a glance, so it is a chip
      // rather than another line of prose.
      trailing: title.crossesMedium(from)
          ? Chip(
              label: Text(
                title.itemType.localized(l10n),
                style: const TextStyle(fontSize: 11),
              ),
              visualDensity: VisualDensity.compact,
            )
          : null,
      onTap: () =>
          context.push('/globalSearch', extra: (title.title, title.itemType)),
    );
  }
}

/// Both services name relations the same way once upper-cased. Anything not
/// named here is still shown, under a neutral label, rather than hidden.
String _relationLabel(AppLocalizations l10n, String relation) =>
    switch (relation) {
      'ADAPTATION' => l10n.relation_adaptation,
      'SEQUEL' => l10n.relation_sequel,
      'PREQUEL' => l10n.relation_prequel,
      'PARENT' => l10n.relation_parent,
      'SIDE_STORY' => l10n.relation_side_story,
      'SPIN_OFF' => l10n.relation_spin_off,
      'ALTERNATIVE' ||
      'ALTERNATIVE_SETTING' ||
      'ALTERNATIVE_VERSION' => l10n.relation_alternative,
      _ => l10n.related_titles,
    };

/// SIDE_STORY reads badly on a card; Side story does not.
String _prettyFormat(String format) {
  final words = format.toLowerCase().split('_');
  return [
    words.first.isEmpty
        ? ''
        : words.first[0].toUpperCase() + words.first.substring(1),
    ...words.skip(1),
  ].join(' ');
}
