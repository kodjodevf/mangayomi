library epubreadertest;

import 'package:epubx/epub.dart';
import 'package:epubx/src/entities/epub_schema.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epubx/src/schema/opf/epub_guide.dart';
import 'package:epubx/src/schema/opf/epub_version.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubSchema();
  reference
    ..Package = new EpubPackage()
    ..Navigation = new EpubNavigation()
    ..ContentDirectoryPath = "some/random/path";
  reference.Package.Version = EpubVersion.Epub2;

  EpubSchema testSchema;
  setUp(() async {
    testSchema = new EpubSchema();
    testSchema
      ..Package = new EpubPackage()
      ..Navigation = new EpubNavigation()
      ..ContentDirectoryPath = "some/random/path";
    testSchema.Package.Version = EpubVersion.Epub2;
  });
  tearDown(() async {
    testSchema = null;
  });
  group("EpubSchema", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSchema, equals(reference));
      });

      test("is false when Package changes", () async {
        var package = new EpubPackage()
          ..Guide = new EpubGuide()
          ..Version = EpubVersion.Epub3;

        testSchema.Package = package;
        expect(testSchema, isNot(reference));
      });

      test("is false when Navigation changes", () async {
        testSchema.Navigation = new EpubNavigation()
          ..DocTitle = new EpubNavigationDocTitle()
          ..DocAuthors = [new EpubNavigationDocAuthor()];

        expect(testSchema, isNot(reference));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema.ContentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test("is false when Package changes", () async {
        var package = new EpubPackage()
          ..Guide = new EpubGuide()
          ..Version = EpubVersion.Epub3;

        testSchema.Package = package;
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when Navigation changes", () async {
        testSchema.Navigation = new EpubNavigation()
          ..DocTitle = new EpubNavigationDocTitle()
          ..DocAuthors = [new EpubNavigationDocAuthor()];

        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema.ContentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
