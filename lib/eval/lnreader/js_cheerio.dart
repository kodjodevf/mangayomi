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
      _elements[_elementKey] = doc.documentElement;
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
    function \$(key) {
      return {
        _key: key,
        _call: function(method, args) {
          if (!args) {
            args = [];
          }
          return sendMessage("element_call", JSON.stringify([method, this._key, args]));
        },
        text: function() {
          return this._call("text");
        },
        html: function() {
          return this._call("html");
        },
        outerHtml: function() {
          return this._call("outerHtml");
        },
        addClass: function(cls) {
          this._call("addClass", [cls]);
          return this;
        },
        removeClass: function(cls) {
          this._call("removeClass", [cls]);
          return this;
        },
        hasClass: function(cls) {
          return this._call("hasClass", [cls]);
        },
        attr: function(name) {
          return this._call("attr", [name]);
        },
        setAttr: function(name, value) {
          this._call("setAttr", [name, value]);
          return this;
        },
        removeAttr: function(name) {
          this._call("removeAttr", [name]);
          return this;
        },
        val: function() {
          return this._call("val");
        },
        setVal: function(value) {
          this._call("setVal", [value]);
          return this;
        },
        children: function() {
          let result = this._call("children");
          return JSON.parse(result).map(k => \$(k));
        },
        parent: function() {
          let k = this._call("parent");
          return \$(k);
        },
        find: function(selector) {
          let result = this._call("find", [selector]);
          return JSON.parse(result).map(k => \$(k));
        },
        first: function() {
          let k = this._call("first");
          return \$(k);
        },
        last: function() {
          let k = this._call("last");
          return \$(k);
        },
        next: function() {
          let k = this._call("next");
          return \$(k);
        },
        prev: function() {
          let k = this._call("prev");
          return \$(k);
        },
        append: function(html) {
          this._call("append", [html]);
          return this;
        },
        prepend: function(html) {
          this._call("prepend", [html]);
          return this;
        },
        empty: function() {
          this._call("empty");
          return this;
        },
        remove: function() {
          this._call("remove");
          return this;
        },
        each: function(fn) {
          this.children().forEach((child, i) => fn(child, i));
          return this;
        },
        map(fn) {
          return this.children().map((child, i) => fn(child, i));
        },
        filter(fn) {
          return this.children().filter((child, i) => fn(child, i));
        }
      };
    }

    function load(html) {
      const key = sendMessage("load", JSON.stringify([html]));
      return \$(key);
    }
  ''');
  }
}
