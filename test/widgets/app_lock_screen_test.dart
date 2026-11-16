import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/core/app_layers.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/modules/more/settings/security/app_lock_screen.dart';
import 'package:mangayomi/providers/security_state_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

class _Locked extends AppUnlockedState {
  @override
  bool build() => false;
}

/// The device's prompt, held open until the test answers it.
class _Prompt {
  var asked = 0;
  Completer<bool>? _answer;

  Future<bool> call(String reason) {
    asked++;
    return (_answer = Completer<bool>()).future;
  }

  void answer(bool authenticated) => _answer!.complete(authenticated);
}

void main() {
  late _Prompt prompt;
  late ProviderContainer container;

  /// The app as main.dart lays it out: the lock screen while locked, and
  /// the secure-screen cover over everything while [obscured].
  Future<void> pump(
    WidgetTester tester,
    ValueNotifier<bool> obscured, {
    bool lockScreenStaysWhileObscured = true,
  }) async {
    container = ProviderContainer(
      overrides: [appUnlockedStateProvider.overrideWith(_Locked.new)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildShioriTheme(
            brightness: Brightness.dark,
            colors: FlexColor.schemesList[2].dark,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) => ValueListenableBuilder(
              valueListenable: obscured,
              builder: (_, isObscured, _) {
                final locked = !ref.watch(appUnlockedStateProvider);
                final showLock =
                    locked && (lockScreenStaysWhileObscured || !isObscured);
                return AppLayers(
                  app: const Text('app'),
                  covers: [
                    if (showLock)
                      AppLockScreen(
                        key: const ValueKey(AppLockScreen),
                        authenticate: prompt.call,
                      ),
                    if (isObscured)
                      const ColoredBox(
                        key: ValueKey('cover'),
                        color: Colors.black,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  setUp(() => prompt = _Prompt());

  testWidgets('the secure-screen cover coming up during the prompt neither '
      'drops the unlock nor asks again', (tester) async {
    final obscured = ValueNotifier(false);
    addTearDown(obscured.dispose);
    await pump(tester, obscured);
    expect(prompt.asked, 1);

    // The system's prompt takes the app off screen: the cover comes up.
    obscured.value = true;
    await tester.pump();
    prompt.answer(true);
    await tester.pump();
    obscured.value = false;
    await tester.pumpAndSettle();

    expect(container.read(appUnlockedStateProvider), isTrue);
    expect(find.byType(AppLockScreen), findsNothing);
    expect(prompt.asked, 1);
  });

  testWidgets('a success still unlocks once the lock screen is gone', (
    tester,
  ) async {
    // As 0.9.96 laid it out: the cover replaced the lock screen.
    final obscured = ValueNotifier(false);
    addTearDown(obscured.dispose);
    await pump(tester, obscured, lockScreenStaysWhileObscured: false);
    obscured.value = true;
    await tester.pump();
    expect(find.byType(AppLockScreen), findsNothing);

    prompt.answer(true);
    await tester.pump();
    obscured.value = false;
    await tester.pumpAndSettle();

    expect(container.read(appUnlockedStateProvider), isTrue);
    expect(prompt.asked, 1);
  });

  testWidgets('a failed prompt keeps the app locked, the button there to '
      'try again', (tester) async {
    final obscured = ValueNotifier(false);
    addTearDown(obscured.dispose);
    await pump(tester, obscured);
    prompt.answer(false);
    await tester.pumpAndSettle();

    expect(container.read(appUnlockedStateProvider), isFalse);
    expect(find.byType(AppLockScreen), findsOneWidget);
    expect(prompt.asked, 1);
  });
}
