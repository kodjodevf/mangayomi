library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/opf/epub_spine.dart';
import 'package:epubx/src/schema/opf/epub_spine_item_ref.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final int length = 10;
  final RandomString randomString = new RandomString(new Random(123788));

  var reference = new EpubSpine()
    ..Items = [
      new EpubSpineItemRef()
        ..IdRef = randomString.randomAlpha(length)
        ..IdRef = randomString.randomAlpha(length)
    ]
    ..TableOfContents = randomString.randomAlpha(length);

  EpubSpine testSpine;
  setUp(() async {
    testSpine = new EpubSpine()
      ..Items = List.from(reference.Items)
      ..TableOfContents = reference.TableOfContents;
  });
  tearDown(() async {
    testSpine = null;
  });

  group("EpubSpine", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSpine, equals(reference));
      });
      test("is false when Items changes", () async {
        testSpine.Items = [
          new EpubSpineItemRef()
            ..IdRef = randomString.randomAlpha(length)
            ..IsLinear = false
        ];
        expect(testSpine, isNot(reference));
      });
      test("is false when TableOfContents changes", () async {
        testSpine.TableOfContents = randomString.randomAlpha(length);
        expect(testSpine, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSpine.hashCode, equals(reference.hashCode));
      });
      test("is false when IsLinear changes", () async {
        testSpine.Items = [
          new EpubSpineItemRef()
            ..IdRef = randomString.randomAlpha(length)
            ..IsLinear = false
        ];
        expect(testSpine.hashCode, isNot(reference.hashCode));
      });
      test("is false when TableOfContents changes", () async {
        testSpine.TableOfContents = randomString.randomAlpha(length);
        expect(testSpine.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
