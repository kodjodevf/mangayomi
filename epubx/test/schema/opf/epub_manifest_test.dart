library epubreadertest;

import 'package:epubx/src/schema/opf/epub_manifest.dart';
import 'package:epubx/src/schema/opf/epub_manifest_item.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubManifest();
  reference.Items = [
    new EpubManifestItem()
      ..Fallback = "Some Fallback"
      ..FallbackStyle = "A Very Stylish Fallback"
      ..Href = "Some HREF"
      ..Id = "Some ID"
      ..MediaType = "MKV"
      ..RequiredModules = "nodejs require()"
      ..RequiredNamespace = ".NET Namespace"
  ];

  EpubManifest testManifest;
  setUp(() async {
    testManifest = new EpubManifest()..Items = List.from(reference.Items);
  });
  tearDown(() async {
    testManifest = null;
  });
  group("EpubManifest", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testManifest, equals(reference));
      });

      test("is false when Items changes", () async {
        testManifest.Items.add(new EpubManifestItem()
          ..Fallback = "Some Different Fallback"
          ..FallbackStyle = "A less than Stylish Fallback"
          ..Href = "Some Different HREF"
          ..Id = "Some Different ID"
          ..MediaType = "RealPlayer"
          ..RequiredModules = "require()"
          ..RequiredNamespace = "Namespace");

        expect(testManifest, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testManifest.hashCode, equals(reference.hashCode));
      });

      test("is false when Items changes", () async {
        testManifest.Items.add(new EpubManifestItem()
          ..Fallback = "Some Different Fallback"
          ..FallbackStyle = "A less than Stylish Fallback"
          ..Href = "Some Different HREF"
          ..Id = "Some Different ID"
          ..MediaType = "RealPlayer"
          ..RequiredModules = "require()"
          ..RequiredNamespace = "Namespace");
        expect(testManifest.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
