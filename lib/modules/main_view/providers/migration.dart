import 'package:mangayomi/repositories/source_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'migration.g.dart';

@riverpod
Future<void> migration(Ref ref) async {
  // One-time cleanup: locally-created extensions that were uninstalled
  // before the fix that hard-deletes them on uninstall are stuck as dead
  // rows (isAdded: false, sourceCode: "", no repo to reinstall from). Prune
  // any that are still lingering.
  final orphanedLocalIds = sourceRepository.getOrphanedLocalIds();

  if (orphanedLocalIds.isNotEmpty) {
    sourceRepository.deleteAll(orphanedLocalIds);
  }
}
