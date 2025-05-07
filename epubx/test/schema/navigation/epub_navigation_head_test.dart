library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/navigation/epub_navigation_head.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final RandomDataGenerator generator =
      new RandomDataGenerator(new Random(123778), 10);

  final EpubNavigationHead reference = generator.randomEpubNavigationHead();

  EpubNavigationHead testGuideReference;
  setUp(() async {
    testGuideReference = new EpubNavigationHead()
      ..Metadata = List.from(reference.Metadata);
  });
  tearDown(() async {
    testGuideReference = null;
  });
  group("EpubNavigationHead", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference, equals(reference));
      });

      test("is false when Metadata changes", () async {
        testGuideReference.Metadata.add(generator.randomNavigationHeadMeta());
        expect(testGuideReference, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference.hashCode, equals(reference.hashCode));
      });

      test("is false when Metadata changes", () async {
        testGuideReference.Metadata.add(generator.randomNavigationHeadMeta());
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
