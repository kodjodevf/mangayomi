library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/navigation/epub_navigation_head_meta.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final generator = new RandomDataGenerator(new Random(7898), 10);
  final EpubNavigationHeadMeta reference = generator.randomNavigationHeadMeta();

  EpubNavigationHeadMeta testNavigationDocTitle;
  setUp(() async {
    testNavigationDocTitle = new EpubNavigationHeadMeta()
      ..Content = reference.Content
      ..Name = reference.Name
      ..Scheme = reference.Scheme;
  });
  tearDown(() async {
    testNavigationDocTitle = null;
  });

  group("EpubNavigationHeadMeta", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationDocTitle, equals(reference));
      });

      test("is false when Content changes", () async {
        testNavigationDocTitle.Content = generator.randomString();
        expect(testNavigationDocTitle, isNot(reference));
      });
      test("is false when Name changes", () async {
        testNavigationDocTitle.Name = generator.randomString();
        expect(testNavigationDocTitle, isNot(reference));
      });
      test("is false when Scheme changes", () async {
        testNavigationDocTitle.Scheme = generator.randomString();
        expect(testNavigationDocTitle, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationDocTitle.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        testNavigationDocTitle.Content = generator.randomString();
        expect(testNavigationDocTitle.hashCode, isNot(reference.hashCode));
      });
      test("is false when Name changes", () async {
        testNavigationDocTitle.Name = generator.randomString();
        expect(testNavigationDocTitle.hashCode, isNot(reference.hashCode));
      });
      test("is false when Scheme changes", () async {
        testNavigationDocTitle.Scheme = generator.randomString();
        expect(testNavigationDocTitle.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
