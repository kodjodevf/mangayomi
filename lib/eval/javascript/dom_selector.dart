import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';

class JsDomSelector {
  late JavascriptRuntime runtime;
  JsDomSelector(this.runtime);

  init() {
    runtime.onMessage('getDocElement', (dynamic args) async {
      final input = args[0];
      final type = args[1];
      final doc = parse(input);
      final res = switch (type) {
        'body' => doc.body,
        'documentElement' => doc.documentElement,
        'head' => doc.head,
        _ => doc.parent
      };
      return res?.outerHtml ?? "";
    });
    runtime.onMessage('getDocumentString', (dynamic args) async {
      final input = args[0];
      final type = args[1];
      final doc = parse(input);
      final res = switch (type) { 'text' => doc.text, _ => doc.outerHtml };
      return res ?? "";
    });
    runtime.onMessage('getElementString', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final type = args[2];
      final element = parse(input).selectFirst(selector);
      final res = switch (type) {
        'text' => element?.text,
        'innerHtml' => element?.innerHtml,
        'outerHtml' => element?.outerHtml,
        'previousElementSibling' => element?.previousElementSibling?.outerHtml,
        'nextElementSibling' => element?.nextElementSibling?.outerHtml,
        'className' => element?.className,
        'localName' => element?.localName,
        'namespaceUri' => element?.namespaceUri,
        'getSrc' => element?.getSrc,
        'getImg' => element?.getImg,
        'getHref' => element?.getHref,
        _ => element?.getDataSrc
      };
      return res ?? "";
    });
    runtime.onMessage('selectFirst', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final element = parse(input).selectFirst(selector);
      return element?.outerHtml ?? "";
    });
    runtime.onMessage('attr', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final attr = args[2];
      return parse(input).selectFirst(selector)?.attr(attr) ?? "";
    });
    runtime.onMessage('docAttr', (dynamic args) async {
      final input = args[0];
      final attr = args[1];
      return parse(input).attr(attr) ?? "";
    });
    runtime.onMessage('xpathFirst', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final xpath = args[2];
      return parse(input).selectFirst(selector)?.xpathFirst(xpath) ?? "";
    });

    runtime.onMessage('xpath', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final xpath = args[2];
      return jsonEncode(parse(input).selectFirst(selector)?.xpath(xpath));
    });
    runtime.onMessage('docGetElementsListBy', (dynamic args) async {
      final input = args[0];
      final type = args[1];
      final name = args[2];
      final doc = parse(input);
      final elements = switch (type) {
        'children' => doc.children,
        'getElementsByTagName' => doc.getElementsByTagName(name),
        _ => doc.getElementsByClassName(name)
      };
      return jsonEncode(elements.map((e) => e.outerHtml).toList());
    });
    runtime.onMessage('elemGetElementsListBy', (dynamic args) async {
      final input = args[0];
      final type = args[1];
      final name = args[2];
      final selector = args[3];
      final doc = parse(input).selectFirst(selector);
      final elements = switch (type) {
        'children' => doc?.children,
        'getElementsByTagName' => doc?.getElementsByTagName(name),
        _ => doc?.getElementsByClassName(name)
      };
      return jsonEncode(elements?.map((e) => e.outerHtml).toList());
    });
    runtime.onMessage('getElementById', (dynamic args) async {
      final input = args[0];
      final id = args[1];
      return parse(input).getElementById(id)?.outerHtml ?? "";
    });
    runtime.onMessage('select', (dynamic args) async {
      final input = args[0];
      final selector = args[1];
      final listElement = parse(input).select(selector);
      final elements = jsonEncode(listElement?.map((e) {
        return e.outerHtml;
      }).toList());
      return elements;
    });

    runtime.evaluate('''
class Document {
    constructor(html) {
        this.html = html;
    }
    async getDocElement(type) {
        return JSON.parse(await sendMessage(
            "getDocElement",
            JSON.stringify([this.html, type]))
        );
    }
    get body() {
        return this.getDocElement('body');
    }
    get documentElement() {
        return this.getDocElement('documentElement');
    }
    get head() {
        return this.getDocElement('head');
    }
    get parent() {
        return this.getDocElement('parent');
    }
    async getDocumentString(type) {
        return JSON.parse(await sendMessage(
            "getDocumentString",
            JSON.stringify([this.html, type]))
        );
    }
    get text() {
        return this.getDocumentString('text');
    }
    get outerHtml() {
        return this.getDocumentString('outerHtml');
    }
    async selectFirst(selector) {
        const res = await sendMessage(
            "selectFirst",
            JSON.stringify([this.html, selector])
        );
        return new Element(res, selector);
    }
    async select(selector) {
        let htmlList = [];
        JSON.parse(
            await sendMessage("select", JSON.stringify([this.html, selector]))
        ).forEach((e) => {
            htmlList.push(e);
        });
        return htmlList;
    }
    async xpathFirst(xpath) {
        return await sendMessage(
            "xpathFirst",
            JSON.stringify([this.html, xpath])
        );
    }
    async xpath(xpath) {
        return JSON.parse(await sendMessage(
            "xpath",
            JSON.stringify([this.html, xpath]))
        );
    }
    async docGetElementsListBy(type, name) {
        name = name || '';
        return JSON.parse(await sendMessage(
            "docGetElementsListBy",
            JSON.stringify([this.html, type, name]))
        );
    }
    get children() {
        return this.docGetElementsListBy('children');
    }
    async getElementsByTagName(name) {
        return this.docGetElementsListBy('getElementsByTagName', name);
    }
    async getElementsByClassName(name) {
        return this.docGetElementsListBy('getElementsByClassName', name);
    }
    async getElementById(id) {
        return await sendMessage(
            "getElementById",
            JSON.stringify([(await this.parse()).outerHtml, id])
        );
    }
    async attr(attr) {
        return await sendMessage(
            "docAttr",
            JSON.stringify([this.res.html, this.res.selector, attr])
        );
    }
}

class Element {
    constructor(html, selector) {
        this.html = html;
        this.selector = selector;
    }
    async getElementString(type) {
        return await sendMessage(
            "getElementString",
            JSON.stringify([this.html, this.selector, type])
        );
    }
    get text() {
        return this.getElementString("text");
    }
    get outerHtml() {
        return this.getElementString("outerHtml");
    }
    get innerHtml() {
        return this.getElementString("innerHtml");
    }
    get className() {
        return this.getElementString("className");
    }
    get localName() {
        return this.getElementString("localName");
    }
    get namespaceUri() {
        return this.getElementString("namespaceUri");
    }
    get getSrc() {
        return this.getElementString("getSrc");
    }
    get getImg() {
        return this.getElementString("getImg");
    }
    get getHref() {
        return this.getElementString("getHref");
    }
    get getDataSrc() {
        return this.getElementString("getDataSrc");
    }
    get previousElementSibling() {
        return this.getElementString("previousElementSibling");
    }
    get nextElementSibling() {
        return this.getElementString("nextElementSibling");
    }
    async elemGetElementsListBy(type, name) {
        name = name || '';
        return JSON.parse(await sendMessage(
            "elemGetElementsListBy",
            JSON.stringify([this.html, type, name]))
        );
    }
    get children() {
        return this.elemGetElementsListBy('children');
    }
    async getElementsByTagName(name) {
        return this.elemGetElementsListBy('getElementsByTagName', name);
    }
    async getElementsByClassName(name) {
        return this.elemGetElementsListBy('getElementsByClassName', name);
    }
    async xpath(xpath) {
        return JSON.parse(await sendMessage(
            "xpath",
            JSON.stringify([this.html, xpath]))
        );
    }
    async attr(attr) {
        return await sendMessage(
            "attr",
            JSON.stringify([this.html, this.selector, attr])
        );
    }
    async xpathFirst(xpath) {
        return await sendMessage(
            "xpathFirst",
            JSON.stringify([this.html, xpath])
        );
    }
}
''');
  }
}

extension ElementExtexsion on Element? {
  Map<String, dynamic> toJson() => {
        'text': this?.text,
        'className': this?.className,
        'localName': this?.localName,
        'namespaceUri': this?.namespaceUri,
        'getSrc': this?.getSrc,
        'getImg': this?.getImg,
        'getHref': this?.getHref,
        'getDataSrc': this?.getDataSrc,
      };
}
