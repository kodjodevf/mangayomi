import 'package:mangayomi/models/manga.dart';

/// Sealed model for upcoming manga list items.
///
/// The list alternates between [Header] (date separator with count badge)
/// and [Item] (individual manga) entries.
sealed class UpcomingUIModel {
  const UpcomingUIModel();
}

class UpcomingHeader extends UpcomingUIModel {
  final DateTime date;
  final int mangaCount;

  const UpcomingHeader({required this.date, required this.mangaCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpcomingHeader &&
          date == other.date &&
          mangaCount == other.mangaCount;

  @override
  int get hashCode => Object.hash(date, mangaCount);
}

class UpcomingItem extends UpcomingUIModel {
  final Manga manga;
  final DateTime expectedDate;

  const UpcomingItem({required this.manga, required this.expectedDate});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpcomingItem && manga.id == other.manga.id;

  @override
  int get hashCode => manga.id.hashCode;
}
