import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_code_selection_toolbar.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  testWidgets('the mobile code selection toolbar copies the selected code', (
    tester,
  ) async {
    String? copiedText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copiedText =
                (call.arguments as Map<Object?, Object?>)['text'] as String?;
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final controller = CodeLineEditingController.fromText('extensionCode');
    addTearDown(controller.dispose);
    controller.selection = const CodeLineSelection(
      baseIndex: 0,
      baseOffset: 0,
      extentIndex: 0,
      extentOffset: 9,
    );

    final toolbar = createExtensionCodeSelectionToolbar();
    final layerLink = LayerLink();
    final visibility = ValueNotifier(true);
    addTearDown(visibility.dispose);
    late BuildContext toolbarContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            toolbarContext = context;
            return Scaffold(
              body: CompositedTransformTarget(
                link: layerLink,
                child: const SizedBox(width: 320, height: 160),
              ),
            );
          },
        ),
      ),
    );

    toolbar.show(
      context: toolbarContext,
      controller: controller,
      anchors: const TextSelectionToolbarAnchors(primaryAnchor: Offset(50, 24)),
      renderRect: const Rect.fromLTWH(0, 0, 320, 160),
      layerLink: layerLink,
      visibility: visibility,
    );
    await tester.pumpAndSettle();

    final selectedText = controller.selectedText;
    expect(selectedText, 'extension');
    expect(find.text('Copy'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(copiedText, selectedText);
  });

  testWidgets('Select All refreshes the menu with the full extension code', (
    tester,
  ) async {
    final controller = CodeLineEditingController.fromText('extensionCode');
    addTearDown(controller.dispose);

    final toolbar = createExtensionCodeSelectionToolbar();
    final layerLink = LayerLink();
    final visibility = ValueNotifier(true);
    addTearDown(visibility.dispose);
    late BuildContext toolbarContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            toolbarContext = context;
            return Scaffold(
              body: CompositedTransformTarget(
                link: layerLink,
                child: const SizedBox(width: 320, height: 160),
              ),
            );
          },
        ),
      ),
    );

    toolbar.show(
      context: toolbarContext,
      controller: controller,
      anchors: const TextSelectionToolbarAnchors(primaryAnchor: Offset(50, 24)),
      renderRect: const Rect.fromLTWH(0, 0, 320, 160),
      layerLink: layerLink,
      visibility: visibility,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();

    expect(controller.selectedText, 'extensionCode');
    expect(find.text('Copy'), findsOneWidget);
  });
}
