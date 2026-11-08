import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

void main() {
  group('compareVersions Tests', () {
    test('standard semver comparisons', () {
      expect(compareVersions('0.9.1', '0.9.1'), equals(0));
      expect(compareVersions('0.9.1', '0.9.2'), equals(-1));
      expect(compareVersions('0.9.2', '0.9.1'), equals(1));
      expect(compareVersions('0.9.1', '1.0.0'), equals(-1));
      expect(compareVersions('1.0.0', '0.9.1'), equals(1));
    });

    test('multi-digit segment comparison (0.9.1 vs 0.10.0)', () {
      // Critical regression test: 9 must be less than 10
      expect(compareVersions('0.9.1', '0.10.0'), equals(-1));
      expect(compareVersions('0.10.0', '0.9.1'), equals(1));
      expect(compareVersions('0.2', '0.11'), equals(-1));
      expect(compareVersions('0.11', '0.2'), equals(1));
      expect(compareVersions('0.100.0', '0.99.9'), equals(1));
    });

    test('different segment lengths', () {
      expect(compareVersions('0.9', '0.9.0'), equals(0));
      expect(compareVersions('0.9.0', '0.9'), equals(0));
      expect(compareVersions('0.9.1', '0.9.1.1'), equals(-1));
      expect(compareVersions('0.9.1.1', '0.9.1'), equals(1));
      expect(compareVersions('1', '1.0.0.0'), equals(0));
    });

    test('handles leading v or V prefix', () {
      expect(compareVersions('v0.9.1', '0.9.1'), equals(0));
      expect(compareVersions('V0.9.1', 'v0.9.1'), equals(0));
      expect(compareVersions('v0.9.1', 'v0.10.0'), equals(-1));
      expect(compareVersions('v0.10.0', 'v0.9.1'), equals(1));
    });

    test('handles build metadata and pre-release suffixes', () {
      expect(compareVersions('0.9.1+119', '0.9.1'), equals(0));
      expect(compareVersions('0.9.1+119', '0.10.0'), equals(-1));
      expect(compareVersions('v0.9.1-alpha.1', '0.9.2'), equals(-1));
      expect(
        compareVersions('0.9.1-beta.1+119', '0.9.1-beta.1+120'),
        equals(0),
      );
    });

    test('a pre-release comes before its final version', () {
      expect(compareVersions('1.0.0-beta.1', '1.0.0'), equals(-1));
      expect(compareVersions('1.0.0', '1.0.0-beta.1'), equals(1));
      expect(compareVersions('v1.0.0-beta.1', '1.0.0+128'), equals(-1));
      expect(compareVersions('1.0.0-beta.1', '0.9.95'), equals(1));
      expect(compareVersions('0.9.95', '0.9.9'), equals(1));
    });

    test('orders pre-releases between themselves', () {
      expect(compareVersions('1.0.0-beta.1', '1.0.0-beta.1'), equals(0));
      expect(compareVersions('1.0.0-beta.1', '1.0.0-beta.2'), equals(-1));
      expect(compareVersions('1.0.0-beta.2', '1.0.0-beta.10'), equals(-1));
      expect(compareVersions('1.0.0-alpha.2', '1.0.0-beta.1'), equals(-1));
      expect(compareVersions('1.0.0-beta.9', '1.0.0-rc.1'), equals(-1));
      expect(compareVersions('1.0.0-beta', '1.0.0-beta.1'), equals(-1));
      expect(compareVersions('1.0.0-1', '1.0.0-beta'), equals(-1));
      expect(compareVersions('1.0.0-BETA.1', '1.0.0-beta.1'), equals(0));
    });

    test('handles whitespace gracefully', () {
      expect(compareVersions(' 0.9.1 ', '0.9.1'), equals(0));
      expect(compareVersions(' v0.9.1 ', ' 0.10.0 '), equals(-1));
    });
  });
}
