import 'package:html/dom.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

extension DocumentExtension on Document? {
  List<Element>? select(String selector) {
    try {
      return this?.querySelectorAll(selector);
    } catch (e) {
      return null;
    }
  }

  Element? selectFirst(String selector) {
    try {
      return this?.querySelector(selector);
    } catch (e) {
      return null;
    }
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
      return querySelectorAll(selector);
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
      return querySelector(selector);
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
