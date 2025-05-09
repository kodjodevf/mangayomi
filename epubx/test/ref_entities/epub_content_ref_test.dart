library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epubx/epub.dart';
import 'package:epubx/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epubx/src/ref_entities/epub_content_ref.dart';
import 'package:epubx/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubContentRef();

  EpubContentRef testContent;
  EpubTextContentFileRef textContentFile;
  EpubByteContentFileRef byteContentFile;

  setUp(() async {
    var arch = new Archive();
    var refBook = new EpubBookRef(arch);

    testContent = new EpubContentRef();

    textContentFile = new EpubTextContentFileRef(refBook)
      ..ContentMimeType = "application/text"
      ..ContentType = EpubContentType.OTHER
      ..FileName = "orthros.txt";

    byteContentFile = new EpubByteContentFileRef(refBook)
      ..ContentMimeType = "application/orthros"
      ..ContentType = EpubContentType.OTHER
      ..FileName = "orthros.bin";
  });

  tearDown(() async {
    testContent = null;
    textContentFile = null;
    byteContentFile = null;
  });
  group("EpubContentRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testContent, equals(reference));
      });

      test("is false when Html changes", () async {
        testContent.Html["someKey"] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Css changes", () async {
        testContent.Css["someKey"] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Images changes", () async {
        testContent.Images["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Fonts changes", () async {
        testContent.Fonts["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when AllFiles changes", () async {
        testContent.AllFiles["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test("is false when Html changes", () async {
        testContent.Html["someKey"] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Css changes", () async {
        testContent.Css["someKey"] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Images changes", () async {
        testContent.Images["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Fonts changes", () async {
        testContent.Fonts["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when AllFiles changes", () async {
        testContent.AllFiles["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
