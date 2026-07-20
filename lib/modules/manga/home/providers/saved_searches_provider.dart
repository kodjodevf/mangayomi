import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

// SavedSearch is an @embedded model on the Settings collection; re-export it so
// existing call sites can keep importing it from this provider.
export 'package:mangayomi/models/settings.dart' show SavedSearch;

/// Saved searches keyed by source id, so frequent searches can be re-run from
/// the source browse with one tap. Persisted on the Settings collection as a
/// flat list where each entry carries its `sourceId`.
final savedSearchesProvider =
    NotifierProvider<SavedSearchesNotifier, Map<int, List<SavedSearch>>>(
      SavedSearchesNotifier.new,
    );

class SavedSearchesNotifier extends Notifier<Map<int, List<SavedSearch>>> {
  @override
  Map<int, List<SavedSearch>> build() {
    final result = <int, List<SavedSearch>>{};
    final list = isar.settings.getSync(227)?.savedSearchesList ?? const [];
    for (final s in list) {
      final id = s.sourceId;
      if (id == null) continue;
      (result[id] ??= []).add(s);
    }
    return result;
  }

  List<SavedSearch> forSource(int sourceId) => state[sourceId] ?? const [];

  void add(int sourceId, String name, String query) {
    final n = name.trim();
    final q = query.trim();
    if (n.isEmpty || q.isEmpty) return;
    final list = [
      ...forSource(sourceId).where((e) => e.name != n),
      SavedSearch(sourceId: sourceId, name: n, query: q),
    ];
    state = {...state, sourceId: list};
    _persist();
  }

  void remove(int sourceId, String name) {
    state = {
      ...state,
      sourceId: forSource(sourceId).where((e) => e.name != name).toList(),
    };
    _persist();
  }

  void _persist() {
    final flat = [for (final entry in state.values) ...entry];
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..savedSearchesList = flat);
      }
    });
  }
}
