library epubreadertest;

import 'package:epubx/src/schema/opf/epub_metadata_identifier.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubMetadataIdentifier()
    ..Id = "Unique"
    ..Identifier = "Identifier"
    ..Scheme = "A plot";

  EpubMetadataIdentifier testMetadataIdentifier;
  setUp(() async {
    testMetadataIdentifier = new EpubMetadataIdentifier()
      ..Id = reference.Id
      ..Identifier = reference.Identifier
      ..Scheme = reference.Scheme;
  });
  tearDown(() async {
    testMetadataIdentifier = null;
  });

  group("EpubMetadataIdentifier", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataIdentifier, equals(reference));
      });

      test("is false when Id changes", () async {
        testMetadataIdentifier.Id = "A different ID";
        expect(testMetadataIdentifier, isNot(reference));
      });
      test("is false when Identifier changes", () async {
        testMetadataIdentifier.Identifier = "A different identifier";
        expect(testMetadataIdentifier, isNot(reference));
      });
      test("is false when Scheme changes", () async {
        testMetadataIdentifier.Scheme = "A strange scheme";
        expect(testMetadataIdentifier, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataIdentifier.hashCode, equals(reference.hashCode));
      });

      test("is false when Id changes", () async {
        testMetadataIdentifier.Id = "A different Id";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
      test("is false when Identifier changes", () async {
        testMetadataIdentifier.Identifier = "A different identifier";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
      test("is false when Scheme changes", () async {
        testMetadataIdentifier.Scheme = "A strange scheme";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
