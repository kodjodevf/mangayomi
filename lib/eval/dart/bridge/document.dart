import 'package:d4rt/d4rt.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/eval/model/document.dart';

class MDocumentBridge {
  final documentBridgedClass = BridgedClass(
    nativeType: MDocument,
    name: 'MDocument',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return MDocument(positionalArgs[0] as Document);
      },
    },
    getters: {
      'body': (visitor, target) => (target as MDocument).body,
      'documentElement': (visitor, target) =>
          (target as MDocument).documentElement,
      'head': (visitor, target) => (target as MDocument).head,
      'parent': (visitor, target) => (target as MDocument).parent,
      'outerHtml': (visitor, target) => (target as MDocument).outerHtml,
      'text': (visitor, target) => (target as MDocument).text,
      'children': (visitor, target) => (target as MDocument).children,
    },
    methods: {
      'select': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).select(positionalArgs[0] as String),
      'selectFirst': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).selectFirst(positionalArgs[0] as String),
      'getElementsByClassName': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).getElementsByClassName(
            positionalArgs[0] as String,
          ),
      'getElementsByTagName': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).getElementsByTagName(
            positionalArgs[0] as String,
          ),
      'getElementById': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).getElementById(positionalArgs[0] as String),
      'attr': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).attr(positionalArgs[0] as String),
      'hasAttr': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).hasAttr(positionalArgs[0] as String),
      'xpath': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).xpath(positionalArgs[0] as String),
      'xpathFirst': (visitor, target, positionalArgs, namedArgs) =>
          (target as MDocument).xpathFirst(positionalArgs[0] as String),
    },
  );

  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      documentBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
