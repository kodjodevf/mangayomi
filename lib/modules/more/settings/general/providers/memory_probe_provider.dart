import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/memory_probe.dart';

/// The probe itself, alive for the app's lifetime so a measurement survives
/// navigating between screens, which is the whole point of taking one.
final memoryProbeProvider = Provider<MemoryProbe>((ref) {
  final probe = MemoryProbe();
  ref.onDispose(probe.dispose);
  return probe;
});

/// Whether the readout is on screen.
///
/// Deliberately not persisted. It is a measuring tool rather than a
/// preference, and keeping it out of the settings row means no schema change
/// for something that exists to answer one question and then stop.
class MemoryOverlayVisible extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    final probe = ref.read(memoryProbeProvider);
    if (value) {
      probe.reset();
      probe.start();
    } else {
      probe.stop();
    }
    state = value;
  }
}

final memoryOverlayVisibleProvider =
    NotifierProvider<MemoryOverlayVisible, bool>(MemoryOverlayVisible.new);
