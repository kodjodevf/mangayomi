import 'package:d4rt/d4rt.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/eval/model/element.dart';

class MElementBridge {
  final elementBridgedClass = BridgedClass(
    nativeType: MElement,
    name: 'MElement',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return MElement(positionalArgs[0] as Element);
      },
    },
    getters: {
      'outerHtml': (visitor, target) => (target as MElement).outerHtml,
      'innerHtml': (visitor, target) => (target as MElement).innerHtml,
      'text': (visitor, target) => (target as MElement).text,
      'className': (visitor, target) => (target as MElement).className,
      'localName': (visitor, target) => (target as MElement).localName,
      'namespaceUri': (visitor, target) => (target as MElement).namespaceUri,
      'getSrc': (visitor, target) => (target as MElement).getSrc,
      'getImg': (visitor, target) => (target as MElement).getImg,
      'getHref': (visitor, target) => (target as MElement).getHref,
      'getDataSrc': (visitor, target) => (target as MElement).getDataSrc,
      'children': (visitor, target) => (target as MElement).children,
      'parent': (visitor, target) => (target as MElement).parent,
      'nextElementSibling': (visitor, target) =>
          (target as MElement).nextElementSibling,
      'previousElementSibling': (visitor, target) =>
          (target as MElement).previousElementSibling,
    },
    methods: {
      'attr': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).attr(positionalArgs[0] as String),
      'text': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).text,
      'select': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).select(positionalArgs[0] as String),
      'selectFirst': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).selectFirst(positionalArgs[0] as String),
      'getElementsByClassName': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).getElementsByClassName(
            positionalArgs[0] as String,
          ),
      'getElementsByTagName': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).getElementsByTagName(
            positionalArgs[0] as String,
          ),
      'xpath': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).xpath(positionalArgs[0] as String),
      'xpathFirst': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).xpathFirst(positionalArgs[0] as String),
      'hasAttr': (visitor, target, positionalArgs, namedArgs) =>
          (target as MElement).hasAttr(positionalArgs[0] as String),
    },
  );

  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      elementBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
