import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';

extension ItemTypeLocalization on ItemType {
  String localized(AppLocalizations l10n) {
    switch (this) {
      case ItemType.manga:
        return l10n.manga;
      case ItemType.anime:
        return l10n.anime;
      case ItemType.novel:
        return l10n.novel;
    }
  }

  String localizedSources(AppLocalizations l10n) {
    switch (this) {
      case ItemType.manga:
        return l10n.manga_sources;
      case ItemType.anime:
        return l10n.anime_sources;
      case ItemType.novel:
        return l10n.novel_sources;
    }
  }

  String localizedExtensions(AppLocalizations l10n) {
    switch (this) {
      case ItemType.manga:
        return l10n.manga_extensions;
      case ItemType.anime:
        return l10n.anime_extensions;
      case ItemType.novel:
        return l10n.novel_extensions;
    }
  }
}
