library epubreadertest;

import 'package:epubx/epub.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubTextContentFile();
  reference
    ..Content = "Hello"
    ..ContentMimeType = "application/test"
    ..ContentType = EpubContentType.OTHER
    ..FileName = "orthrosFile";
  EpubTextContentFile testFile;
  setUp(() async {
    testFile = new EpubTextContentFile();
    testFile
      ..Content = "Hello"
      ..ContentMimeType = "application/test"
      ..ContentType = EpubContentType.OTHER
      ..FileName = "orthrosFile";
  });
  tearDown(() async {
    testFile = null;
  });
  group("EpubTextContentFile", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFile, equals(reference));
      });

      test("is false when Content changes", () async {
        testFile.Content = "Goodbye";
        expect(testFile, isNot(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFile.ContentMimeType = "application/different";
        expect(testFile, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFile.ContentType = EpubContentType.CSS;
        expect(testFile, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFile.FileName = "a_different_file_name.txt";
        expect(testFile, isNot(reference));
      });
    });
    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFile.hashCode, equals(reference.hashCode));
      });

      test('changes when Content changes', () async {
        testFile.Content = "Goodbye";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile.ContentMimeType = "application/orthros";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile.ContentType = EpubContentType.CSS;
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile.FileName = "a_different_file_name";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
