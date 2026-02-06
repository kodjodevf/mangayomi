import 'dart:convert';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';

class JsCheerio {
  late JavascriptRuntime runtime;
  final Map<int, Element?> _elements = {};
  int _elementKey = 0;

  JsCheerio(this.runtime);

  void init() {
    runtime.onMessage('load', (dynamic args) {
      final html = args[0];
      final doc = parse(html);
      _elementKey++;
      _elements[_elementKey] = doc.body;
      return _elementKey;
    });

    runtime.onMessage('element_call', (dynamic args) {
      final method = args[0] as String;
      final key = args[1] as int;
      final element = _elements[key];

      if (element == null) return null;

      final methodArgs = args.length > 2 ? args[2] : [];

      dynamic result;

      switch (method) {
        case 'text':
          result = element.text;
          break;
        case 'html':
        case 'innerHtml':
          result = element.innerHtml;
          break;
        case 'outerHtml':
          result = element.outerHtml;
          break;
        case 'addClass':
          element.classes.add(methodArgs[0]);
          break;
        case 'removeClass':
          element.classes.remove(methodArgs[0]);
          break;
        case 'hasClass':
          result = element.classes.contains(methodArgs[0]);
          break;
        case 'attr':
          result = element.attributes[methodArgs[0]] ?? '';
          break;
        case 'setAttr':
          element.attributes[methodArgs[0]] = methodArgs[1];
          break;
        case 'removeAttr':
          element.attributes.remove(methodArgs[0]);
          break;
        case 'val':
          result = element.attributes['value'] ?? '';
          break;
        case 'setVal':
          element.attributes['value'] = methodArgs[0];
          break;
        case 'children':
          final children = element.children;
          List<int> keys = [];
          for (var child in children) {
            _elementKey++;
            _elements[_elementKey] = child;
            keys.add(_elementKey);
          }
          result = jsonEncode(keys);
          break;
        case 'parent':
          final parent = element.parent;
          if (parent != null) {
            _elementKey++;
            _elements[_elementKey] = parent;
            result = _elementKey;
          }
          break;
        case 'find':
          final selector = methodArgs[0];
          final elements = element.select(selector);
          List<int> keys = [];
          for (var el in elements ?? []) {
            _elementKey++;
            _elements[_elementKey] = el;
            keys.add(_elementKey);
          }
          result = jsonEncode(keys);
          break;
        case 'first':
          final first = element.children.firstOrNull;
          if (first != null) {
            _elementKey++;
            _elements[_elementKey] = first;
            result = _elementKey;
          }
          break;
        case 'last':
          final last = element.children.lastOrNull;
          if (last != null) {
            _elementKey++;
            _elements[_elementKey] = last;
            result = _elementKey;
          }
          break;
        case 'next':
          final next = element.nextElementSibling;
          if (next != null) {
            _elementKey++;
            _elements[_elementKey] = next;
            result = _elementKey;
          }
          break;
        case 'prev':
          final prev = element.previousElementSibling;
          if (prev != null) {
            _elementKey++;
            _elements[_elementKey] = prev;
            result = _elementKey;
          }
          break;
        case 'append':
          final htmlToAppend = methodArgs[0];
          final newNodes = parse(htmlToAppend).children;
          for (var node in newNodes) {
            element.append(node);
          }
          break;
        case 'prepend':
          final htmlToPrepend = methodArgs[0];
          final newNodes = parse(htmlToPrepend).children;
          for (var node in newNodes.reversed) {
            element.insertBefore(node, element.firstChild);
          }
          break;
        case 'empty':
          element.children.clear();
          break;
        case 'remove':
          element.remove();
          break;
        default:
          result = 'Unsupported method: $method';
      }

      return result;
    });

    runtime.evaluate('''
class Element {
  constructor(key) {
    this._key = key;
  }

  _call(method, args = []) {
    return sendMessage("element_call", JSON.stringify([method, this._key, args]));
  }

  text() { return this._call("text"); }
  html() { return this._call("html"); }
  outerHtml() { return this._call("outerHtml"); }
  val() { return this._call("val"); }
  attr(name) { return this._call("attr", [name]); }
  hasClass(cls) { return this._call("hasClass", [cls]); }

  addClass(cls) { this._call("addClass", [cls]); return this; }
  removeClass(cls) { this._call("removeClass", [cls]); return this; }
  setAttr(name, value) { this._call("setAttr", [name, value]); return this; }
  removeAttr(name) { this._call("removeAttr", [name]); return this; }
  setVal(value) { this._call("setVal", [value]); return this; }

  append(html) { this._call("append", [html]); return this; }
  prepend(html) { this._call("prepend", [html]); return this; }
  empty() { this._call("empty"); return this; }
  remove() { this._call("remove"); return this; }

  children() {
    const keys = JSON.parse(this._call("children"));
    return new ElementCollection(keys.map(k => new Element(k)));
  }

  find(selector) {
    const keys = JSON.parse(this._call("find", [selector]));
    return new ElementCollection(keys.map(k => new Element(k)));
  }

  parent() {
    return new Element(this._call("parent"));
  }

  next() {
    return new Element(this._call("next"));
  }

  prev() {
    return new Element(this._call("prev"));
  }

  first() {
    return new Element(this._call("first"));
  }

  last() {
    return new Element(this._call("last"));
  }
}

class ElementCollection {
  constructor(elements) {
    this.elements = elements;
  }

  text() {
    return this.map(function(i, el) {
      return el.text();
    }).toArray().join("\\n") ?? "";
  }

  html() {
    return this.first()?.html();
  }

  outerHtml() {
    return this.first()?.outerHtml();
  }

  attr(name) {
    return this.first()?.attr(name);
  }

  hasClass(cls) {
    return this.first()?.hasClass(cls);
  }

  each(fn) {
    this.elements.forEach((el, i) => fn(i, el));
    return this;
  }

  map(fn) {
    return new ElementCollection(this.elements.map((el, i) => fn(i, el)));
  }

  filter(fn) {
    return new ElementCollection(this.elements.filter(function (el, i) {
      try {
        return fn(i, el);
      } catch (_) {
        return false;
      }
    }));
  }

  addClass(cls) {
    this.elements.forEach(el => el.addClass(cls));
    return this;
  }

  removeClass(cls) {
    this.elements.forEach(el => el.removeClass(cls));
    return this;
  }

  setAttr(name, value) {
    this.elements.forEach(el => el.setAttr(name, value));
    return this;
  }

  removeAttr(name) {
    this.elements.forEach(el => el.removeAttr(name));
    return this;
  }

  setVal(value) {
    this.elements.forEach(el => el.setVal(value));
    return this;
  }

  append(html) {
    this.elements.forEach(el => el.append(html));
    return this;
  }

  prepend(html) {
    this.elements.forEach(el => el.prepend(html));
    return this;
  }

  empty() {
    this.elements.forEach(el => el.empty());
    return this;
  }

  remove() {
    this.elements.forEach(el => el.remove());
    return this;
  }

  find(selector) {
    const found = this.elements.flatMap(el => {
      const keys = JSON.parse(el._call("find", [selector]));
      return keys.map(k => new Element(k));
    });
    return new ElementCollection(found);
  }

  children() {
    const children = this.elements.flatMap(el => {
      const keys = JSON.parse(el._call("children"));
      return keys.map(k => new Element(k));
    });
    return new ElementCollection(children);
  }

  parent() {
    const parents = this.elements.map(el => new Element(el._call("parent")));
    return new ElementCollection(parents);
  }

  next() {
    const nextEls = this.elements.map(el => new Element(el._call("next")));
    return new ElementCollection(nextEls);
  }

  prev() {
    const prevEls = this.elements.map(el => new Element(el._call("prev")));
    return new ElementCollection(prevEls);
  }

  first() {
    return this.get(0);
  }

  last() {
    return this.get(this.elements.length - 1);
  }

  get(index) {
    return this.elements[index] || new Stub();
  }

  length() {
    return this.elements.length;
  }

  toArray() {
    return this.elements;
  }

  [Symbol.iterator]() {
    return this.elements[Symbol.iterator]();
  }
}

class Stub {
  text() {
    return null;
  }
  html() {
    return null;
  }
  outerHtml() {
    return null;
  }
  val() {
    return null;
  }
  attr(name) {
    return null;
  }
  hasClass(cls) {
    return false;
  }
}

function load(html) {
  const rootKey = sendMessage("load", JSON.stringify([html]));
  const root = new Element(rootKey);

  const \$ = function(input) {
    if (input instanceof ElementCollection) {
      return input;
    } else if (input instanceof Element) {
      return input;
    } else if (typeof input === "string") {
      return root.find(input); // returns ElementCollection
    } else if (input && input._key) {
      return new ElementCollection([new Element(input._key)]);
    } else {
      return new ElementCollection([new Element(input)]);
    }
  };

  \$.html = function() {
    return root.html();
  };
  \$.root = root;
  \$.Element = Element;
  \$.Collection = ElementCollection;

  return \$;
}
  ''');
  }

  void dispose() {
    if (_elements.isEmpty) return;
    _elements.clear();
    _elementKey = 0;
  }
}
