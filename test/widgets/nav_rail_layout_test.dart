import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  test('a phone in landscape is still a phone', () {
    // Judged on the shortest side. By width alone a rotated phone is over 600
    // and was handed a rail the moment it turned.
    expect(sizeWantsNavRail(const Size(390, 844)), isFalse, reason: 'portrait');
    expect(
      sizeWantsNavRail(const Size(844, 390)),
      isFalse,
      reason: 'the same phone, rotated',
    );
    expect(sizeWantsNavRail(const Size(1024, 768)), isTrue, reason: 'tablet');
    expect(sizeWantsNavRail(const Size(768, 1024)), isTrue);
  });

  group('the floating bar gate', () {
    tearDown(() => debugIsTvOverride = null);

    test('a TV never takes the floating bar', () {
      debugIsTvOverride = true;
      expect(
        supportsFloatingNav,
        isFalse,
        reason:
            'the capsule holds no focus handling, so a remote cannot reach it',
      );
    });

    test('anything that is not a TV keeps whatever its platform says', () {
      debugIsTvOverride = true;
      final onTv = supportsFloatingNav;
      debugIsTvOverride = false;
      final offTv = supportsFloatingNav;
      expect(onTv, isFalse);
      expect(
        offTv,
        isTrue,
        reason: 'the test host is one of the gated platforms',
      );
    });

    test('the gate follows TV detection landing after the first read', () {
      // initIsTv is asynchronous, so the first read can happen while detection
      // still says "not a TV". A top-level final would cache that answer for
      // the rest of the process and put the capsule on a television.
      debugIsTvOverride = false;
      expect(supportsFloatingNav, isTrue);
      debugIsTvOverride = true;
      expect(
        supportsFloatingNav,
        isFalse,
        reason: 'must re-read isTv, not cache the first answer',
      );
    });

    test('a TV falls through to the size rule and keeps its rail', () {
      debugIsTvOverride = true;
      expect(supportsFloatingNav, isFalse);
      expect(sizeWantsNavRail(const Size(1920, 1080)), isTrue);
    });

    test('the floating bar remains opt-in on a supported platform', () {
      debugIsTvOverride = false;
      expect(shouldUseFloatingNav(enabled: false), isFalse);
      expect(shouldUseFloatingNav(enabled: true), isTrue);
    });

    test('the preference cannot enable the floating bar on a TV', () {
      debugIsTvOverride = true;
      expect(shouldUseFloatingNav(enabled: true), isFalse);
    });
  });

  testWidgets('a tablet keeps its rail until floating navigation is enabled', (
    tester,
  ) async {
    late bool withStandardNavigation;
    late bool withFloatingNavigation;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1024, 768)),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              withStandardNavigation = context.prefersNavRail(
                useFloatingNav: false,
              );
              withFloatingNavigation = context.prefersNavRail(
                useFloatingNav: true,
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(withStandardNavigation, isTrue);
    expect(withFloatingNavigation, isFalse);
  });
}
