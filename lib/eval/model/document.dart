import 'package:html/dom.dart';
import 'package:mangayomi/eval/model/element.dart';
import 'package:mangayomi/utils/extensions.dart';

class MDocument {
  const MDocument(this._document);

  final Document? _document;

  MElement? get body => MElement(_document?.body);

  MElement? get documentElement => MElement(_document?.documentElement);

  MElement? get head => MElement(_document?.head);

  MElement? get parent => MElement(_document?.parent);

  String? get outerHtml => _document?.outerHtml;

  String? get text => _document?.text;

  List<MElement>? get children =>
      _document?.children.map((e) => MElement(e)).toList();

  List<MElement>? select(String selector) {
    return _document?.select(selector)?.map((e) => MElement(e)).toList();
  }

  MElement? selectFirst(String selector) {
    return MElement(_document?.selectFirst(selector));
  }
}
