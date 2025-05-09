library epubreadertest;

import 'package:epubx/src/schema/opf/epub_metadata_contributor.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubMetadataContributor()
    ..Contributor = "orthros"
    ..FileAs = "Large"
    ..Role = "Creator";

  EpubMetadataContributor testMetadataContributor;
  setUp(() async {
    testMetadataContributor = new EpubMetadataContributor()
      ..Contributor = reference.Contributor
      ..FileAs = reference.FileAs
      ..Role = reference.Role;
  });
  tearDown(() async {
    testMetadataContributor = null;
  });

  group("EpubMetadataContributor", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataContributor, equals(reference));
      });

      test("is false when Contributor changes", () async {
        testMetadataContributor.Contributor = "NotOrthros";
        expect(testMetadataContributor, isNot(reference));
      });
      test("is false when FileAs changes", () async {
        testMetadataContributor.FileAs = "Small";
        expect(testMetadataContributor, isNot(reference));
      });
      test("is false when Role changes", () async {
        testMetadataContributor.Role = "Copier";
        expect(testMetadataContributor, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataContributor.hashCode, equals(reference.hashCode));
      });

      test("is false when Contributor changes", () async {
        testMetadataContributor.Contributor = "NotOrthros";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
      test("is false when FileAs changes", () async {
        testMetadataContributor.FileAs = "Small";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
      test("is false when Role changes", () async {
        testMetadataContributor.Role = "Copier";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
