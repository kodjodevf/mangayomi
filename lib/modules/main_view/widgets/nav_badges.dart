import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

class ExtensionBadgeWidget extends ConsumerWidget {
  const ExtensionBadgeWidget({
    super.key,
    required this.icon,
    required this.ref,
  });

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: sourceRepository.watchActiveExcludingHiddenItemTypes(
        hideManga: hideItems.contains("/MangaLibrary"),
        hideAnime: hideItems.contains("/AnimeLibrary"),
        hideNovel: hideItems.contains("/NovelLibrary"),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        final entries = snapshot.data!
            .where(
              (element) =>
                  (element.isAdded ?? false) &&
                  !(element.isObsolete ?? false) &&
                  compareVersions(
                        element.version ?? '',
                        element.versionLast ?? '',
                      ) <
                      0,
            )
            .toList();

        if (entries.isEmpty) {
          return icon;
        }

        return Badge(label: Text("${entries.length}"), child: icon);
      },
    );
  }
}

class UpdatesBadgeWidget extends ConsumerWidget {
  const UpdatesBadgeWidget({super.key, required this.icon, required this.ref});

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: updateRepository.watchUnreadExcludingHiddenItemTypes(
        hideManga: hideItems.contains("/MangaLibrary"),
        hideAnime: hideItems.contains("/AnimeLibrary"),
        hideNovel: hideItems.contains("/NovelLibrary"),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        return Badge(label: Text("${snapshot.data!.length}"), child: icon);
      },
    );
  }
}
