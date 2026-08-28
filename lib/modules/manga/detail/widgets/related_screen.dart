import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/related_titles.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Covers are 2:3, matching the recommendation screen so the two read as one
/// kind of list rather than two.
const double _coverWidth = 96;
const double _coverHeight = 144;

const double _alphaTint = 0.08;
const double _alphaFocus = 0.14;
const double _alphaSecondary = 0.70;

/// What the open title is related to.
///
/// Opening one searches the sources installed for its medium, so an anime
/// adaptation found from a manga leads somewhere it can be watched rather than
/// to a database entry.
class RelatedScreen extends StatefulWidget {
  const RelatedScreen({super.key, required this.name, required this.itemType});

  final String name;
  final ItemType itemType;

  @override
  State<RelatedScreen> createState() => _RelatedScreenState();
}

class _RelatedScreenState extends State<RelatedScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<RelatedTitle>? data;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _errorMessage = "";
      data = await fetchRelatedTitles(widget.name, widget.itemType);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.related_titles)),
      body: _isLoading
          ? const ProgressCenter()
          : _errorMessage.isNotEmpty
          // The cause goes in detail, not message: a lookup that failed and a
          // title with nothing related to it are different answers, and only
          // one of them is worth a stack.
          ? ErrorState(
              detail: _errorMessage,
              onRetry: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = "";
                });
                _init();
              },
            )
          : (data == null || data!.isEmpty)
          ? Center(child: Text(l10n.related_none))
          // One column, like the watch order this sits beside. The list is
          // short, and an adaptation is meant to be read down the page rather
          // than scanned across it.
          : ListView.separated(
              // tvPageInsets is zero off TV, and the card draws its own row
              // rather than a ListTile, so without this the covers run flush
              // to the window edge.
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ).add(tvPageInsets),
              itemCount: data!.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) =>
                  _card(context, data![index], index),
            ),
    );
  }

  Widget _card(BuildContext context, RelatedTitle related, int index) {
    final l10n = context.l10n;
    final crossesMedium = related.crossesMedium(widget.itemType);
    final medium = related.itemType.localized(l10n);
    final format = related.format == null
        ? null
        : prettyFormat(related.format!);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Nothing is focusable on entry otherwise, so a remote does nothing
        // until the user guesses a direction.
        autofocus: isTv && index == 0,
        focusColor: context.primaryColor.withValues(alpha: _alphaFocus),
        onTap: () => context.push(
          '/globalSearch',
          extra: (related.title, related.itemType),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image(
                  // toImgUrl stands a blank in for an entry with no poster, so
                  // a missing cover leaves a gap of the right shape instead of
                  // collapsing the row.
                  image: coverProvider(toImgUrl(related.coverImage ?? "")),
                  width: _coverWidth,
                  height: _coverHeight,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The title gets the full width. Putting a tag beside it
                    // cost it a line on anything with a subtitle, and the
                    // title is what is being scanned for.
                    Text(
                      related.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        // The medium leads and is filled with the accent when
                        // it differs from what is being read, because that is
                        // the whole point of the list.
                        _tag(
                          context,
                          medium,
                          filled: crossesMedium,
                          bold: true,
                        ),
                        _tag(context, _relationLabel(l10n, related.relation)),
                        // Kitsu's subtype for a manga is "manga", so this said
                        // "Manga  Manga" on every manga entry. Shown only when
                        // it narrows the medium: Manhwa, Oneshot, TV, Movie.
                        if (format != null &&
                            format.toLowerCase() != medium.toLowerCase())
                          _tag(context, format),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One tag.
  ///
  /// Filled with the accent when it is the thing the row is here for, tinted
  /// otherwise, so a glance down the list finds the medium changes without
  /// reading any of the words.
  Widget _tag(
    BuildContext context,
    String label, {
    bool filled = false,
    bool bold = false,
  }) {
    final accent = context.primaryColor;
    // Computed against the accent rather than the theme, so it stays readable
    // whichever hue the user picked and in either brightness.
    final onAccent = accent.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: filled
            ? accent
            : context.textColor.withValues(alpha: _alphaTint),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
          color: filled
              ? onAccent
              : context.textColor.withValues(alpha: _alphaSecondary),
        ),
      ),
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

/// Kitsu and AniList both hand these over shouting: TV, OVA, ONE_SHOT,
/// LIGHT_NOVEL. Title case reads better on a card, except where the word is an
/// acronym and title case turns TV into "Tv".
@visibleForTesting
const formatAcronyms = {'TV', 'OVA', 'ONA', 'OAV', 'CM', 'PV'};

@visibleForTesting
String prettyFormat(String format) {
  final words = format.split('_').where((w) => w.isNotEmpty).map((word) {
    if (formatAcronyms.contains(word.toUpperCase())) return word.toUpperCase();
    final lower = word.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }).toList();

  if (words.isEmpty) return format;
  // Only the first word is capitalised: "Light novel", not "Light Novel".
  return [
    words.first,
    ...words
        .skip(1)
        .map((w) => formatAcronyms.contains(w) ? w : w.toLowerCase()),
  ].join(' ');
}
