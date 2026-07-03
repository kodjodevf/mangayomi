import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/services/update_errors_provider.dart';

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
        title: const Text('Update errors'),
        actions: [
          if (errors.isNotEmpty)
            IconButton(
              tooltip: 'Clear all',
              icon: const Icon(Icons.clear_all),
              onPressed: () => ref.read(updateErrorsProvider.notifier).clear(),
            ),
        ],
      ),
      body: errors.isEmpty
          ? const Center(child: Text('No update errors'))
          : ListView.builder(
              itemCount: errors.length,
              itemBuilder: (context, index) {
                final err = errors[index];
                final manga = isar.mangas.getSync(err.mangaId);
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
                          tooltip: 'Migrate',
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MigrationScreen(manga: manga),
                            ),
                          ),
                        ),
                      IconButton(
                        tooltip: 'Dismiss',
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
