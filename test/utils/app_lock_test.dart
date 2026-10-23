import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/app_lock.dart';

void main() {
  final left = DateTime(2026, 10, 23, 12);

  test('locks once the delay has passed', () {
    expect(
      shouldLockOnResume(
        delayMinutes: 5,
        backgroundedAt: left,
        now: left.add(const Duration(minutes: 5)),
      ),
      isTrue,
    );
    expect(
      shouldLockOnResume(
        delayMinutes: 5,
        backgroundedAt: left,
        now: left.add(const Duration(minutes: 4, seconds: 59)),
      ),
      isFalse,
    );
  });

  test('no lock on resume when it locks at once or only at launch', () {
    for (final delay in [0, appLockOnLaunchOnly]) {
      expect(
        shouldLockOnResume(
          delayMinutes: delay,
          backgroundedAt: left,
          now: left.add(const Duration(hours: 1)),
        ),
        isFalse,
      );
    }
  });

  test('no lock without a time the app left', () {
    expect(
      shouldLockOnResume(delayMinutes: 1, backgroundedAt: null, now: left),
      isFalse,
    );
  });
}
