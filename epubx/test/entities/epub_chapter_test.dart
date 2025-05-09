library epubreadertest;

import 'package:epubx/epub.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubChapter();
  reference
    ..Anchor = "anchor"
    ..ContentFileName = "orthros"
    ..HtmlContent = "<html></html>"
    ..SubChapters = []
    ..Title = "A New Look at Chapters";

  EpubChapter testChapter;
  setUp(() async {
    testChapter = new EpubChapter();
    testChapter
      ..Anchor = "anchor"
      ..ContentFileName = "orthros"
      ..HtmlContent = "<html></html>"
      ..SubChapters = []
      ..Title = "A New Look at Chapters";
  });
  tearDown(() async {
    testChapter = null;
  });
  group("EpubChapter", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testChapter, equals(reference));
      });

      test("is false when HtmlContent changes", () async {
        testChapter.HtmlContent = "<html>I'm sure this isn't valid Html</html>";
        expect(testChapter, isNot(reference));
      });

      test("is false when Anchor changes", () async {
        testChapter.Anchor = "NotAnAnchor";
        expect(testChapter, isNot(reference));
      });

      test("is false when ContentFileName changes", () async {
        testChapter.ContentFileName = "NotOrthros";
        expect(testChapter, isNot(reference));
      });

      test("is false when SubChapters changes", () async {
        var chapter = new EpubChapter();
        chapter
          ..Title = "A Brave new Epub"
          ..ContentFileName = "orthros.txt";
        testChapter.SubChapters = [chapter];
        expect(testChapter, isNot(reference));
      });

      test("is false when Title changes", () async {
        testChapter.Title = "A Boring Old World";
        expect(testChapter, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testChapter.hashCode, equals(reference.hashCode));
      });

      test("is true for equivalent objects", () async {
        expect(testChapter.hashCode, equals(reference.hashCode));
      });

      test("is false when HtmlContent changes", () async {
        testChapter.HtmlContent = "<html>I'm sure this isn't valid Html</html>";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Anchor changes", () async {
        testChapter.Anchor = "NotAnAnchor";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentFileName changes", () async {
        testChapter.ContentFileName = "NotOrthros";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when SubChapters changes", () async {
        var chapter = new EpubChapter();
        chapter
          ..Title = "A Brave new Epub"
          ..ContentFileName = "orthros.txt";
        testChapter.SubChapters = [chapter];
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testChapter.Title = "A Boring Old World";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
