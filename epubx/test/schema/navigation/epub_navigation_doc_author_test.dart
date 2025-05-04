library epubreadertest;

import 'dart:math';

import 'package:epubx/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final generator = new RandomDataGenerator(new Random(7898), 10);
  final EpubNavigationDocAuthor reference =
      generator.randomNavigationDocAuthor();

  EpubNavigationDocAuthor testNavigationDocAuthor;
  setUp(() async {
    testNavigationDocAuthor = new EpubNavigationDocAuthor()
      ..Authors = List.from(reference.Authors);
  });
  tearDown(() async {
    testNavigationDocAuthor = null;
  });

  group("EpubNavigationDocAuthor", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationDocAuthor, equals(reference));
      });

      test("is false when Authors changes", () async {
        testNavigationDocAuthor.Authors.add(generator.randomString());
        expect(testNavigationDocAuthor, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testNavigationDocAuthor.hashCode, equals(reference.hashCode));
      });

      test("is false when Authors changes", () async {
        testNavigationDocAuthor.Authors.add(generator.randomString());
        expect(testNavigationDocAuthor.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
