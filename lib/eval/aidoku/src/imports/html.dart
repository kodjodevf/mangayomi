import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:pseudom/pseudom.dart' as pseudom;
import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../store/global_store.dart';

class HtmlImports {
  HtmlImports({required this.store, required this.memoryHelper});

  final GlobalStore store;
  final MemoryHelper memoryHelper;

  static const namespace = 'html';

  ModuleImports build() {
    return {
      'parse': ImportExportKind.function((args) {
        final html = (args[0] as num).toInt();
        final htmlLength = (args[1] as num).toInt();
        final baseUrl = (args[2] as num).toInt();
        final baseUrlLength = (args[3] as num).toInt();
        return parse(html, htmlLength, baseUrl, baseUrlLength);
      }),
      'parse_fragment': ImportExportKind.function((args) {
        final html = (args[0] as num).toInt();
        final htmlLength = (args[1] as num).toInt();
        final baseUrl = (args[2] as num).toInt();
        final baseUrlLength = (args[3] as num).toInt();
        return parseFragment(html, htmlLength, baseUrl, baseUrlLength);
      }),
      'escape': ImportExportKind.function((args) {
        final text = (args[0] as num).toInt();
        final textLength = (args[1] as num).toInt();
        return escape(text, textLength);
      }),
      'unescape': ImportExportKind.function((args) {
        final text = (args[0] as num).toInt();
        final textLength = (args[1] as num).toInt();
        return unescape(text, textLength);
      }),
      'kind': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return kind(descriptor);
      }),
      'child_nodes': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return childNodes(descriptor);
      }),
      'has_attr': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final attrOffset = (args[1] as num).toInt();
        final attrLength = (args[2] as num).toInt();
        return hasAttr(descriptor, attrOffset, attrLength);
      }),
      'set_attr': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final attrOffset = (args[1] as num).toInt();
        final attrLength = (args[2] as num).toInt();
        final valueOffset = (args[3] as num).toInt();
        final valueLength = (args[4] as num).toInt();
        return setAttr(
          descriptor,
          attrOffset,
          attrLength,
          valueOffset,
          valueLength,
        );
      }),
      'remove_attr': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final attrOffset = (args[1] as num).toInt();
        final attrLength = (args[2] as num).toInt();
        return removeAttr(descriptor, attrOffset, attrLength);
      }),
      'children': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return children(descriptor);
      }),
      'set_text': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final text = (args[1] as num).toInt();
        final textLength = (args[2] as num).toInt();
        return setText(descriptor, text, textLength);
      }),
      'set_html': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final text = (args[1] as num).toInt();
        final textLength = (args[2] as num).toInt();
        return setHtml(descriptor, text, textLength);
      }),
      'prepend': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final text = (args[1] as num).toInt();
        final textLength = (args[2] as num).toInt();
        return prepend(descriptor, text, textLength);
      }),
      'append': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final text = (args[1] as num).toInt();
        final textLength = (args[2] as num).toInt();
        return append(descriptor, text, textLength);
      }),
      'base_uri': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return baseUri(descriptor);
      }),
      'own_text': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return ownText(descriptor);
      }),
      'data': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return data(descriptor);
      }),
      'id': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return id(descriptor);
      }),
      'tag_name': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return tagName(descriptor);
      }),
      'class_name': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return className(descriptor);
      }),
      'has_class': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final classOffset = (args[1] as num).toInt();
        final classLength = (args[2] as num).toInt();
        return hasClass(descriptor, classOffset, classLength);
      }),
      'add_class': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final classOffset = (args[1] as num).toInt();
        final classLength = (args[2] as num).toInt();
        return addClass(descriptor, classOffset, classLength);
      }),
      'remove_class': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final classOffset = (args[1] as num).toInt();
        final classLength = (args[2] as num).toInt();
        return removeClass(descriptor, classOffset, classLength);
      }),
      'first': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return first(descriptor);
      }),
      'last': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return last(descriptor);
      }),
      'get': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final index = (args[1] as num).toInt();
        return get(descriptor, index);
      }),
      'size': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return size(descriptor);
      }),
      'parent': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return parent(descriptor);
      }),
      'siblings': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return siblings(descriptor);
      }),
      'next': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return next(descriptor);
      }),
      'previous': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return previous(descriptor);
      }),
      'attr': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final key = (args[1] as num).toInt();
        final keyLength = (args[2] as num).toInt();
        return attr(descriptor, key, keyLength);
      }),
      'outer_html': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return outerHtml(descriptor);
      }),
      'remove': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return remove(descriptor);
      }),
      'select': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final query = (args[1] as num).toInt();
        final queryLength = (args[2] as num).toInt();
        return select(descriptor, query, queryLength);
      }),
      'select_first': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final query = (args[1] as num).toInt();
        final queryLength = (args[2] as num).toInt();
        return selectFirst(descriptor, query, queryLength);
      }),
      'text': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return text(descriptor);
      }),
      'untrimmed_text': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return untrimmedText(descriptor);
      }),
      'html': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return html(descriptor);
      }),
    };
  }

  static final Expando<String> docBaseUrls = Expando<String>();

  int parse(int htmlPtr, int htmlLen, int baseUrlPtr, int baseUrlLen) {
    try {
      final htmlStr = memoryHelper.readString(htmlPtr, htmlLen);
      final baseUrl = baseUrlLen > 0
          ? memoryHelper.readString(baseUrlPtr, baseUrlLen)
          : null;
      final doc = html_parser.parse(htmlStr, sourceUrl: baseUrl);
      if (baseUrl != null) {
        docBaseUrls[doc] = baseUrl;
      }
      return store.store(doc);
    } catch (_) {
      return -3; // invalidHtml
    }
  }

  int parseFragment(int htmlPtr, int htmlLen, int baseUrlPtr, int baseUrlLen) {
    try {
      final htmlStr = memoryHelper.readString(htmlPtr, htmlLen);
      final baseUrl = baseUrlLen > 0
          ? memoryHelper.readString(baseUrlPtr, baseUrlLen)
          : null;
      final doc = html_parser.parse(htmlStr, sourceUrl: baseUrl);
      if (baseUrl != null) {
        docBaseUrls[doc] = baseUrl;
      }
      return store.store(doc);
    } catch (_) {
      return -3;
    }
  }

  int escape(int textPtr, int textLen) {
    try {
      final textStr = memoryHelper.readString(textPtr, textLen);
      final escaped = textStr
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;')
          .replaceAll("'", '&#39;');
      return store.store(escaped);
    } catch (_) {
      return -2;
    }
  }

  int unescape(int textPtr, int textLen) {
    try {
      final textStr = memoryHelper.readString(textPtr, textLen);
      final unescaped = textStr
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll('&apos;', "'");
      return store.store(unescaped);
    } catch (_) {
      return -2;
    }
  }

  int kind(int descriptor) {
    final item = store.fetch(descriptor);
    if (item == null) return -1;
    if (item is dom.Document) return 7;
    if (item is dom.Element) return 5;
    if (item is List<dom.Element> || item is dom.NodeList) return 6;
    if (item is dom.Comment) return 4;
    if (item is dom.Text) return 2;
    if (item is dom.Node) return 1;
    return 0;
  }

  int childNodes(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Node) {
      return store.store(item.nodes.toList());
    } else if (item is List) {
      final list = <dom.Node>[];
      for (final el in item) {
        if (el is dom.Node) list.addAll(el.nodes);
      }
      return store.store(list);
    }
    return -1;
  }

  int hasAttr(int descriptor, int attrOffset, int attrLength) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final attrName = memoryHelper.readString(attrOffset, attrLength);
    return item.attributes.containsKey(attrName) ? 1 : 0;
  }

  int setAttr(
    int descriptor,
    int attrOffset,
    int attrLength,
    int valOffset,
    int valLength,
  ) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final key = memoryHelper.readString(attrOffset, attrLength);
    final val = memoryHelper.readString(valOffset, valLength);
    if (val.isEmpty) {
      item.attributes.remove(key);
    } else {
      item.attributes[key] = val;
    }
    return 0;
  }

  int removeAttr(int descriptor, int attrOffset, int attrLength) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final key = memoryHelper.readString(attrOffset, attrLength);
    item.attributes.remove(key);
    return 0;
  }

  int children(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element) {
      return store.store(item.children.toList());
    } else if (item is dom.Document) {
      return store.store(item.children.toList());
    } else if (item is dom.DocumentFragment) {
      return store.store(item.children.toList());
    } else if (item is List) {
      final list = <dom.Element>[];
      for (final el in item) {
        if (el is dom.Element) list.addAll(el.children);
      }
      return store.store(list);
    }
    return -1;
  }

  int setText(int descriptor, int textPtr, int textLen) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    item.text = memoryHelper.readString(textPtr, textLen);
    return 0;
  }

  int setHtml(int descriptor, int textPtr, int textLen) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    item.innerHtml = memoryHelper.readString(textPtr, textLen);
    return 0;
  }

  int prepend(int descriptor, int textPtr, int textLen) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final htmlStr = memoryHelper.readString(textPtr, textLen);
    final fragment = html_parser.parseFragment(htmlStr);
    item.nodes.insertAll(0, fragment.nodes);
    return 0;
  }

  int append(int descriptor, int textPtr, int textLen) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final htmlStr = memoryHelper.readString(textPtr, textLen);
    final fragment = html_parser.parseFragment(htmlStr);
    item.nodes.addAll(fragment.nodes);
    return 0;
  }

  int baseUri(int descriptor) {
    final item = store.fetch(descriptor);
    String? uri;
    if (item is dom.Document) {
      uri = docBaseUrls[item];
    } else if (item is dom.Node) {
      final doc = _findDocument(item);
      if (doc != null) uri = docBaseUrls[doc];
    }
    return store.store(uri ?? '');
  }

  int ownText(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final text = item.nodes
        .whereType<dom.Text>()
        .map((t) => t.text)
        .join()
        .trim();
    return store.store(text);
  }

  int data(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element) {
      return store.store(item.text);
    } else if (item is dom.Comment) {
      return store.store(item.data ?? '');
    }
    return -1;
  }

  int id(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    return store.store(item.id);
  }

  int tagName(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    return store.store(item.localName ?? '');
  }

  int className(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    return store.store(item.className);
  }

  int hasClass(int descriptor, int classOffset, int classLength) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final className = memoryHelper.readString(classOffset, classLength);
    return item.classes.contains(className) ? 1 : 0;
  }

  int addClass(int descriptor, int classOffset, int classLength) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final className = memoryHelper.readString(classOffset, classLength);
    item.classes.add(className);
    return 0;
  }

  int removeClass(int descriptor, int classOffset, int classLength) {
    final item = store.fetch(descriptor);
    if (item is! dom.Element) return -1;
    final className = memoryHelper.readString(classOffset, classLength);
    item.classes.remove(className);
    return 0;
  }

  int first(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is List && item.isNotEmpty) {
      return store.store(item.first);
    }
    return -5; // noResult
  }

  int last(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is List && item.isNotEmpty) {
      return store.store(item.last);
    }
    return -5;
  }

  int get(int descriptor, int index) {
    final item = store.fetch(descriptor);
    if (item is List && index >= 0 && index < item.length) {
      return store.store(item[index]);
    }
    return -5;
  }

  int size(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is List) return item.length;
    return 0;
  }

  int parent(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element && item.parent != null) {
      return store.store(item.parent!);
    } else if (item is dom.Node && item.parentNode != null) {
      return store.store(item.parentNode!);
    }
    return -5;
  }

  int siblings(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element && item.parent != null) {
      final sibs = item.parent!.children.where((e) => e != item).toList();
      return store.store(sibs);
    }
    return -5;
  }

  int next(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element && item.parent != null) {
      final children = item.parent!.children;
      final idx = children.indexOf(item);
      if (idx >= 0 && idx + 1 < children.length) {
        return store.store(children[idx + 1]);
      }
    }
    return -5;
  }

  int previous(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element && item.parent != null) {
      final children = item.parent!.children;
      final idx = children.indexOf(item);
      if (idx > 0) {
        return store.store(children[idx - 1]);
      }
    }
    return -5;
  }

  static dom.Document? _findDocument(dom.Node node) {
    dom.Node curr = node;
    while (curr.parentNode != null) {
      curr = curr.parentNode!;
    }
    return curr is dom.Document ? curr : null;
  }

  String _resolveAbsoluteUrl(dynamic node, String val) {
    if (val.startsWith('http://') || val.startsWith('https://')) {
      return val;
    }
    if (val.startsWith('//')) {
      return 'https:$val';
    }

    String? baseUrl;
    if (node is dom.Document) {
      baseUrl = docBaseUrls[node];
    } else if (node is dom.Node) {
      final doc = _findDocument(node);
      if (doc != null) {
        baseUrl = docBaseUrls[doc];
      }
    }

    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        final base = Uri.parse(baseUrl);
        return base.resolve(val).toString();
      } catch (_) {}
    }
    return val;
  }

  int attr(int descriptor, int key, int keyLength) {
    final item = store.fetch(descriptor);
    final keyStr = memoryHelper.readString(key, keyLength);

    String? val;
    if (item is dom.Element) {
      if (keyStr.startsWith('abs:')) {
        final rawKey = keyStr.substring(4);
        val = item.attributes[rawKey];
        if (val != null) {
          val = _resolveAbsoluteUrl(item, val);
        }
      } else {
        val = item.attributes[keyStr];
      }
    } else if (item is List && item.isNotEmpty && item.first is dom.Element) {
      final el = item.first as dom.Element;
      if (keyStr.startsWith('abs:')) {
        final rawKey = keyStr.substring(4);
        val = el.attributes[rawKey];
        if (val != null) {
          val = _resolveAbsoluteUrl(el, val);
        }
      } else {
        val = el.attributes[keyStr];
      }
    }

    if (val != null) {
      return store.store(val);
    }
    return -5;
  }

  int outerHtml(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element) {
      return store.store(item.outerHtml);
    } else if (item is dom.Document) {
      return store.store(item.outerHtml);
    } else if (item is dom.DocumentFragment) {
      return store.store(
        item.nodes
            .map((n) => n is dom.Element ? n.outerHtml : (n.text ?? ''))
            .join(),
      );
    }
    return -5;
  }

  int remove(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element) {
      item.remove();
      return 0;
    }
    return -5;
  }

  int select(int descriptor, int query, int queryLength) {
    final item = store.fetch(descriptor);
    final queryStr = memoryHelper.readString(query, queryLength);

    try {
      if (item is dom.Document ||
          item is dom.Element ||
          item is dom.DocumentFragment) {
        return store.store(_selectOnNode(item, queryStr));
      } else if (item is List) {
        final list = <dom.Element>[];
        for (final el in item) {
          list.addAll(_selectOnNode(el, queryStr));
        }
        return store.store(list);
      }
      return -5;
    } catch (_) {
      return -4; // invalidQuery
    }
  }

  int selectFirst(int descriptor, int query, int queryLength) {
    final item = store.fetch(descriptor);
    final queryStr = memoryHelper.readString(query, queryLength);

    try {
      if (item is dom.Document ||
          item is dom.Element ||
          item is dom.DocumentFragment) {
        final el = _selectFirstOnNode(item, queryStr);
        if (el != null) return store.store(el);
      } else if (item is List) {
        for (final el in item) {
          final found = _selectFirstOnNode(el, queryStr);
          if (found != null) return store.store(found);
        }
      }
      return -5;
    } catch (_) {
      return -4;
    }
  }

  void deferRemove(int desc) {
    store.remove(desc);
  }

  int text(int descriptor) {
    final item = store.fetch(descriptor);
    String? t;
    if (item is dom.Element) {
      t = item.text.trim();
    } else if (item is dom.Document) {
      t = item.body?.text.trim() ?? item.outerHtml.trim();
    } else if (item is dom.DocumentFragment) {
      t = item.text?.trim();
    } else if (item is List && item.isNotEmpty) {
      t = item
          .map((e) => e is dom.Element ? e.text.trim() : '$e')
          .join(' ')
          .trim();
    }

    if (t != null) {
      return store.store(t);
    }
    return -5;
  }

  int untrimmedText(int descriptor) {
    final item = store.fetch(descriptor);
    String? t;
    if (item is dom.Element) {
      t = item.text;
    } else if (item is dom.Text) {
      t = item.text;
    } else if (item is dom.Document) {
      t = item.body?.text ?? item.outerHtml;
    } else if (item is dom.DocumentFragment) {
      t = item.text ?? '';
    } else if (item is List) {
      t = item.map((e) => e is dom.Element ? e.text : '$e').join();
    }

    if (t != null) {
      return store.store(t);
    }
    return -5;
  }

  int html(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is dom.Element) {
      return store.store(item.innerHtml);
    } else if (item is dom.Document) {
      return store.store(item.outerHtml);
    } else if (item is dom.DocumentFragment) {
      return store.store(
        item.nodes
            .map((n) => n is dom.Element ? n.outerHtml : (n.text ?? ''))
            .join(),
      );
    } else if (item is List) {
      return store.store(
        item.map((e) => e is dom.Element ? e.outerHtml : '$e').join('\n'),
      );
    }
    return -5;
  }
}

