library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epubx/epub.dart';
import 'package:epubx/src/entities/epub_schema.dart';
import 'package:epubx/src/ref_entities/epub_content_ref.dart';
import 'package:epubx/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = new Archive();
  var reference = new EpubBookRef(arch);
  reference
    ..Author = "orthros"
    ..AuthorList = ["orthros"]
    ..Schema = new EpubSchema()
    ..Title = "A Dissertation on Epubs";

  EpubBookRef testBookRef;
  setUp(() async {
    testBookRef = new EpubBookRef(arch);
    testBookRef
      ..Author = "orthros"
      ..AuthorList = ["orthros"]
      ..Schema = new EpubSchema()
      ..Title = "A Dissertation on Epubs";
  });
  tearDown(() async {
    testBookRef = null;
  });
  group("EpubBookRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFileRef(testBookRef);
        file
          ..ContentMimeType = "application/txt"
          ..ContentType = EpubContentType.OTHER
          ..FileName = "orthros.txt";

        EpubContentRef content = new EpubContentRef();
        content.AllFiles["hello"] = file;

        testBookRef.Content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef.Author = "NotOrthros";
        expect(testBookRef, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBookRef.AuthorList = ["NotOrthros"];
        expect(testBookRef, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var schema = new EpubSchema();
        schema.ContentDirectoryPath = "some/random/path";
        testBookRef.Schema = schema;
        expect(testBookRef, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBookRef.Title = "The Philosophy of Epubs";
        expect(testBookRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFileRef(testBookRef);
        file
          ..ContentMimeType = "application/txt"
          ..ContentType = EpubContentType.OTHER
          ..FileName = "orthros.txt";

        EpubContentRef content = new EpubContentRef();
        content.AllFiles["hello"] = file;

        testBookRef.Content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef.Author = "NotOrthros";
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBookRef.AuthorList = ["NotOrthros"];
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
      test("is false when Schema changes", () async {
        var schema = new EpubSchema();
        schema.ContentDirectoryPath = "some/random/path";
        testBookRef.Schema = schema;
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBookRef.Title = "The Philosophy of Epubs";
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
