import 'dart:math' show Random;

import 'package:epubx/epub.dart';
import 'package:epubx/src/schema/navigation/epub_metadata.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_head.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_head_meta.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_label.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_point.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_target.dart';
import 'package:epubx/src/schema/opf/epub_guide.dart';
import 'package:epubx/src/schema/opf/epub_guide_reference.dart';
import 'package:epubx/src/schema/opf/epub_manifest.dart';
import 'package:epubx/src/schema/opf/epub_manifest_item.dart';
import 'package:epubx/src/schema/opf/epub_metadata.dart';
import 'package:epubx/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epubx/src/schema/opf/epub_metadata_creator.dart';
import 'package:epubx/src/schema/opf/epub_metadata_date.dart';
import 'package:epubx/src/schema/opf/epub_metadata_identifier.dart';
import 'package:epubx/src/schema/opf/epub_metadata_meta.dart';
import 'package:epubx/src/schema/opf/epub_spine.dart';
import 'package:epubx/src/schema/opf/epub_spine_item_ref.dart';
import 'package:epubx/src/schema/opf/epub_version.dart';

class RandomString {
  final Random rng;

  RandomString(this.rng) {}

  static const ASCII_START = 33;
  static const ASCII_END = 126;
  static const NUMERIC_START = 48;
  static const NUMERIC_END = 57;
  static const LOWER_ALPHA_START = 97;
  static const LOWER_ALPHA_END = 122;
  static const UPPER_ALPHA_START = 65;
  static const UPPER_ALPHA_END = 90;

  /// Generates a random integer where [from] <= [to].
  int randomBetween(int from, int to) {
    if (from > to) throw new Exception('$from is not > $to');
    return ((to - from) * rng.nextDouble()).toInt() + from;
  }

  /// Generates a random string of [length] with characters
  /// between ascii [from] to [to].
  /// Defaults to characters of ascii '!' to '~'.
  String randomString(int length, {int from: ASCII_START, int to: ASCII_END}) {
    return new String.fromCharCodes(
        new List.generate(length, (index) => randomBetween(from, to)));
  }

  /// Generates a random string of [length] with only numeric characters.
  String randomNumeric(int length) =>
      randomString(length, from: NUMERIC_START, to: NUMERIC_END);

  /// Generates a random string of [length] with only alpha characters.
  String randomAlpha(int length) {
    var lowerAlphaLength = randomBetween(0, length);
    var upperAlphaLength = length - lowerAlphaLength;
    var lowerAlpha = randomString(lowerAlphaLength,
        from: LOWER_ALPHA_START, to: LOWER_ALPHA_END);
    var upperAlpha = randomString(upperAlphaLength,
        from: UPPER_ALPHA_START, to: UPPER_ALPHA_END);
    return randomMerge(lowerAlpha, upperAlpha);
  }

  /// Generates a random string of [length] with alpha-numeric characters.
  String randomAlphaNumeric(int length) {
    var alphaLength = randomBetween(0, length);
    var numericLength = length - alphaLength;
    var alpha = randomAlpha(alphaLength);
    var numeric = randomNumeric(numericLength);
    return randomMerge(alpha, numeric);
  }

  /// Merge [a] with [b] and scramble characters.
  String randomMerge(String a, String b) {
    List<int> mergedCodeUnits = new List.from("$a$b".codeUnits);
    mergedCodeUnits.shuffle(rng);
    return new String.fromCharCodes(mergedCodeUnits);
  }
}

class RandomDataGenerator {
  final Random rng;
  RandomString _randomString;
  final int _length;

  RandomDataGenerator(this.rng, this._length) {
    _randomString = new RandomString(rng);
  }

  String randomString() {
    return _randomString.randomAlphaNumeric(_length);
  }

  EpubNavigationPoint randomEpubNavigationPoint([int depth = 0]) {
    return new EpubNavigationPoint()
      ..PlayOrder = randomString()
      ..NavigationLabels = [randomEpubNavigationLabel()]
      ..Id = randomString()
      ..Content = randomEpubNavigationContent()
      ..Class = randomString()
      ..ChildNavigationPoints = depth > 0
          ? [randomEpubNavigationPoint(depth - 1)]
          : new List<EpubNavigationPoint>();
  }

  EpubNavigationContent randomEpubNavigationContent() {
    return new EpubNavigationContent()
      ..Id = randomString()
      ..Source = randomString();
  }

  EpubNavigationTarget randomEpubNavigationTarget() {
    return new EpubNavigationTarget()
      ..Class = randomString()
      ..Content = randomEpubNavigationContent()
      ..Id = randomString()
      ..NavigationLabels = [randomEpubNavigationLabel()]
      ..PlayOrder = randomString()
      ..Value = randomString();
  }

  EpubNavigationLabel randomEpubNavigationLabel() {
    return new EpubNavigationLabel()..Text = randomString();
  }

  EpubNavigationHead randomEpubNavigationHead() {
    return new EpubNavigationHead()..Metadata = [randomNavigationHeadMeta()];
  }

