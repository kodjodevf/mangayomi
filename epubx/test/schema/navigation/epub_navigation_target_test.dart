library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/navigation/epub_navigation_target.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final RandomDataGenerator generator =
      new RandomDataGenerator(new Random(123778), 10);

  final EpubNavigationTarget reference = generator.randomEpubNavigationTarget();

  EpubNavigationTarget testNavigationTarget;
  setUp(() async {
    testNavigationTarget = new EpubNavigationTarget()
      ..Class = reference.Class
      ..Content = reference.Content
      ..Id = reference.Id
      ..NavigationLabels = List.from(reference.NavigationLabels)
      ..PlayOrder = reference.PlayOrder
      ..Value = reference.Value;
  });
  tearDown(() async {
    testNavigationTarget = null;
  });
  group("EpubNavigationTarget", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationTarget, equals(reference));
      });

      test("is false when Class changes", () async {
        testNavigationTarget.Class = generator.randomString();
        expect(testNavigationTarget, isNot(reference));
      });
      test("is false when Content changes", () async {
        testNavigationTarget.Content = generator.randomEpubNavigationContent();
        expect(testNavigationTarget, isNot(reference));
      });
      test("is false when Id changes", () async {
        testNavigationTarget.Id = generator.randomString();
        expect(testNavigationTarget, isNot(reference));
      });
      test("is false when NavigationLabels changes", () async {
        testNavigationTarget.NavigationLabels = [
          generator.randomEpubNavigationLabel()
        ];
        expect(testNavigationTarget, isNot(reference));
      });
      test("is false when PlayOrder changes", () async {
        testNavigationTarget.PlayOrder = generator.randomString();
        expect(testNavigationTarget, isNot(reference));
      });
      test("is false when Value changes", () async {
        testNavigationTarget.Value = generator.randomString();
        expect(testNavigationTarget, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationTarget.hashCode, equals(reference.hashCode));
      });

      test("is false when Class changes", () async {
        testNavigationTarget.Class = generator.randomString();
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
      test("is false when Content changes", () async {
        testNavigationTarget.Content = generator.randomEpubNavigationContent();
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
      test("is false when Id changes", () async {
        testNavigationTarget.Id = generator.randomString();
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
      test("is false when NavigationLabels changes", () async {
        testNavigationTarget.NavigationLabels = [
          generator.randomEpubNavigationLabel()
        ];
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
      test("is false when PlayOrder changes", () async {
        testNavigationTarget.PlayOrder = generator.randomString();
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
      test("is false when Value changes", () async {
        testNavigationTarget.Value = generator.randomString();
        expect(testNavigationTarget.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
