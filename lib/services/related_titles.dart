import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/kitsu_discovery.dart';

/// A title related to the one being read, ready to put on screen.
///
/// The point of this is the cross-medium jump: someone reading a manga wants
/// to know there is an anime, and wants to land on it in a source they have
/// installed rather than on a database page.
class RelatedTitle {
  const RelatedTitle({
    required this.title,
    required this.relation,
    required this.itemType,
    this.coverImage,
    this.format,
  });

  final String title;

  /// ADAPTATION, SEQUEL, PREQUEL, SIDE_STORY, SPIN_OFF, ALTERNATIVE and the
  /// rest, upper-cased. Kitsu and AniList disagree on case and agree on names.
  final String relation;

  /// Which library this belongs in, and so which sources to search when it is
  /// opened.
  final ItemType itemType;

  final String? coverImage;

  /// TV, MOVIE, MANGA, NOVEL and so on. Shown beside the title because
  /// "adaptation" alone does not say whether it is a series or a film.
  final String? format;

  /// True when this is in a different medium from the title it hangs off.
  bool crossesMedium(ItemType from) => _isVideo(itemType) != _isVideo(from);
}

bool _isVideo(ItemType type) => type == ItemType.anime;

/// Where a related entry belongs: an anime, a novel, or a manga.
///
/// Kitsu has no novel type, it has a manga whose subtype is `novel`, so the
/// format decides between the two.
ItemType relatedItemType(DiscoveryMedia media) {
  if ((media.type ?? '').toUpperCase() == 'ANIME') return ItemType.anime;
  final format = (media.format ?? '').toUpperCase();
  if (format == 'NOVEL' || format == 'LIGHT_NOVEL') return ItemType.novel;
  return ItemType.manga;
}

/// Orders relations so the useful ones are first and drops the noise.
///
/// An adaptation in another medium leads first, because it is the thing that
/// cannot be found any other way from inside a manga. Then the story order,
/// then everything else. Entries with no usable title are dropped rather than
/// drawn as a blank card.
List<RelatedTitle> orderRelations(
  List<DiscoveryRelation> relations,
  ItemType from,
) {
  final out = <RelatedTitle>[];
  final seen = <String>{};

  for (final relation in relations) {
    final media = relation.media;
    final title = media.english ?? media.romaji ?? media.native;
    if (title == null || title.isEmpty) continue;

    final itemType = relatedItemType(media);
    // The same work is listed under more than one relation by both services,
    // and a title repeated in one medium is a duplicate, not two entries.
    if (!seen.add('${itemType.name}:${title.toLowerCase()}')) continue;

    out.add(
      RelatedTitle(
        title: title,
        relation: relation.relationType.toUpperCase(),
        itemType: itemType,
        coverImage: media.coverImage,
        format: media.format,
      ),
    );
  }

  out.sort((a, b) => _rank(a, from).compareTo(_rank(b, from)));
  return out;
}

/// Lower sorts first.
int _rank(RelatedTitle title, ItemType from) {
  if (title.relation == 'ADAPTATION') return title.crossesMedium(from) ? 0 : 1;
  return switch (title.relation) {
    'SEQUEL' => 2,
    'PREQUEL' => 3,
    'PARENT' => 4,
    'SIDE_STORY' => 5,
    'SPIN_OFF' => 6,
    'ALTERNATIVE' || 'ALTERNATIVE_SETTING' || 'ALTERNATIVE_VERSION' => 7,
    _ => 8,
  };
}

/// Everything related to [name], resolved by title.
///
/// Two calls: one to turn a name into an id, one to ask what hangs off it.
/// Both go through Kitsu, which answers without a key and is already the
/// fallback the rest of discovery uses.
Future<List<RelatedTitle>> fetchRelatedTitles(
  String name,
  ItemType itemType,
) async {
  // Kitsu knows anime and manga. A novel is looked up among manga, which is
  // where Kitsu keeps it.
  final lookupType = itemType == ItemType.anime
      ? ItemType.anime
      : ItemType.manga;

  final mediaId = await kitsuSearchMediaId(lookupType, name);
  if (mediaId == null) return const [];

  final (_, relations) = await kitsuMediaWithRelations(lookupType, mediaId);
  return orderRelations(relations, itemType);
}
