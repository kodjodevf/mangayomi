library epubreadertest;

import 'package:epubx/epub.dart';
import 'package:epubx/src/entities/epub_schema.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubBook();
  reference
    ..Author = "orthros"
    ..AuthorList = ["orthros"]
    ..Chapters = [new EpubChapter()]
    ..Content = new EpubContent()
    ..CoverImage = Image(100, 100)
    ..Schema = new EpubSchema()
    ..Title = "A Dissertation on Epubs";

  EpubBook testBook;
  setUp(() async {
    testBook = new EpubBook();
    testBook
      ..Author = "orthros"
      ..AuthorList = ["orthros"]
      ..Chapters = [new EpubChapter()]
      ..Content = new EpubContent()
      ..CoverImage = Image(100, 100)
      ..Schema = new EpubSchema()
      ..Title = "A Dissertation on Epubs";
  });
  tearDown(() async {
    testBook = null;
  });
  group("EpubBook", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBook, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFile();
        file
          ..Content = "Hello"
          ..ContentMimeType = "application/txt"
          ..ContentType = EpubContentType.OTHER
          ..FileName = "orthros.txt";

        EpubContent content = new EpubContent();
        content.AllFiles["hello"] = file;
        testBook.Content = content;

        expect(testBook, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBook.Author = "NotOrthros";
        expect(testBook, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBook.AuthorList = ["NotOrthros"];
        expect(testBook, isNot(reference));
      });

      test("is false when Chapters changes", () async {
        var chapter = new EpubChapter();
        chapter
          ..Title = "A Brave new Epub"
          ..ContentFileName = "orthros.txt";
        testBook.Chapters = [chapter];
        expect(testBook, isNot(reference));
      });

      test("is false when CoverImage changes", () async {
        testBook.CoverImage = new Image(200, 200);
        expect(testBook, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var schema = new EpubSchema();
        schema.ContentDirectoryPath = "some/random/path";
        testBook.Schema = schema;
        expect(testBook, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBook.Title = "The Philosophy of Epubs";
        expect(testBook, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = new EpubTextContentFile();
        file
          ..Content = "Hello"
          ..ContentMimeType = "application/txt"
          ..ContentType = EpubContentType.OTHER
          ..FileName = "orthros.txt";

        EpubContent content = new EpubContent();
        content.AllFiles["hello"] = file;
        testBook.Content = content;

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Author changes", () async {
        testBook.Author = "NotOrthros";
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBook.AuthorList = ["NotOrthros"];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Chapters changes", () async {
        var chapter = new EpubChapter();
        chapter
          ..Title = "A Brave new Epub"
          ..ContentFileName = "orthros.txt";
        testBook.Chapters = [chapter];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when CoverImage changes", () async {
        testBook.CoverImage = new Image(200, 200);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Schema changes", () async {
        var schema = new EpubSchema();
        schema.ContentDirectoryPath = "some/random/path";
        testBook.Schema = schema;
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBook.Title = "The Philosophy of Epubs";
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
