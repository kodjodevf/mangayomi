library epubreadertest;

import 'package:epubx/src/schema/opf/epub_metadata_meta.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubMetadataMeta()
    ..Content = "some content"
    ..Name = "Orthros"
    ..Property = "Prop"
    ..Refines = "Oil"
    ..Id = "Unique"
    ..Scheme = "A plot";

  EpubMetadataMeta testMetadataMeta;
  setUp(() async {
    testMetadataMeta = new EpubMetadataMeta()
      ..Content = reference.Content
      ..Name = reference.Name
      ..Property = reference.Property
      ..Refines = reference.Refines
      ..Id = reference.Id
      ..Scheme = reference.Scheme;
  });
  tearDown(() async {
    testMetadataMeta = null;
  });

  group("EpubMetadataMeta", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataMeta, equals(reference));
      });

      test("is false when Refines changes", () async {
        testMetadataMeta.Refines = "Natural gas";
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Property changes", () async {
        testMetadataMeta.Property = "A different Property";
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Name changes", () async {
        testMetadataMeta.Id = "notOrthros";
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Content changes", () async {
        testMetadataMeta.Content = "A different Content";
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Id changes", () async {
        testMetadataMeta.Id = "A different ID";
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Scheme changes", () async {
        testMetadataMeta.Scheme = "A strange scheme";
        expect(testMetadataMeta, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataMeta.hashCode, equals(reference.hashCode));
      });
      test("is false when Refines changes", () async {
        testMetadataMeta.Refines = "Natural Gas";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Property changes", () async {
        testMetadataMeta.Property = "A different property";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Name changes", () async {
        testMetadataMeta.Name = "NotOrthros";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Content changes", () async {
        testMetadataMeta.Content = "Different Content";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Id changes", () async {
        testMetadataMeta.Id = "A different Id";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Scheme changes", () async {
        testMetadataMeta.Scheme = "A strange scheme";
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
