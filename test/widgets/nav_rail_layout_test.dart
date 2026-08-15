import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

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
}
