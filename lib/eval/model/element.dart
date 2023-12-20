import 'package:html/dom.dart';
import 'package:mangayomi/utils/extensions.dart';

class MElement {
  MElement(this._element);

  final Element? _element;

  String? get outerHTML => _element?.outerHtml;

  String? get innerHtml => _element?.innerHtml;

  String? get text => _element?.text;

  String? get className => _element?.className;

  String? get localName => _element?.localName;

  String? get namespaceUri => _element?.namespaceUri;

  String? get getSrc => _element?.getSrc;

  String? get getImg => _element?.getImg;

  String? get getHref => _element?.getHref;

  String? get getDataSrc => _element?.getDataSrc;

  List<MElement>? get children =>
      _element?.children.map((e) => MElement(e)).toList();

  MElement? get parent => MElement(_element?.parent);

  MElement? get nextElementSibling => MElement(_element?.nextElementSibling);
  

  MElement? get previousElementSibling =>
      MElement(_element?.previousElementSibling);

  List<MElement>? select(String selector) {
    return _element?.select(selector)?.map((e) => MElement(e)).toList();
  }

  MElement? selectFirst(String selector) {
    return MElement(_element?.selectFirst(selector));
  }

  String? attr(String attribute) {
    return _element?.attr(attribute);
  }
}
