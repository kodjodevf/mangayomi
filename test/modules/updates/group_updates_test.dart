import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/updates/widgets/series_updates.dart';

Update _u(int id, int at) =>
    Update(id: id, mangaId: null, chapterName: '', date: '$at');

void main() {
  // Update id -> series id, and update id -> day.
  const series = {1: 10, 2: 10, 3: 20, 4: 10};
  const days = {1: 'mon', 2: 'mon', 3: 'mon', 4: 'tue'};

  List<SeriesDayUpdates> group(List<Update> updates) => groupUpdatesBySeries(
    updates,
    mangaIdOf: (u) => series[u.id],
    dayOf: (u) => days[u.id]!,
  );

  test('one entry per series and day', () {
    final out = group([_u(1, 100), _u(2, 300), _u(3, 200), _u(4, 400)]);
    expect(out.map((g) => (g.mangaId, g.day, g.updates.length)), [
      (10, 'mon', 2),
      (20, 'mon', 1),
      (10, 'tue', 1),
    ]);
  });

  test('newest first inside a group, and latest is the newest', () {
    final out = group([_u(1, 100), _u(2, 300)]);
    expect(out.single.updates.map((u) => u.id), [2, 1]);
    expect(out.single.latest, '300');
  });

  test('an update whose series is unknown is dropped', () {
    final out = groupUpdatesBySeries(
      [_u(9, 1)],
      mangaIdOf: (_) => null,
      dayOf: (_) => 'mon',
    );
    expect(out, isEmpty);
  });
}
