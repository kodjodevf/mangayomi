import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/memory_overlay.dart';
import 'package:mangayomi/utils/memory_probe.dart';

/// The readout has to be legible from a sofa and has to say the thing that
/// decides the question: whether the cache is spending its time full.
void main() {
  Future<void> pump(WidgetTester tester, MemoryProbe probe) =>
      tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [MemoryOverlay(probe: probe, onClose: () {})],
          ),
        ),
      );

  testWidgets('says so plainly before the first sample', (tester) async {
    final probe = MemoryProbe();
    addTearDown(probe.dispose);

    await pump(tester, probe);

    expect(find.textContaining('waiting for a sample'), findsOneWidget);
  });

  testWidgets('shows RSS, the cache and how full it is', (tester) async {
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();

    await pump(tester, probe);

    expect(find.textContaining('RSS'), findsOneWidget);
    expect(find.textContaining('cache'), findsOneWidget);
    expect(find.textContaining('items'), findsOneWidget);
    expect(find.textContaining('% of'), findsOneWidget);
  });

  testWidgets('redraws as samples arrive, or it is not a live readout', (
    tester,
  ) async {
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();
    await pump(tester, probe);
    expect(find.textContaining('of 1 samples'), findsOneWidget);

    probe.sample();
    await tester.pump();

    expect(find.textContaining('of 2 samples'), findsOneWidget);
  });

  testWidgets('reset puts the count back so a run starts clean', (
    tester,
  ) async {
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();
    await pump(tester, probe);

    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.textContaining('waiting for a sample'), findsOneWidget);
  });

  testWidgets('without a close button it does not eat taps meant for the app', (
    tester,
  ) async {
    // It sits over the whole app, so it must not swallow input when it is
    // only there to be read.
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(children: [MemoryOverlay(probe: probe)]),
      ),
    );

    // MaterialApp puts its own IgnorePointers in the tree, so scope to ours.
    final ignore = tester.widget<IgnorePointer>(
      find
          .descendant(
            of: find.byType(MemoryOverlay),
            matching: find.byType(IgnorePointer),
          )
          .first,
    );
    expect(ignore.ignoring, true);
  });
}
