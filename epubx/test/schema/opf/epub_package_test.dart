library epubreadertest;

import 'dart:math';

import 'package:epubx/epub.dart';
import 'package:epubx/src/schema/opf/epub_version.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final int length = 10;

  final RandomDataGenerator generator =
      new RandomDataGenerator(new Random(123778), length);

  var reference = generator.randomEpubPackage()..Version = EpubVersion.Epub3;

  EpubPackage testPackage;
  setUp(() async {
    testPackage = new EpubPackage()
      ..Guide = reference.Guide
      ..Manifest = reference.Manifest
      ..Metadata = reference.Metadata
      ..Spine = reference.Spine
      ..Version = reference.Version;
  });
  tearDown(() async {
    testPackage = null;
  });

  group("EpubSpine", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testPackage, equals(reference));
      });
      test("is false when Guide changes", () async {
        testPackage.Guide = generator.randomEpubGuide();
        expect(testPackage, isNot(reference));
      });
      test("is false when Manifest changes", () async {
        testPackage.Manifest = generator.randomEpubManifest();
        expect(testPackage, isNot(reference));
      });
      test("is false when Metadata changes", () async {
        testPackage.Metadata = generator.randomEpubMetadata();
        expect(testPackage, isNot(reference));
      });
      test("is false when Spine changes", () async {
        testPackage.Spine = generator.randomEpubSpine();
        expect(testPackage, isNot(reference));
      });
      test("is false when Version changes", () async {
        testPackage.Version = testPackage.Version == EpubVersion.Epub2
            ? EpubVersion.Epub3
            : EpubVersion.Epub2;
        expect(testPackage, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testPackage.hashCode, equals(reference.hashCode));
      });
      test("is false when Guide changes", () async {
        testPackage.Guide = generator.randomEpubGuide();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Manifest changes", () async {
        testPackage.Manifest = generator.randomEpubManifest();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Metadata changes", () async {
        testPackage.Metadata = generator.randomEpubMetadata();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Spine changes", () async {
        testPackage.Spine = generator.randomEpubSpine();
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
      test("is false when Version changes", () async {
        testPackage.Version = testPackage.Version == EpubVersion.Epub2
            ? EpubVersion.Epub3
            : EpubVersion.Epub2;
        expect(testPackage.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
