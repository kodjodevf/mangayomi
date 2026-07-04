import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// A named search query the user saved for a source, so frequent searches can
/// be re-run from the source browse with one tap.
class SavedSearch {
  final String name;
  final String query;

  const SavedSearch({required this.name, required this.query});

  Map<String, dynamic> toJson() => {'name': name, 'query': query};

  factory SavedSearch.fromJson(Map<dynamic, dynamic> json) => SavedSearch(
    name: (json['name'] ?? '') as String,
    query: (json['query'] ?? '') as String,
  );
}

const _boxName = 'saved_searches';

/// Opens the backing box. Called once at startup (see main.dart).
Future<void> openSavedSearchesBox() async {
  if (!Hive.isBoxOpen(_boxName)) {
    await Hive.openBox(_boxName);
  }
}

/// Saved searches keyed by source id. Persisted in Hive (one JSON value per
/// source, key `src_<id>`), so it needs no Isar schema change.
final savedSearchesProvider =
    NotifierProvider<SavedSearchesNotifier, Map<int, List<SavedSearch>>>(
      SavedSearchesNotifier.new,
    );

class SavedSearchesNotifier extends Notifier<Map<int, List<SavedSearch>>> {
  @override
  Map<int, List<SavedSearch>> build() {
    final result = <int, List<SavedSearch>>{};
    if (Hive.isBoxOpen(_boxName)) {
      final box = Hive.box(_boxName);
      for (final key in box.keys) {
        if (key is! String || !key.startsWith('src_')) continue;
        final id = int.tryParse(key.substring(4));
        if (id == null) continue;
        final raw = box.get(key);
        if (raw is String && raw.isNotEmpty) {
          try {
            result[id] = (jsonDecode(raw) as List)
                .map((e) => SavedSearch.fromJson(e as Map))
                .toList();
          } catch (_) {}
        }
      }
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
      SavedSearch(name: n, query: q),
    ];
    state = {...state, sourceId: list};
    _persist(sourceId);
  }

  void remove(int sourceId, String name) {
    state = {
      ...state,
      sourceId: forSource(sourceId).where((e) => e.name != name).toList(),
    };
    _persist(sourceId);
  }

  void _persist(int sourceId) {
    if (!Hive.isBoxOpen(_boxName)) return;
    Hive.box(_boxName).put(
      'src_$sourceId',
      jsonEncode(forSource(sourceId).map((e) => e.toJson()).toList()),
    );
  }
}
