library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/opf/epub_guide_reference.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final RandomDataGenerator generator =
      new RandomDataGenerator(new Random(123778), 10);

  var reference = generator.randomEpubGuideReference();

  EpubGuideReference testGuideReference;
  setUp(() async {
    testGuideReference = new EpubGuideReference();
    testGuideReference
      ..Href = reference.Href
      ..Title = reference.Title
      ..Type = reference.Type;
  });
  tearDown(() async {
    testGuideReference = null;
  });
  group("EpubGuideReference", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference, equals(reference));
      });

      test("is false when Href changes", () async {
        testGuideReference.Href = "A different href";

        expect(testGuideReference, isNot(reference));
      });

      test("is false when Title changes", () async {
        testGuideReference.Title = "A different Title";
        expect(testGuideReference, isNot(reference));
      });

      test("is false when Type changes", () async {
        testGuideReference.Type = "Some different type";
        expect(testGuideReference, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testGuideReference.hashCode, equals(reference.hashCode));
      });

      test("is false when Href changes", () async {
        testGuideReference.Href = "A different href";

        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testGuideReference.Title = "A different Title";
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });

      test("is false when Type changes", () async {
        testGuideReference.Type = "Some different type";
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
