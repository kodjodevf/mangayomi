library epubreadertest;

import 'package:epubx/src/schema/opf/epub_manifest_item.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubManifestItem()
    ..Fallback = "Some Fallback"
    ..FallbackStyle = "A Very Stylish Fallback"
    ..Href = "Some HREF"
    ..Id = "Some ID"
    ..MediaType = "MKV"
    ..RequiredModules = "nodejs require()"
    ..RequiredNamespace = ".NET Namespace";

  EpubManifestItem testManifestItem;
  setUp(() async {
    testManifestItem = new EpubManifestItem()
      ..Fallback = reference.Fallback
      ..FallbackStyle = reference.FallbackStyle
      ..Href = reference.Href
      ..Id = reference.Id
      ..MediaType = reference.MediaType
      ..RequiredModules = reference.RequiredModules
      ..RequiredNamespace = reference.RequiredNamespace;
  });
  tearDown(() async {
    testManifestItem = null;
  });

  group("EpubManifestItem", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testManifestItem, equals(reference));
      });

      test("is false when Fallback changes", () async {
        testManifestItem.Fallback = "Some Different Fallback";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when FallbackStyle changes", () async {
        testManifestItem.FallbackStyle = "A less than Stylish Fallback";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when Href changes", () async {
        testManifestItem.Href = "A different Href";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when Id changes", () async {
        testManifestItem.Id = "A guarenteed unique Id";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when MediaType changes", () async {
        testManifestItem.MediaType = "RealPlayer";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when RequiredModules changes", () async {
        testManifestItem.RequiredModules = "A non node-js module";
        expect(testManifestItem, isNot(reference));
      });
      test("is false when RequiredNamespaces changes", () async {
        testManifestItem.RequiredNamespace = "Some non-dot net namespace";
        expect(testManifestItem, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testManifestItem.hashCode, equals(reference.hashCode));
      });

      test("is false when Fallback changes", () async {
        testManifestItem.Fallback = "Some Different Fallback";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when FallbackStyle changes", () async {
        testManifestItem.FallbackStyle = "A less than Stylish Fallback";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when Href changes", () async {
        testManifestItem.Href = "A different Href";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when Id changes", () async {
        testManifestItem.Id = "A guarenteed unique Id";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when MediaType changes", () async {
        testManifestItem.MediaType = "RealPlayer";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when RequiredModules changes", () async {
        testManifestItem.RequiredModules = "A non node-js module";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
      test("is false when RequiredNamespaces changes", () async {
        testManifestItem.RequiredNamespace = "Some non-dot net namespace";
        expect(testManifestItem.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
