import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/library_updater.dart';

void main() {
  const hour = Duration.millisecondsPerHour;
  const now = 1000 * hour;

  group('isLibraryUpdateDue', () {
    test('an interval of 0 never runs, however long it has been', () {
      expect(
        isLibraryUpdateDue(intervalHours: 0, lastRun: 0, now: now),
        isFalse,
      );
      expect(
        isLibraryUpdateDue(intervalHours: 0, lastRun: null, now: now),
        isFalse,
      );
    });

    test('a library that has never refreshed is due right away', () {
      expect(
        isLibraryUpdateDue(intervalHours: 24, lastRun: null, now: now),
        isTrue,
      );
    });

    test('waits out the interval, then runs', () {
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now - 23 * hour,
          now: now,
        ),
        isFalse,
      );
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now - 24 * hour,
          now: now,
        ),
        isTrue,
      );
    });

    test('a refresh that just started is not due again', () {
      expect(
        isLibraryUpdateDue(intervalHours: 12, lastRun: now, now: now),
        isFalse,
      );
    });

    test('every offered interval is honoured', () {
      for (final hours in libraryUpdateIntervals.where((h) => h > 0)) {
        expect(
          isLibraryUpdateDue(
            intervalHours: hours,
            lastRun: now - (hours - 1) * hour,
            now: now,
          ),
          isFalse,
          reason: 'an interval of $hours hours ran an hour early',
        );
        expect(
          isLibraryUpdateDue(
            intervalHours: hours,
            lastRun: now - hours * hour,
            now: now,
          ),
          isTrue,
          reason: 'an interval of $hours hours did not come due',
        );
      }
    });

    test('a clock that moved backwards does not run early', () {
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now + 5 * hour,
          now: now,
        ),
        isFalse,
      );
    });
  });
}
