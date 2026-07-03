import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// A single failed library-update entry, persisted so the user can review it
/// (and migrate the entry away) after the update run has finished.
class UpdateError {
  final int mangaId;
  final String name;
  final String error;

  const UpdateError({
    required this.mangaId,
    required this.name,
    required this.error,
  });

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'name': name,
    'error': error,
  };

  factory UpdateError.fromJson(Map<dynamic, dynamic> json) => UpdateError(
    mangaId: json['mangaId'] as int,
    name: (json['name'] ?? '') as String,
    error: (json['error'] ?? '') as String,
  );
}

const _boxName = 'update_errors';
const _key = 'errors';

/// Opens the backing box. Called once at startup (see main.dart).
Future<void> openUpdateErrorsBox() async {
  if (!Hive.isBoxOpen(_boxName)) {
    await Hive.openBox(_boxName);
  }
}

/// The last library update's failures, persisted across restarts so they can be
/// reviewed on the [UpdateErrorsScreen] rather than only in a transient dialog.
final updateErrorsProvider =
    NotifierProvider<UpdateErrorsNotifier, List<UpdateError>>(
      UpdateErrorsNotifier.new,
    );

class UpdateErrorsNotifier extends Notifier<List<UpdateError>> {
  @override
  List<UpdateError> build() => _read();

  List<UpdateError> _read() {
    if (Hive.isBoxOpen(_boxName)) {
      final raw = Hive.box(_boxName).get(_key);
      if (raw is String && raw.isNotEmpty) {
        try {
          return (jsonDecode(raw) as List)
              .map((e) => UpdateError.fromJson(e as Map))
              .toList();
        } catch (_) {}
      }
    }
    return [];
  }

  /// Replaces the stored failures with the latest update run's results.
  void set(List<UpdateError> errors) {
    state = errors;
    _persist();
  }

  /// Drops a single entry (e.g. after the user migrated or handled it).
  void remove(int mangaId) {
    state = state.where((e) => e.mangaId != mangaId).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  void _persist() {
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(
        _boxName,
      ).put(_key, jsonEncode(state.map((e) => e.toJson()).toList()));
    }
  }
}
