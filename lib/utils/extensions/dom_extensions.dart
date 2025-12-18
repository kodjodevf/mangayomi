import 'package:html/dom.dart';
import 'package:pseudom/pseudom.dart' as pseudom;
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

void _initPseudoSelector() {
  (int, int) parseNth(String arg) {
    arg = arg.toLowerCase().replaceAll(' ', '');
    if (arg == 'odd') return (2, 1);
    if (arg == 'even') return (2, 0);
    final reg = RegExp(r'^(\d*)n([+-]?\d+)?$');
    final match = reg.firstMatch(arg);
    if (match != null) {
      final aStr = match.group(1);
      final a = aStr == null || aStr.isEmpty ? 1 : int.parse(aStr);
      final bStr = match.group(2);
      final b = bStr == null ? 0 : int.parse(bStr);
      return (a, b);
    }
    final n = int.tryParse(arg);
    if (n != null) return (0, n);
    return (0, 0);
  }

  bool matchesNth(int index, int a, int b) {
    if (a == 0) return index == b;
    final diff = index - b;
    return diff % a == 0 && diff ~/ a >= 0;
  }

  String getWholeText(Element element) {
    return element.nodes.map((node) {
      if (node is Text) return node.text;
      if (node is Element) return getWholeText(node);
      return '';
    }).join();
  }

  String getWholeOwnText(Element element) {
    return element.nodes.whereType<Text>().map((t) => t.text).join();
  }

  bool nthChild(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children;
    final index = siblings.indexOf(element) + 1; // 1-based
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool nthLastChild(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children;
    final index =
        siblings.length - siblings.indexOf(element); // 1-based from end
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool nthOfType(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children
        .where((e) => e.localName == element.localName)
        .toList();
    final index = siblings.indexOf(element) + 1; // 1-based
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool nthLastOfType(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children
        .where((e) => e.localName == element.localName)
        .toList();
    final index =
        siblings.length - siblings.indexOf(element); // 1-based from end
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool has(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    final res = parent == null
        ? false
        : pseudom.parse(args).selectFirst(parent) == element;
    return res ? res : pseudom.parse(args).selectFirst(element) != null;
  }

  bool inot(Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    final res = parent == null
        ? false
        : pseudom.parse(args).selectFirst(parent) != element;
    return res ? res : pseudom.parse(args).selectFirst(element) == null;
  }

  bool contains(Element element, String? args) {
    final text = args ?? '';
    return element.text.toLowerCase().contains(text.toLowerCase());
  }

  bool containsOwn(Element element, String? args) {
    final text = args ?? '';
    final ownText = element.nodes.whereType<Text>().map((t) => t.text).join();
    return ownText.toLowerCase().contains(text.toLowerCase());
  }

  bool matches(Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args, caseSensitive: false);
      return reg.hasMatch(element.text);
    } catch (e) {
      return false;
    }
  }

  bool containsData(Element element, String? args) {
    final data = args ?? '';
    // For script and style elements
    if (element.localName == 'script' || element.localName == 'style') {
      return element.text.toLowerCase().contains(data.toLowerCase());
    }
    return false;
  }

  bool containsWholeText(Element element, String? args) {
    final text = args ?? '';
    return getWholeText(element).contains(text);
  }

  bool containsWholeOwnText(Element element, String? args) {
    final text = args ?? '';
    return getWholeOwnText(element).contains(text);
  }

  bool matchesWholeText(Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args);
      return reg.hasMatch(getWholeText(element));
    } catch (e) {
      return false;
    }
  }

  bool matchesWholeOwnText(Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args);
      return reg.hasMatch(getWholeOwnText(element));
    } catch (e) {
      return false;
    }
  }

  bool isSelector(Element element, String? args) {
    if (args == null) return false;
    final selectors = args.split(',').map((s) => s.trim()).toList();
    for (final sel in selectors) {
      try {
        final parsed = pseudom.parse(sel);
        if (parsed.selectFirst(element) != null) return true;
      } catch (_) {}
    }
    return false;
  }

  bool firstChild(Element element, String? args) {
    return element.previousElementSibling == null;
  }

  bool lastChild(Element element, String? args) {
    return element.nextElementSibling == null;
  }

  bool firstOfType(Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.first == element;
  }

  bool lastOfType(Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.last == element;
  }

  bool onlyChild(Element element, String? args) {
    return element.previousElementSibling == null &&
        element.nextElementSibling == null;
  }

  bool onlyOfType(Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.length == 1;
  }

  bool empty(Element element, String? args) {
    return element.children.isEmpty && element.text.trim().isEmpty;
  }

  bool root(Element element, String? args) {
    return element.parent == null;
  }

  bool lt(Element element, String? args) {
    if (args == null) return false;
    final n = int.tryParse(args);
    if (n == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final index = parent.children.indexOf(element);
    return index < n;
  }

  bool gt(Element element, String? args) {
    if (args == null) return false;
    final n = int.tryParse(args);
    if (n == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final index = parent.children.indexOf(element);
    return index > n;
  }

  bool eq(Element element, String? args) {
    if (args == null) return false;
    final n = int.tryParse(args);
    if (n == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final index = parent.children.indexOf(element);
    return index == n;
  }

  pseudom.PseudoSelector.handlers['nth-child'] = nthChild;
  pseudom.PseudoSelector.handlers['nth-last-child'] = nthLastChild;
  pseudom.PseudoSelector.handlers['nth-of-type'] = nthOfType;
  pseudom.PseudoSelector.handlers['nth-last-of-type'] = nthLastOfType;
  pseudom.PseudoSelector.handlers['has'] = has;
  pseudom.PseudoSelector.handlers['inot'] = inot;
  pseudom.PseudoSelector.handlers['contains'] = contains;
  pseudom.PseudoSelector.handlers['containsOwn'] = containsOwn;
  pseudom.PseudoSelector.handlers['containsData'] = containsData;
  pseudom.PseudoSelector.handlers['containsWholeText'] = containsWholeText;
  pseudom.PseudoSelector.handlers['containsWholeOwnText'] =
      containsWholeOwnText;
  pseudom.PseudoSelector.handlers['matches'] = matches;
  pseudom.PseudoSelector.handlers['matchesWholeText'] = matchesWholeText;
  pseudom.PseudoSelector.handlers['matchesWholeOwnText'] = matchesWholeOwnText;
  pseudom.PseudoSelector.handlers['is'] = isSelector;
  pseudom.PseudoSelector.handlers['last-child'] = lastChild;
  pseudom.PseudoSelector.handlers['first-child'] = firstChild;
  pseudom.PseudoSelector.handlers['first-of-type'] = firstOfType;
  pseudom.PseudoSelector.handlers['last-of-type'] = lastOfType;
  pseudom.PseudoSelector.handlers['only-child'] = onlyChild;
  pseudom.PseudoSelector.handlers['only-of-type'] = onlyOfType;
  pseudom.PseudoSelector.handlers['empty'] = empty;
  pseudom.PseudoSelector.handlers['root'] = root;
  pseudom.PseudoSelector.handlers['lt'] = lt;
  pseudom.PseudoSelector.handlers['gt'] = gt;
  pseudom.PseudoSelector.handlers['eq'] = eq;
}

String _fixSelector(String selector) {
  return selector.replaceAll(':not', ':inot');
}

extension DocumentExtension on Document? {
  List<Element>? select(String selector) {
    try {
      _initPseudoSelector();
      final dom = this?.documentElement;
      return pseudom.parse(_fixSelector(selector)).select(dom!).toList();
    } catch (e) {
      return null;
    }
  }

  Element? selectFirst(String selector) {
    try {
      _initPseudoSelector();
      final dom = this?.documentElement;
      return pseudom.parse(_fixSelector(selector)).selectFirst(dom!);
    } catch (e) {
      return null;
    }
  }

  bool hasAtr(String attribute) {
    return attr(attribute) != null;
  }

  String? xpathFirst(String xpath) {
    final dom = this?.documentElement;
    if (dom == null) return null;
    var htmlXPath = HtmlXPath.node(dom);
    var query = htmlXPath.query(xpath);
    return query.attr;
  }

  List<String> xpath(String xpath) {
    final dom = this?.documentElement;
    if (dom == null) return [];
    var htmlXPath = HtmlXPath.node(dom);
    var query = htmlXPath.query(xpath);
    if (query.nodes.length > 1) {
      return query.attrs.map((e) => e!.trim()).toList();
    }
    return [];
  }

  String? attr(String attribute) {
    try {
      return this?.attributes[attribute];
    } catch (e) {
      return null;
    }
  }
}

extension ElementtExtension on Element {
  List<Element>? select(String selector) {
    try {
      _initPseudoSelector();
      return pseudom
          .parse(_fixSelector(selector))
          .select(
            parent!.nodes.firstWhere((element) => element == this) as Element,
          )
          .toList();
    } catch (e) {
      return null;
    }
  }

  String? xpathFirst(String xpath) {
    var htmlXPath = HtmlXPath.node(this);
    var query = htmlXPath.query(xpath);
    return query.attr;
  }

  List<String> xpath(String xpath) {
    var htmlXPath = HtmlXPath.node(this);
    var query = htmlXPath.query(xpath);
    if (query.nodes.length > 1) {
      return query.attrs.map((e) => e!.trim()).toList();
    }
    return [];
  }

  Element? selectFirst(String selector) {
    try {
      _initPseudoSelector();
      return pseudom
          .parse(_fixSelector(selector))
          .selectFirst(
            parent!.nodes.firstWhere((element) => element == this) as Element,
          );
    } catch (e) {
      return null;
    }
  }

  String? attr(String attribute) {
    try {
      return attributes[attribute];
    } catch (e) {
      return null;
    }
  }

  bool hasAtr(String attribute) {
    return attr(attribute) != null;
  }

  String? get getSrc {
    try {
      return regSrcMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getImg {
    try {
      return regImgMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getHref {
    try {
      return regHrefMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getDataSrc {
    try {
      return regDataSrcMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }
}
