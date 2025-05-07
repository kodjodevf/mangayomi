library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/navigation/epub_navigation_point.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final generator = new RandomDataGenerator(new Random(7898), 10);
  final EpubNavigationPoint reference = generator.randomEpubNavigationPoint(1);

  EpubNavigationPoint testNavigationPoint;
  setUp(() async {
    testNavigationPoint = new EpubNavigationPoint()
      ..ChildNavigationPoints = List.from(reference.ChildNavigationPoints)
      ..Class = reference.Class
      ..Content = reference.Content
      ..Id = reference.Id
      ..NavigationLabels = List.from(reference.NavigationLabels)
      ..PlayOrder = reference.PlayOrder;
  });
  tearDown(() async {
    testNavigationPoint = null;
  });

  group("EpubNavigationPoint", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationPoint, equals(reference));
      });

      test("is false when ChildNavigationPoints changes", () async {
        testNavigationPoint.ChildNavigationPoints.add(
            generator.randomEpubNavigationPoint());
        expect(testNavigationPoint, isNot(reference));
      });
      test("is false when Class changes", () async {
        testNavigationPoint.Class = generator.randomString();
        expect(testNavigationPoint, isNot(reference));
      });
      test("is false when Content changes", () async {
        testNavigationPoint.Content = generator.randomEpubNavigationContent();
        expect(testNavigationPoint, isNot(reference));
      });
      test("is false when Id changes", () async {
        testNavigationPoint.Id = generator.randomString();
        expect(testNavigationPoint, isNot(reference));
      });
      test("is false when PlayOrder changes", () async {
        testNavigationPoint.PlayOrder = generator.randomString();
        expect(testNavigationPoint, isNot(reference));
      });
      test("is false when NavigationLabels changes", () async {
        testNavigationPoint.NavigationLabels.add(
            generator.randomEpubNavigationLabel());
        expect(testNavigationPoint, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationPoint.hashCode, equals(reference.hashCode));
      });

      test("is false when ChildNavigationPoints changes", () async {
        testNavigationPoint.ChildNavigationPoints.add(
            generator.randomEpubNavigationPoint());
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
      test("is false when Class changes", () async {
        testNavigationPoint.Class = generator.randomString();
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
      test("is false when Content changes", () async {
        testNavigationPoint.Content = generator.randomEpubNavigationContent();
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
      test("is false when Id changes", () async {
        testNavigationPoint.Id = generator.randomString();
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
      test("is false when PlayOrder changes", () async {
        testNavigationPoint.PlayOrder = generator.randomString();
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
      test("is false when NavigationLabels changes", () async {
        testNavigationPoint.NavigationLabels.add(
            generator.randomEpubNavigationLabel());
        expect(testNavigationPoint.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
