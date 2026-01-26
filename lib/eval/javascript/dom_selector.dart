import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';

class JsDomSelector {
  late JavascriptRuntime runtime;
  JsDomSelector(this.runtime);
  final Map<int, Element?> _elements = {};
  int _elementKey = 0;
  void init() {
    runtime.onMessage('get_doc_element', (dynamic args) {
      final input = args[0];
      final type = args[1];
      final doc = parse(input);
      final element = switch (type) {
        'body' => doc.body,
        'documentElement' => doc.documentElement,
        'head' => doc.head,
        _ => doc.parent,
      };
      _elementKey++;
      _elements[_elementKey] = element;
      return _elementKey;
    });
    runtime.onMessage('get_doc_string', (dynamic args) {
      final input = args[0];
      final type = args[1];
      final doc = parse(input);
      final res = switch (type) {
        'text' => doc.text,
        _ => doc.outerHtml,
      };
      return res ?? "";
    });
    runtime.onMessage('get_element_string', (dynamic args) {
      final type = args[0];
      final key = args[1];
      final element = _elements[key];
      final res = switch (type) {
        'text' => element?.text,
        'innerHtml' => element?.innerHtml,
        'outerHtml' => element?.outerHtml,
        'className' => element?.className,
        'localName' => element?.localName,
        'namespaceUri' => element?.namespaceUri,
        'getSrc' => element?.getSrc,
        'getImg' => element?.getImg,
        'getHref' => element?.getHref,
        _ => element?.getDataSrc,
      };
      return res ?? "";
    });
    runtime.onMessage('doc_select_first', (dynamic args) {
      final input = args[0];
      final selector = args[1];
      _elementKey++;
      _elements[_elementKey] = parse(input).selectFirst(selector);
      return _elementKey;
    });
    runtime.onMessage('ele_selectFirst', (dynamic args) {
      final selector = args[0];
      final key = args[1];
      _elementKey++;
      _elements[_elementKey] = _elements[key]?.selectFirst(selector);
      return _elementKey;
    });
    runtime.onMessage('ele_element_sibling', (dynamic args) {
      final type = args[0];
      final key = args[1];
      final ele = _elements[key];
      final element = switch (type) {
        'nextElementSibling' => ele?.nextElementSibling,
        _ => ele?.previousElementSibling,
      };
      _elementKey++;
      _elements[_elementKey] = element;
      return _elementKey;
    });
    runtime.onMessage('ele_attr', (dynamic args) {
      final attr = args[0];
      final key = args[1];
      return _elements[key]?.attr(attr) ?? "";
    });
    runtime.onMessage('doc_attr', (dynamic args) {
      final input = args[0];
      final attr = args[1];
      return parse(input).attr(attr) ?? "";
    });
    runtime.onMessage('ele_has_attr', (dynamic args) {
      final attr = args[0];
      final key = args[1];
      return _elements[key]?.hasAtr(attr) ?? false;
    });
    runtime.onMessage('doc_has_attr', (dynamic args) {
      final input = args[0];
      final attr = args[1];
      return parse(input).hasAtr(attr);
    });
    runtime.onMessage('doc_xpath_first', (dynamic args) {
      final input = args[0];
      final xpath = args[1];
      return parse(input).xpathFirst(xpath) ?? "";
    });
    runtime.onMessage('ele_xpathFirst', (dynamic args) {
      final xpath = args[0];
      final key = args[1];
      return _elements[key]?.xpathFirst(xpath) ?? "";
    });

    runtime.onMessage('doc_xpath', (dynamic args) {
      final input = args[0];
      final xpath = args[1];
      return jsonEncode(parse(input).xpath(xpath));
    });
    runtime.onMessage('ele_xpath', (dynamic args) {
      final xpath = args[0];
      final key = args[1];
      return jsonEncode(_elements[key]?.xpath(xpath));
    });
    runtime.onMessage('doc_get_elements_by', (dynamic args) {
      final input = args[0];
      final type = args[1];
      final name = args[2];
      final doc = parse(input);
      final elements = switch (type) {
        'children' => doc.children,
        'getElementsByTagName' => doc.getElementsByTagName(name),
        _ => doc.getElementsByClassName(name),
      };
      List<int> elementKeys = [];
      for (var element in elements) {
        _elementKey++;
        _elements[_elementKey] = element;
        elementKeys.add(_elementKey);
      }
      return jsonEncode(elementKeys);
    });
    runtime.onMessage('ele_get_elements_by', (dynamic args) {
      final type = args[0];
      final name = args[1];
      final key = args[2];
      final element = _elements[key];
      final elements = switch (type) {
        'children' => element?.children,
        'getElementsByTagName' => element?.getElementsByTagName(name),
        _ => element?.getElementsByClassName(name),
      };
      List<int> elementKeys = [];
      for (var element in elements ?? []) {
        _elementKey++;
        _elements[_elementKey] = element;
        elementKeys.add(_elementKey);
      }
      return jsonEncode(elementKeys);
    });
    runtime.onMessage('doc_get_element_by_id', (dynamic args) {
      final input = args[0];
      final id = args[1];
      _elementKey++;
      _elements[_elementKey] = parse(input).getElementById(id);
      return _elementKey;
    });
    runtime.onMessage('doc_select', (dynamic args) {
      final input = args[0];
      final selector = args[1];
      final elements = parse(input).select(selector);
      List<int> elementKeys = [];
      for (var element in elements ?? []) {
        _elementKey++;
        _elements[_elementKey] = element;
        elementKeys.add(_elementKey);
      }
      return jsonEncode(elementKeys);
    });
    runtime.onMessage('ele_select', (dynamic args) {
      final selector = args[0];
      final key = args[1];
      final elements = _elements[key]?.select(selector);
      List<int> elementKeys = [];
      for (var element in elements ?? []) {
        _elementKey++;
        _elements[_elementKey] = element;
        elementKeys.add(_elementKey);
      }
      return jsonEncode(elementKeys);
    });

    runtime.evaluate('''
class Document {
    constructor(html) {
        this.html = html;
    }
    getElement(type) {
        const key = sendMessage(
            "get_doc_element",
            JSON.stringify([this.html, type])
        );
        return new Element(key);
    }
    get body() {
        return this.getElement('body');
    }
    get documentElement() {
        return this.getElement('documentElement');
    }
    get head() {
        return this.getElement('head');
    }
    get parent() {
        return this.getElement('parent');
    }
    getString(type) {
        return sendMessage(
            "get_doc_string",
            JSON.stringify([this.html, type]));
    }
    get text() {
        return this.getString('text');
    }
    get outerHtml() {
        return this.getString('outerHtml');
    }
    selectFirst(selector) {
        const key = sendMessage(
            "doc_select_first",
            JSON.stringify([this.html, selector])
        );
        return new Element(key);
    }
    select(selector) {
        let elements = [];
        JSON.parse(
            sendMessage("doc_select", JSON.stringify([this.html, selector]))
        ).forEach((key) => {
            elements.push(new Element(key));
        });
        return elements;
    }
    xpathFirst(xpath) {
        return sendMessage(
            "doc_xpath_first",
            JSON.stringify([this.html, xpath])
        );
    }
    xpath(xpath) {
        return JSON.parse(sendMessage(
            "doc_xpath",
            JSON.stringify([this.html, xpath]))
        );
    }
    getElementsListBy(type, name) {
        name = name || '';
        let elements = [];
        JSON.parse(sendMessage(
            "doc_get_elements_by",
            JSON.stringify([this.html, type, name]))
        ).forEach((key) => {
            elements.push(new Element(key));
        });
        return elements;
    }
    get children() {
        return this.getElementsListBy('children');
    }
    getElementsByTagName(name) {
        return this.getElementsListBy('getElementsByTagName', name);
    }
    getElementsByClassName(name) {
        return this.getElementsListBy('getElementsByClassName', name);
    }
    getElementById(id) {
        const key = sendMessage(
            "doc_get_element_by_id",
            JSON.stringify([this.html, id])
        );
        return new Element(key);
    }
    attr(attr) {
        return sendMessage(
            "doc_attr",
            JSON.stringify([this.html, attr])
        );
    }
    hasAttr(attr) {
        return sendMessage(
            "doc_has_attr",
            JSON.stringify([this.html, attr])
        );
    }
}

class Element {
    constructor(key) {
        this.key = key;
    }
    getString(type) {
        return sendMessage(
            "get_element_string",
            JSON.stringify([type, this.key])
        );
    }
    get text() {
        return this.getString("text");
    }
    get outerHtml() {
        return this.getString("outerHtml");
    }
    get innerHtml() {
        return this.getString("innerHtml");
    }
    get className() {
        return this.getString("className");
    }
    get localName() {
        return this.getString("localName");
    }
    get namespaceUri() {
        return this.getString("namespaceUri");
    }
    get getSrc() {
        return this.getString("getSrc");
    }
    get getImg() {
        return this.getString("getImg");
    }
    get getHref() {
        return this.getString("getHref");
    }
    get getDataSrc() {
        return this.getString("getDataSrc");
    }
    getElementSibling(type) {
        const key = sendMessage(
            "ele_element_sibling",
            JSON.stringify([type, this.key])
        );
        return new Element(key);
    }
    get previousElementSibling() {
        return this.getElementSibling("previousElementSibling");
    }
    get nextElementSibling() {
        return this.getElementSibling("nextElementSibling");
    }
    getElementsListBy(type, name) {
        name = name || '';
        let elements = [];
        JSON.parse(sendMessage(
            "ele_get_elements_by",
            JSON.stringify([type, name, this.key]))
        ).forEach((key) => {
            elements.push(new Element(key));
        });
        return elements;
    }
    get children() {
        return this.getElementsListBy('children');
    }
    getElementsByTagName(name) {
        return this.getElementsListBy('getElementsByTagName', name);
    }
    getElementsByClassName(name) {
        return this.getElementsListBy('getElementsByClassName', name);
    }
    xpath(xpath) {
        return JSON.parse(sendMessage(
            "xpath",
            JSON.stringify([xpath, this.key]))
        );
    }
    attr(attr) {
        return sendMessage(
            "ele_attr",
            JSON.stringify([attr, this.key])
        );
    }
    xpathFirst(xpath) {
        return sendMessage(
            "xpathFirst",
            JSON.stringify([xpath, this.key])
        );
    }
    selectFirst(selector) {
        const key = sendMessage(
            "ele_selectFirst",
            JSON.stringify([selector, this.key])
        );
        return new Element(key);
    }
    select(selector) {
        let elements = [];
        JSON.parse(
            sendMessage("ele_select", JSON.stringify([selector, this.key]))
        ).forEach((key) => {
            elements.push(new Element(key));
        });
        return elements;
    }
    hasAttr(attr) {
        return sendMessage(
            "ele_has_attr",
            JSON.stringify([this.html, attr])
        );
    }
}
''');
  }

  void dispose() {
    if (_elements.isEmpty) return;
    _elements.clear();
    _elementKey = 0;
  }
}
