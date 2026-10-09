const temporaryPlaybackSpeeds = <double>[
  3.0,
  2.5,
  2.0,
  1.5,
  1.0,
  0.75,
  0.5,
  0.25,
];

const temporaryPlaybackSpeedStepExtent = 36.0;

double nearestTemporaryPlaybackSpeed(double speed) {
  return temporaryPlaybackSpeeds.reduce(
    (nearest, candidate) => (candidate - speed).abs() < (nearest - speed).abs()
        ? candidate
        : nearest,
  );
}

double initialTemporaryPlaybackSpeed() => 2.0;

double temporaryPlaybackSpeedForDrag({
  required double initialSpeed,
  required double verticalDelta,
  double stepExtent = temporaryPlaybackSpeedStepExtent,
}) {
  assert(stepExtent > 0);
  final snappedInitialSpeed = nearestTemporaryPlaybackSpeed(initialSpeed);
  final initialIndex = temporaryPlaybackSpeeds.indexOf(snappedInitialSpeed);
  final movedSteps = (verticalDelta / stepExtent).round();
  final targetIndex = (initialIndex + movedSteps).clamp(
    0,
    temporaryPlaybackSpeeds.length - 1,
  );
  return temporaryPlaybackSpeeds[targetIndex];
}

String temporaryPlaybackSpeedLabel(double speed) {
  final value = speed == speed.roundToDouble()
      ? speed.toStringAsFixed(0)
      : speed.toString();
  return '${value}x';
}
