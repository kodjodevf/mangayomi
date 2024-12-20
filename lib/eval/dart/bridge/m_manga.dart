import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/dart/bridge/m_chapter.dart';
import 'package:mangayomi/eval/dart/bridge/m_status.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class $MManga implements MManga, $Instance {
  $MManga.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MManga'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: []))
      },
      // Specify class fields
      fields: {
        'author': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'artist': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'status': BridgeFieldDef(BridgeTypeAnnotation($MStatus.$type)),
        'genre': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]),
          ),
        ),
        'imageUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'link': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'description': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'chapters': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [$MChapter.$type]))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MManga.wrap(MManga());
  }

  @override
  final MManga $value;

  @override
  MManga get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'author':
        return $String($value.author!);
      case 'artist':
        return $String($value.artist!);
      case 'status':
        return $MStatus.wrap($value.status!);
      case 'genre':
        return $List.wrap($value.genre!);
      case 'imageUrl':
        return $String($value.imageUrl!);

      case 'name':
        return $String($value.name!);
      case 'link':
        return $String($value.link!);
      case 'description':
        return $String($value.description!);
      case 'chapters':
        return $List
            .wrap($value.chapters!.map((e) => $MChapter.wrap(e)).toList());

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'author':
        $value.author = value.$reified;
      case 'artist':
        $value.artist = value.$reified;
      case 'status':
        $value.status = value.$reified;
      case 'genre':
        $value.genre =
            (value.$reified as List).map((e) => e.toString()).toList();
      case 'imageUrl':
        $value.imageUrl = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'link':
        $value.link = value.$reified;
      case 'description':
        $value.description = value.$reified;
      case 'chapters':
        $value.chapters = (value.$reified as List)
            .map((e) => MChapter(
                dateUpload: e.dateUpload,
                url: e.url,
                name: e.name,
                scanlator: e.scanlator))
            .toList();

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get author => $value.author;

  @override
  String? get artist => $value.artist;

  @override
  String? get description => $value.description;

  @override
  String? get imageUrl => $value.imageUrl;

  @override
  String? get name => $value.name;

  @override
  String? get link => $value.link;

  @override
  Status? get status => $value.status;

  @override
  List<MChapter>? get chapters => $value.chapters;

  @override
  List<String>? get genre => $value.genre;

  @override
  set author(String? author) {
    //  implement author
  }

  @override
  set artist(String? artist) {
    //  implement artist
  }

  @override
  set description(String? description) {
    //  implement description
  }

  @override
  set imageUrl(String? imageUrl) {
    //  implement imageUrl
  }

  @override
  set link(String? link) {
    //  implement link
  }

  @override
  set name(String? name) {
    //  implement name
  }

  @override
  set genre(List<String>? genre) {
    //  implement genre
  }

  @override
  set status(Status? status) {
    //  implement status
  }

  @override
  set chapters(List<MChapter>? chapters) {}

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'imageUrl': imageUrl,
        'description': description,
        'author': author,
        'artist': artist,
        'status': status.toString().substringAfter("."),
        'genre': genre,
        'chapters': chapters?.map((e) => e.toJson()).toList()
      };
}