  EpubNavigationHeadMeta randomNavigationHeadMeta() {
    return new EpubNavigationHeadMeta()
      ..Content = randomString()
      ..Name = randomString()
      ..Scheme = randomString();
  }

  EpubNavigationDocTitle randomNavigationDocTitle() {
    return new EpubNavigationDocTitle()..Titles = [randomString()];
  }

  EpubNavigationDocAuthor randomNavigationDocAuthor() {
    return new EpubNavigationDocAuthor()..Authors = [randomString()];
  }

  EpubPackage randomEpubPackage() {
    return new EpubPackage()
      ..Guide = randomEpubGuide()
      ..Manifest = randomEpubManifest()
      ..Metadata = randomEpubMetadata()
      ..Spine = randomEpubSpine()
      ..Version = rng.nextBool() ? EpubVersion.Epub2 : EpubVersion.Epub3;
  }

  EpubSpine randomEpubSpine() {
    var reference = new EpubSpine()
      ..Items = [randomEpubSpineItemRef()]
      ..TableOfContents = _randomString.randomAlpha(_length);
    return reference;
  }

  EpubSpineItemRef randomEpubSpineItemRef() {
    return new EpubSpineItemRef()
      ..IdRef = _randomString.randomAlpha(_length)
      ..IdRef = _randomString.randomAlpha(_length);
  }

  EpubManifest randomEpubManifest() {
    var reference = new EpubManifest();
    reference.Items = [randomEpubManifestItem()];
    return reference;
  }

  EpubManifestItem randomEpubManifestItem() {
    return new EpubManifestItem()
      ..Fallback = _randomString.randomAlpha(_length)
      ..FallbackStyle = _randomString.randomAlpha(_length)
      ..Href = _randomString.randomAlpha(_length)
      ..Id = _randomString.randomAlpha(_length)
      ..MediaType = _randomString.randomAlpha(_length)
      ..RequiredModules = _randomString.randomAlpha(_length)
      ..RequiredNamespace = _randomString.randomAlpha(_length);
  }

  EpubGuide randomEpubGuide() {
    var reference = new EpubGuide();
    reference.Items = [randomEpubGuideReference()];
    return reference;
  }

  EpubGuideReference randomEpubGuideReference() {
    return new EpubGuideReference()
      ..Href = _randomString.randomAlpha(_length)
      ..Title = _randomString.randomAlpha(_length)
      ..Type = _randomString.randomAlpha(_length);
  }

  EpubMetadata randomEpubMetadata() {
    var reference = new EpubMetadata()
      ..Contributors = [randomEpubMetadataContributor()]
      ..Coverages = [_randomString.randomAlpha(_length)]
      ..Creators = [randomEpubMetadataCreator()]
      ..Dates = [randomEpubMetadataDate()]
      ..Description = _randomString.randomAlpha(_length)
      ..Formats = [_randomString.randomAlpha(_length)]
      ..Identifiers = [randomEpubMetadataIdentifier()]
      ..Languages = [_randomString.randomAlpha(_length)]
      ..MetaItems = [randomEpubMetadataMeta()]
      ..Publishers = [_randomString.randomAlpha(_length)]
      ..Relations = [_randomString.randomAlpha(_length)]
      ..Rights = [_randomString.randomAlpha(_length)]
      ..Sources = [_randomString.randomAlpha(_length)]
      ..Subjects = [_randomString.randomAlpha(_length)]
      ..Titles = [_randomString.randomAlpha(_length)]
      ..Types = [_randomString.randomAlpha(_length)];

    return reference;
  }

  EpubMetadataMeta randomEpubMetadataMeta() {
    return new EpubMetadataMeta()
      ..Content = _randomString.randomAlpha(_length)
      ..Id = _randomString.randomAlpha(_length)
      ..Name = _randomString.randomAlpha(_length)
      ..Property = _randomString.randomAlpha(_length)
      ..Refines = _randomString.randomAlpha(_length)
      ..Scheme = _randomString.randomAlpha(_length);
  }

  EpubMetadataIdentifier randomEpubMetadataIdentifier() {
    return new EpubMetadataIdentifier()
      ..Id = _randomString.randomAlpha(_length)
      ..Identifier = _randomString.randomAlpha(_length)
      ..Scheme = _randomString.randomAlpha(_length);
  }

  EpubMetadataDate randomEpubMetadataDate() {
    return new EpubMetadataDate()
      ..Date = _randomString.randomAlpha(_length)
      ..Event = _randomString.randomAlpha(_length);
  }

  EpubMetadataContributor randomEpubMetadataContributor() {
    return new EpubMetadataContributor()
      ..Contributor = _randomString.randomAlpha(_length)
      ..FileAs = _randomString.randomAlpha(_length)
      ..Role = _randomString.randomAlpha(_length);
  }

  EpubMetadataCreator randomEpubMetadataCreator() {
    return new EpubMetadataCreator()
      ..Creator = _randomString.randomAlpha(_length)
      ..FileAs = _randomString.randomAlpha(_length)
      ..Role = _randomString.randomAlpha(_length);
  }
}
