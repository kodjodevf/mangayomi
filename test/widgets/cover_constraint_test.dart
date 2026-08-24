import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The watch order rail is a fixed width column holding each cover. A bare
/// SizedBox(width:) hands its child a *tight* width, which silently overrides
/// whatever width the cover asks for, so every cover renders at the rail width
/// and only its height ever changes. Centring restores the cover's own width.
Widget _rail({required bool centred}) {
  const cover = SizedBox(key: Key('cover'), width: 100, height: 146);
  return MaterialApp(
    home: Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 132,
            child: centred ? const Center(child: cover) : cover,
          ),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('a bare rail stretches the cover to the rail width', (t) async {
    await t.pumpWidget(_rail(centred: false));
    final size = t.getSize(find.byKey(const Key('cover')));
    expect(
      size.width,
      132,
      reason: 'tight constraint wins over the cover width',
    );
    expect(size.height, 146);
  });

  testWidgets('centring lets the cover keep its own width and aspect', (
    t,
  ) async {
    await t.pumpWidget(_rail(centred: true));
    final size = t.getSize(find.byKey(const Key('cover')));
    expect(size.width, 100);
    expect(size.height, 146);
    expect(size.width / size.height, closeTo(0.685, 0.001));
  });
}