bool _pseudoInitialized = false;

void _initPseudoSelector() {
  if (_pseudoInitialized) return;
  _pseudoInitialized = true;

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

  String getWholeText(dom.Element element) {
    return element.nodes.map((node) {
      if (node is dom.Text) return node.text;
      if (node is dom.Element) return getWholeText(node);
      return '';
    }).join();
  }

  String getWholeOwnText(dom.Element element) {
    return element.nodes.whereType<dom.Text>().map((t) => t.text).join();
  }

  bool nthChild(dom.Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children;
    final index = siblings.indexOf(element) + 1; // 1-based
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool nthLastChild(dom.Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children;
    final index =
        siblings.length - siblings.indexOf(element); // 1-based from end
    final (a, b) = parseNth(args);
    return matchesNth(index, a, b);
  }

  bool nthOfType(dom.Element element, String? args) {
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

  bool nthLastOfType(dom.Element element, String? args) {
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

  bool has(dom.Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    final res = parent == null
        ? false
        : pseudom.parse(args).selectFirst(parent) == element;
    return res ? res : pseudom.parse(args).selectFirst(element) != null;
  }

  bool inot(dom.Element element, String? args) {
    if (args == null) return false;
    final parent = element.parent;
    final res = parent == null
        ? false
        : pseudom.parse(args).selectFirst(parent) != element;
    return res ? res : pseudom.parse(args).selectFirst(element) == null;
  }

  bool contains(dom.Element element, String? args) {
    final text = args ?? '';
    return element.text.toLowerCase().contains(text.toLowerCase());
  }

  bool containsOwn(dom.Element element, String? args) {
    final text = args ?? '';
    final ownText = element.nodes
        .whereType<dom.Text>()
        .map((t) => t.text)
        .join();
    return ownText.toLowerCase().contains(text.toLowerCase());
  }

  bool matches(dom.Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args, caseSensitive: false);
      return reg.hasMatch(element.text);
    } catch (_) {
      return false;
    }
  }

  bool containsData(dom.Element element, String? args) {
    final data = args ?? '';
    if (element.localName == 'script' || element.localName == 'style') {
      return element.text.toLowerCase().contains(data.toLowerCase());
    }
    return false;
  }

  bool containsWholeText(dom.Element element, String? args) {
    final text = args ?? '';
    return getWholeText(element).contains(text);
  }

  bool containsWholeOwnText(dom.Element element, String? args) {
    final text = args ?? '';
    return getWholeOwnText(element).contains(text);
  }

  bool matchesWholeText(dom.Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args);
      return reg.hasMatch(getWholeText(element));
    } catch (_) {
      return false;
    }
  }

  bool matchesWholeOwnText(dom.Element element, String? args) {
    if (args == null) return false;
    try {
      final reg = RegExp(args);
      return reg.hasMatch(getWholeOwnText(element));
    } catch (_) {
      return false;
    }
  }

  bool isSelector(dom.Element element, String? args) {
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

  bool firstChild(dom.Element element, String? args) {
    return element.previousElementSibling == null;
  }

  bool lastChild(dom.Element element, String? args) {
    return element.nextElementSibling == null;
  }

  bool firstOfType(dom.Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.isNotEmpty && siblings.first == element;
  }

  bool lastOfType(dom.Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.isNotEmpty && siblings.last == element;
  }

  bool onlyChild(dom.Element element, String? args) {
    return element.previousElementSibling == null &&
        element.nextElementSibling == null;
  }

  bool onlyOfType(dom.Element element, String? args) {
    final parent = element.parent;
    if (parent == null) return false;
    final siblings = parent.children.where(
      (e) => e.localName == element.localName,
    );
    return siblings.length == 1;
  }

  bool empty(dom.Element element, String? args) {
    return element.children.isEmpty && element.text.trim().isEmpty;
  }

  bool root(dom.Element element, String? args) {
    return element.parent == null;
  }

  bool lt(dom.Element element, String? args) {
    if (args == null) return false;
    final n = int.tryParse(args);
    if (n == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final index = parent.children.indexOf(element);
    return index < n;
  }

  bool gt(dom.Element element, String? args) {
    if (args == null) return false;
    final n = int.tryParse(args);
    if (n == null) return false;
    final parent = element.parent;
    if (parent == null) return false;
    final index = parent.children.indexOf(element);
    return index > n;
  }

  bool eq(dom.Element element, String? args) {
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

String _fixSelector(String query) {
  var fixed = query.replaceAll(':not', ':inot');
  fixed = fixed.replaceAllMapped(
    RegExp(r'\[([a-zA-Z0-9_-]+)\s*([\^$*~|]?=)\s*([^"\]\s]+)\]'),
    (match) {
      final attr = match.group(1);
      final op = match.group(2);
      final val = match.group(3);
      if (val != null && !val.startsWith('"') && !val.startsWith("'")) {
        return '[$attr$op"$val"]';
      }
      return match.group(0)!;
    },
  );
  return fixed;
}

List<dom.Element> _selectOnNode(dynamic node, String query) {
  _initPseudoSelector();
  final fixedQuery = _fixSelector(query);

  List<dom.Element> results = [];
  try {
    final parsed = pseudom.parse(fixedQuery);
    if (node is dom.Document) {
      final rootEl = node.documentElement ?? node.body;
      if (rootEl != null) {
        results = parsed.select(rootEl).toList();
      }
    } else if (node is dom.Element) {
      results = parsed.select(node).toList();
    } else if (node is dom.DocumentFragment) {
      for (final child in node.children) {
        results.addAll(parsed.select(child));
      }
    }
  } catch (_) {
    try {
      if (node is dom.Document) {
        results = node.querySelectorAll(query).toList();
      } else if (node is dom.Element) {
        results = node.querySelectorAll(query).toList();
      } else if (node is dom.DocumentFragment) {
        results = node.querySelectorAll(query).toList();
      }
    } catch (_) {}
  }
  return results;
}

dom.Element? _selectFirstOnNode(dynamic node, String query) {
  _initPseudoSelector();
  final fixedQuery = _fixSelector(query);

  try {
    final parsed = pseudom.parse(fixedQuery);
    if (node is dom.Document) {
      final rootEl = node.documentElement ?? node.body;
      if (rootEl != null) {
        return parsed.selectFirst(rootEl);
      }
    } else if (node is dom.Element) {
      return parsed.selectFirst(node);
    } else if (node is dom.DocumentFragment) {
      for (final child in node.children) {
        final found = parsed.selectFirst(child);
        if (found != null) return found;
      }
    }
  } catch (_) {
    try {
      if (node is dom.Document) {
        return node.querySelector(query);
      } else if (node is dom.Element) {
        return node.querySelector(query);
      } else if (node is dom.DocumentFragment) {
        return node.querySelector(query);
      }
    } catch (_) {}
  }
  return null;
}
