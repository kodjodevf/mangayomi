import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/memory_overlay.dart';
import 'package:mangayomi/utils/memory_probe.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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

  testWidgets('on a TV it offers no buttons a d-pad cannot reach', (
    tester,
  ) async {
    // It sits in a Stack above the whole app rather than inside its focus
    // traversal, so a remote can never land on those buttons. Showing them
    // would be two controls that look live and are not.
    debugIsTvOverride = true;
    addTearDown(() => debugIsTvOverride = null);
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();

    await pump(tester, probe);

    expect(find.text('Reset'), findsNothing);
    expect(find.text('Hide'), findsNothing);
    expect(find.textContaining('toggle it off and on'), findsOneWidget);
  });

  testWidgets('and still offers them where there is a pointer', (tester) async {
    debugIsTvOverride = false;
    addTearDown(() => debugIsTvOverride = null);
    final probe = MemoryProbe();
    addTearDown(probe.dispose);
    probe.sample();

    await pump(tester, probe);

    expect(find.text('Reset'), findsOneWidget);
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
