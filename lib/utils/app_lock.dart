/// Lock delays offered in settings, in minutes: 0 locks as soon as the app
/// leaves the screen, [appLockOnLaunchOnly] only when it starts.
const appLockDelays = <int>[0, 1, 2, 5, 10, appLockOnLaunchOnly];

/// The lock delay meaning: only lock when the app starts.
const appLockOnLaunchOnly = -1;

/// Whether coming back to the app locks it, after it left the screen at
/// [backgroundedAt], given the lock delay [delayMinutes].
///
/// A delay of 0 locks as the app leaves, not here.
bool shouldLockOnResume({
  required int delayMinutes,
  required DateTime? backgroundedAt,
  required DateTime now,
}) {
  if (delayMinutes <= 0 || backgroundedAt == null) return false;
  return now.difference(backgroundedAt) >= Duration(minutes: delayMinutes);
}
