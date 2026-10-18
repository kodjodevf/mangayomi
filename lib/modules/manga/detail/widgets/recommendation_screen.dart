import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/recommendation.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Covers are 2:3, so a grid of mixed sources does not visibly jitter.
const double _coverWidth = 96;
const double _coverHeight = 144;

/// Cover plus the card's vertical padding.
const double _cardExtent = _coverHeight + 12;

/// One column on a phone, two above this, and never more than two: a third
/// column turns a scannable list of cover-plus-prose into a wall.
const double _twoColumnBreakpoint = 700;

class RecommendationScreen extends StatefulWidget {
  final MediaLookupContext media;
  final AlgorithmWeights algorithmWeights;

  const RecommendationScreen({
    super.key,
    required this.media,
    required this.algorithmWeights,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<RecommendationResult>? data;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _errorMessage = "";
      data = await getRecommendations(widget.media, widget.algorithmWeights);
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
      appBar: AppBar(title: Text(l10n.recommendations)),
      body: _isLoading
          ? const ProgressCenter()
          : _errorMessage.isNotEmpty
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
          ? ShioriEmptyState(
              icon: Symbols.auto_awesome_rounded,
              title: l10n.no_result,
              compact: true,
            )
          // Poster list: a cover, the catalog rating as a filled pill, the
          // title, a two-line capped synopsis and genre chips. Rows used to
          // stretch the full width of a TV or desktop panel; the grid reflows
          // to two columns instead so they never run into empty space.
          : LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= _twoColumnBreakpoint
                    ? 2
                    : 1;
                return GridView.builder(
                  padding: tvPageInsets,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: _cardExtent,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (context, index) =>
                      _card(context, data![index], index),
                );
              },
            ),
    );
  }

  Widget _card(BuildContext context, RecommendationResult rec, int index) {
    final title = rec.title;
    final coverUrl = rec.imgURLs.isNotEmpty ? rec.imgURLs.first : "";
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ShioriShape.cover),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Nothing was focusable on entry, so a remote did nothing until the
        // user guessed a direction. The first card claims focus on a TV.
        autofocus: isTv && index == 0,
        focusColor: context.shiori.color.accent.withValues(alpha: Alphas.focus),
        onTap: () => context.push(
          '/globalSearch',
          extra: (rec.searchTarget.query, rec.searchTarget.itemType),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ShioriSpace.s8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ShioriShape.cover),
                child: Image(
                  image: coverProvider(toImgUrl(coverUrl)),
                  width: _coverWidth,
                  height: _coverHeight,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: ShioriSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (rec.rating case CatalogRating rating) ...[
                          _ratingPill(context, rating),
                          const SizedBox(width: ShioriSpace.s8),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: context.shiori.text.row.fontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (rec.description != null &&
                        rec.description!.isNotEmpty) ...[
                      const SizedBox(height: ShioriSpace.s4),
                      Text(
                        rec.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.shiori.caption.copyWith(height: 1.35),
                      ),
                    ],
                    if (rec.genres.isNotEmpty) ...[
                      const SizedBox(height: ShioriSpace.s8),
                      Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: [
                          for (final g in rec.genres.take(3)) _chip(context, g),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The rating, filled with the accent.
  Widget _ratingPill(BuildContext context, CatalogRating rating) {
    final label = rating.valueLabel;
    return Semantics(
      label: context.l10n.recommendation_rating_accessibility(label),
      child: ExcludeSemantics(
        child: EntryBadgeChip(
          label: label,
          tone: EntryBadgeChip.accent(context),
          strong: true,
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String text) =>
      EntryBadgeChip(label: text);
}
