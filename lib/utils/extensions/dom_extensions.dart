import 'package:html/dom.dart';
import 'package:pseudom/pseudom.dart' as pseudom;
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

void _initPseudoSelector() {
  bool nthChild(Element element, String? args) {
    if (int.tryParse(args!) != null) {
      final parent = element.parentNode;
      return parent != null &&
          (int.parse(args) as num) > 0 &&
          parent.nodes.indexOf(element) == int.parse(args);
    }
    return true;
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
    return element.text.contains(text);
  }

  bool firstChild(Element element, String? args) {
    return element.previousElementSibling == null;
  }

  bool lastChild(Element element, String? args) {
    return element.nextElementSibling == null;
  }

  bool onlyChild(Element element, String? args) {
    return element.nextElementSibling == null;
  }

  pseudom.PseudoSelector.handlers['nth-child'] = nthChild;
  pseudom.PseudoSelector.handlers['has'] = has;
  pseudom.PseudoSelector.handlers['inot'] = inot;
  pseudom.PseudoSelector.handlers['contains'] = contains;
  pseudom.PseudoSelector.handlers['last-child'] = lastChild;
  pseudom.PseudoSelector.handlers['first-child'] = firstChild;
  pseudom.PseudoSelector.handlers['only-child'] = onlyChild;
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
      return query.attrs.map((e) => e!.trim().trimLeft().trimRight()).toList();
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
              parent!.nodes.firstWhere((element) => element == this) as Element)
          .toList();
    } catch (e) {
      return null;
    }
  }

  String? xpathFirst(String xpath) {
    var htmlXPath = HtmlXPath.html(outerHtml);
    var query = htmlXPath.query(xpath);
    return query.attr;
  }

  List<String> xpath(String xpath) {
    var htmlXPath = HtmlXPath.html(outerHtml);
    var query = htmlXPath.query(xpath);
    if (query.nodes.length > 1) {
      return query.attrs.map((e) => e!.trim().trimLeft().trimRight()).toList();
    }
    return [];
  }

  Element? selectFirst(String selector) {
    try {
      _initPseudoSelector();
      return pseudom.parse(_fixSelector(selector)).selectFirst(
          parent!.nodes.firstWhere((element) => element == this) as Element);
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
