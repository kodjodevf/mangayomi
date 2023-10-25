import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/m_manga.dart';

class $MManga implements MManga, $Instance {
  $MManga.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'MManga'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
        ))
      },
      // Specify class fields
      fields: {
        'source': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'author': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'status': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.intType))),
        'genre': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'imageUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'lang': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'link': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'description': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'baseUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'dateFormat': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'dateFormatLocale': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'apiUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'page': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.intType))),
        'query': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'sourceId': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.intType))),
        'names': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'urls': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'chaptersScanlators': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'chaptersDateUploads': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'chaptersVolumes': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'chaptersChaps': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'images': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef.type(RuntimeTypes.stringType)]),
          ),
        ),
        'hasNextPage': BridgeFieldDef(
          BridgeTypeAnnotation(
            BridgeTypeRef.type(RuntimeTypes.boolType),
          ),
        ),
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
      case 'source':
        return $String($value.source!);
      case 'author':
        return $String($value.author!);
      case 'status':
        return $int($value.status!);
      case 'genre':
        return $List.wrap($value.genre!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'imageUrl':
        return $String($value.imageUrl!);
      case 'lang':
        return $String($value.lang!);
      case 'name':
        return $String($value.name!);
      case 'link':
        return $String($value.link!);
      case 'description':
        return $String($value.description!);
      case 'baseUrl':
        return $String($value.baseUrl!);
      case 'dateFormat':
        return $String($value.dateFormat!);
      case 'dateFormatLocale':
        return $String($value.dateFormatLocale!);
      case 'apiUrl':
        return $String($value.apiUrl!);
      case 'page':
        return $int($value.page!);
      case 'query':
        return $String($value.query!);
      case 'sourceId':
        return $int($value.sourceId!);
      case 'names':
        return $List.wrap($value.names!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'chaptersDateUploads':
        return $List.wrap($value.chaptersDateUploads!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'chaptersScanlators':
        return $List.wrap($value.chaptersScanlators!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'urls':
        return $List.wrap($value.urls!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'chaptersVolumes':
        return $List.wrap($value.chaptersVolumes!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'chaptersChaps':
        return $List.wrap($value.chaptersChaps!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());
      case 'images':
        return $List.wrap($value.images!.map((e) {
          if (e is String) {
            return $String(e);
          } else {
            return e;
          }
        }).toList());

      case 'hasNextPage':
        return $bool($value.hasNextPage!);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'source':
        $value.source = value.$reified;
      case 'author':
        $value.author = value.$reified;
      case 'status':
        $value.status = value.$reified;
      case 'genre':
        $value.genre = value.$reified;
      case 'imageUrl':
        $value.imageUrl = value.$reified;
      case 'lang':
        $value.lang = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'link':
        $value.link = value.$reified;
      case 'description':
        $value.description = value.$reified;
      case 'baseUrl':
        $value.baseUrl = value.$reified;
      case 'dateFormat':
        $value.dateFormat = value.$reified;
      case 'dateFormatLocale':
        $value.dateFormatLocale = value.$reified;
      case 'apiUrl':
        $value.apiUrl = value.$reified;
      case 'page':
        $value.page = value.$reified;
      case 'query':
        $value.query = value.$reified;
      case 'sourceId':
        $value.sourceId = value.$reified;
      case 'names':
        $value.names = value.$reified;
      case 'chaptersDateUploads':
        $value.chaptersDateUploads = value.$reified;
      case 'chaptersScanlators':
        $value.chaptersScanlators = value.$reified;
      case 'urls':
        $value.urls = value.$reified;
      case 'chaptersVolumes':
        $value.chaptersVolumes = value.$reified;
      case 'chaptersChaps':
        $value.chaptersChaps = value.$reified;
      case 'images':
        $value.images = value.$reified;
      case 'hasNextPage':
        $value.hasNextPage = value.$reified;
      case 'hasError':
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get author => $value.author;

  @override
  String? get description => $value.description;

  @override
  String? get imageUrl => $value.imageUrl;

  @override
  String? get name => $value.name;

  @override
  String? get source => $value.source;

  @override
  String? get link => $value.link;

  @override
  List<dynamic>? get genre => $value.genre;

  @override
  String? get lang => $value.lang;

  @override
  int? get sourceId => $value.sourceId;
  @override
  int? get status => $value.status;

  @override
  set author(String? author) {}

  @override
  set description(String? description) {}

  @override
  set imageUrl(String? imageUrl) {}

  @override
  set link(String? link) {}

  @override
  set name(String? name) {}

  @override
  set source(String? source) {}
  @override
  set hasNextPage(bool? hasNextPage) {}

  @override
  List<dynamic>? get chaptersDateUploads => $value.chaptersDateUploads;

  @override
  List<dynamic>? get names => $value.names;

  @override
  List<dynamic>? get chaptersScanlators => $value.chaptersScanlators;

  @override
  List<dynamic>? get urls => $value.urls;
  @override
  List<dynamic>? get chaptersVolumes => $value.chaptersVolumes;

  @override
  List<dynamic>? get chaptersChaps => $value.chaptersChaps;
  @override
  List<dynamic>? get images => $value.images;
  @override
  List<dynamic>? get statusList => $value.statusList;

  @override
  set chaptersDateUploads(List? chaptersDateUploads) {}

  @override
  set names(List? names) {}

  @override
  set chaptersScanlators(List? chaptersScanlators) {}

  @override
  set urls(List? urls) {}

  @override
  set genre(List? genre) {}

  @override
  set lang(String? lang) {}

  @override
  set status(int? status) {}

  @override
  String? get apiUrl => $value.apiUrl;

  @override
  String? get baseUrl => $value.baseUrl;

  @override
  String? get dateFormat => $value.dateFormat;

  @override
  String? get dateFormatLocale => $value.dateFormatLocale;

  @override
  bool? get hasNextPage => $value.hasNextPage;

  @override
  set apiUrl(String? apiUrl) {}

  @override
  set baseUrl(String? baseUrl) {}

  @override
  set dateFormat(String? dateFormat) {}

  @override
  set dateFormatLocale(String? dateFormatLocale) {}

  @override
  int? get page => $value.page;

  @override
  set page(int? page) {}
  @override
  String? get query => $value.query;

  @override
  set query(String? query) {}

  @override
  set chaptersChaps(List? chaptersChaps) {}

  @override
  set chaptersVolumes(List? chaptersVolumes) {}
  @override
  set images(List? images) {}
  @override
  set statusList(List? images) {}

  @override
  set sourceId(int? sourceId) {}
}
