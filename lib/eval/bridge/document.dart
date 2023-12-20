import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';

import 'package:dart_eval/stdlib/core.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/eval/bridge/element.dart';
import 'package:mangayomi/eval/model/document.dart';
import 'package:mangayomi/eval/model/element.dart';

class $MDocument implements MDocument, $Instance {
  $MDocument.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MDocument'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
          BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
            BridgeParameter('document',
                BridgeTypeAnnotation($Element.$type, nullable: true), false),
          ]),
        )
      },
      fields: {
        'document': BridgeFieldDef(BridgeTypeAnnotation($Element.$type)),
      },
      getters: {
        'body': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($MElement.$type, nullable: true),
        )),
        'documentElement': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($MElement.$type, nullable: true),
        )),
        'head': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($MElement.$type, nullable: true),
        )),
        'parent': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($MElement.$type, nullable: true),
        )),
        'outerHtml': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
              nullable: true),
        )),
        'text': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
              nullable: true),
        )),
        'children': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
              BridgeTypeRef(CoreTypes.list, [$MElement.$type]),
              nullable: true),
        )),
      },
      methods: {
        'select': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(
                  BridgeTypeRef(CoreTypes.list, [$MElement.$type]),
                  nullable: true),
              params: [
                BridgeParameter(
                    'selector',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false)
              ]),
        ),
        'selectFirst': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation($MElement.$type, nullable: true),
              params: [
                BridgeParameter(
                    'selector',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false)
              ]),
        ),
      },
      wrap: true);

  @override
  get $reified => $value;

  @override
  final MDocument $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'body':
        final res = $value.body;
        return res == null ? const $null() : $MElement.wrap(res);
      case 'documentElement':
        final res = $value.documentElement;
        return res == null ? const $null() : $MElement.wrap(res);
      case 'head':
        final res = $value.head;
        return res == null ? const $null() : $MElement.wrap(res);
      case 'parent':
        final res = $value.parent;
        return res == null ? const $null() : $MElement.wrap(res);
      case 'outerHtml':
        final res = $value.outerHtml;
        return res == null ? const $null() : $String(res);
      case 'text':
        final res = $value.text;
        return res == null ? const $null() : $String(res);
      case 'children':
        final res = $value.children;
        return res == null
            ? const $null()
            : $List.wrap(res.map((e) => $MElement.wrap(e)).toList());
      case 'select':
        return __select;
      case 'selectFirst':
        return __selectFirst;
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {}

  static const $Function __select = $Function(_select);
  static $Value? _select(
      final Runtime runtime, final $Value? target, final List<$Value?> args) {
    final res = (target!.$value as MDocument).select(args[0]?.$value);
    return res == null
        ? const $null()
        : $List.wrap(res.map((e) => $MElement.wrap(e)).toList());
  }

  static const $Function __selectFirst = $Function(_selectFirst);
  static $Value? _selectFirst(
      final Runtime runtime, final $Value? target, final List<$Value?> args) {
    final res = (target!.$value as MDocument).selectFirst(args[0]?.$value);
    return res == null ? const $null() : $MElement.wrap(res);
  }

  static $Value? $new(
      final Runtime runtime, final $Value? target, final List<$Value?> args) {
    return $MDocument.wrap(MDocument(args[0]?.$value));
  }

  @override
  List<MElement>? select(String selector) => $value.select(selector);

  @override
  MElement? selectFirst(String selector) => $value.selectFirst(selector);

  @override
  MElement? get body => $value.body;

  @override
  List<MElement>? get children => $value.children;

  @override
  MElement? get documentElement => $value.documentElement;

  @override
  MElement? get head => $value.head;

  @override
  String? get outerHtml => $value.outerHtml;

  @override
  MElement? get parent => $value.parent;

  @override
  String? get text => $value.text;
}

class $Document implements $Instance {
  $Document.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'Document'));

  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type, nullable: true)))
    },
    wrap: true,
  );

  @override
  get $reified => $value;

  @override
  final Document $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {}
}
