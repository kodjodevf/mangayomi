library epubreadertest;

import 'package:epubx/src/schema/opf/epub_metadata_creator.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubMetadataCreator()
    ..Creator = "orthros"
    ..FileAs = "Large"
    ..Role = "Creator";

  EpubMetadataCreator testMetadataCreator;
  setUp(() async {
    testMetadataCreator = new EpubMetadataCreator()
      ..Creator = reference.Creator
      ..FileAs = reference.FileAs
      ..Role = reference.Role;
  });
  tearDown(() async {
    testMetadataCreator = null;
  });

  group("EpubMetadataCreator", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataCreator, equals(reference));
      });

      test("is false when Creator changes", () async {
        testMetadataCreator.Creator = "NotOrthros";
        expect(testMetadataCreator, isNot(reference));
      });
      test("is false when FileAs changes", () async {
        testMetadataCreator.FileAs = "Small";
        expect(testMetadataCreator, isNot(reference));
      });
      test("is false when Role changes", () async {
        testMetadataCreator.Role = "Copier";
        expect(testMetadataCreator, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataCreator.hashCode, equals(reference.hashCode));
      });

      test("is false when Creator changes", () async {
        testMetadataCreator.Creator = "NotOrthros";
        expect(testMetadataCreator.hashCode, isNot(reference.hashCode));
      });
      test("is false when FileAs changes", () async {
        testMetadataCreator.FileAs = "Small";
        expect(testMetadataCreator.hashCode, isNot(reference.hashCode));
      });
      test("is false when Role changes", () async {
        testMetadataCreator.Role = "Copier";
        expect(testMetadataCreator.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
