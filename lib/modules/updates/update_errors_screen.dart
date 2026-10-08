import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Persistent list of the last library update's failures. Each entry can be
/// dismissed or migrated away, so recurring source failures don't have to be
/// caught in the transient post-update dialog.
class UpdateErrorsScreen extends ConsumerWidget {
  const UpdateErrorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(updateErrorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.update_errors),
        actions: [
          if (errors.isNotEmpty)
            IconButton(
              tooltip: context.l10n.clear_all,
              icon: const Icon(Icons.clear_all),
              onPressed: () => ref.read(updateErrorsProvider.notifier).clear(),
            ),
        ],
      ),
      body: errors.isEmpty
          ? Center(child: Text(context.l10n.no_update_errors))
          : ListView.builder(
              itemCount: errors.length,
              itemBuilder: (context, index) {
                final err = errors[index];
                final manga = mangaRepository.findById(err.mangaId);
                return ListTile(
                  leading: _cover(manga),
                  title: Text(
                    err.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    err.error,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (manga != null)
                        IconButton(
                          tooltip: context.l10n.migrate,
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MigrationScreen(manga: manga),
                            ),
                          ),
                        ),
                      IconButton(
                        tooltip: context.l10n.dismiss,
                        icon: const Icon(Icons.close),
                        onPressed: () => ref
                            .read(updateErrorsProvider.notifier)
                            .remove(err.mangaId),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _cover(Manga? manga) {
    final cover = manga?.customCoverImage;
    return SizedBox(
      width: 40,
      height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: cover != null && cover.isNotEmpty
            ? Image.memory(Uint8List.fromList(cover), fit: BoxFit.cover)
            : const ColoredBox(
                color: Colors.black12,
                child: Icon(Icons.broken_image_outlined, size: 20),
              ),
      ),
    );
  }
}
