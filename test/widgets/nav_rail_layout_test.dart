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
        usesFloatingNav,
        isFalse,
        reason:
            'the capsule holds no focus handling, so a remote cannot reach it',
      );
    });

    test('anything that is not a TV keeps whatever its platform says', () {
      debugIsTvOverride = true;
      final onTv = usesFloatingNav;
      debugIsTvOverride = false;
      final offTv = usesFloatingNav;
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
      expect(usesFloatingNav, isTrue);
      debugIsTvOverride = true;
      expect(
        usesFloatingNav,
        isFalse,
        reason: 'must re-read isTv, not cache the first answer',
      );
    });

    test('a TV falls through to the size rule and keeps its rail', () {
      debugIsTvOverride = true;
      expect(usesFloatingNav, isFalse);
      expect(sizeWantsNavRail(const Size(1920, 1080)), isTrue);
    });
  });
}
