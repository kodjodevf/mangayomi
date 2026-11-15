import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/sync/sync_change_collector.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';

void main() {
  Map<String, dynamic> manga(int clientId, String name, String link) => {
    'clientId': clientId,
    'source': 'Demo',
    'link': link,
    'itemType': 'MANGA',
    'name': name,
    'description': 'd' * 12000,
    'updatedAt': 10,
  };

  ChangedRows rows(List<Map<String, dynamic>> manga) => ChangedRows.fromRows(
    categories: const [],
    manga: manga,
    chapters: const [],
    tracks: const [],
    histories: const [],
    updates: const [],
    deleted: null,
    settings: null,
    deletionActionsToClear: const [],
  );

  test('a row too long to send is left out, and the rest still goes', () {
    final changed = rows([
      manga(1, 'Fits', '/fits'),
      manga(2, 'Too long', 'x' * 70000),
    ]);

    expect([for (final m in changed.manga) m['clientId']], [1]);
    expect(changed.unsent.single.toString(), '"Too long" (link)');

    // What is sent passes the other end's checks: it is not refused whole.
    for (final chunk in changed.chunked(5000)) {
      expect(
        () => validateSyncRequest({'since': 0, ...chunk}),
        returnsNormally,
      );
    }
  });

  test('a long description is shortened, not a reason to leave out', () {
    final changed = rows([manga(1, 'Fits', '/fits')]);
    expect(changed.unsent, isEmpty);
    expect((changed.manga.single['description'] as String).length, 10000);
  });
}
