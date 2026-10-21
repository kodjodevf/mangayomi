import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

/// Every component at twice the text size on the narrowest phone in use.
/// An overflow here is text a low-vision reader cannot see.
void main() {
  final theme = buildShioriTheme(
    brightness: Brightness.dark,
    colors: FlexColor.schemesList[2].dark,
    tintSurfaces: false,
    blendLevel: 10,
    density: ShioriDensity.phone,
  );

  const longTitle =
      'The Apothecary Diaries: Maomao and the Mysteries of the Inner Court';

  final cases = <String, Widget>{
    'ShioriListRow': ShioriListRow(
      leading: const ShioriThumbnail(child: SizedBox.expand()),
      title: longTitle,
      subtitle: 'Chapter 127 · Yesterday 18:40',
      trailing: IconButton(
        tooltip: 'Download',
        onPressed: () {},
        icon: const Icon(Symbols.download_rounded),
      ),
      onTap: () {},
    ),
    'ShioriButton': ShioriButton(
      label: 'Resume chapter 127',
      icon: Symbols.play_arrow_rounded,
      expand: true,
      onPressed: () {},
    ),
    'ShioriSectionHeader': ShioriSectionHeader(
      title: 'Continue reading',
      count: 128,
      actionLabel: 'See all',
      onAction: () {},
    ),
    'ShioriEmptyState': ShioriEmptyState(
      icon: Symbols.collections_bookmark_rounded,
      title: 'Your library is empty',
      message: 'Add a series from Browse and it will appear here.',
      actionLabel: 'Browse',
      onAction: () {},
    ),
    'ShioriToastCard': ShioriToastCard(
      message: 'Backup created: 1,284 entries and 52,113 chapters.',
      tone: ShioriToastTone.success,
      actions: [ShioriToastAction('Share', () {})],
    ),
    'ShioriStatusChip': const Wrap(
      children: [
        ShioriStatusChip(
          kind: ShioriStatusKind.completed,
          label: 'Completed',
          icon: Symbols.done_all_rounded,
        ),
      ],
    ),
    'ShioriOverlayLabel': const ShioriOverlayLabel('127 / 240'),
    'ShioriSegmentedControl': ShioriSegmentedControl<int>(
      segments: const [
        ShioriSegment(value: 0, label: 'Manga'),
        ShioriSegment(value: 1, label: 'Anime'),
        ShioriSegment(value: 2, label: 'Novel'),
      ],
      selected: 0,
      onSelected: (_) {},
    ),
  };

  for (final MapEntry(key: name, value: widget) in cases.entries) {
    testWidgets('$name fits at 200% text, 320 px wide', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(body: SingleChildScrollView(child: widget)),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    });
  }
}
