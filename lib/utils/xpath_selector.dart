import 'package:html/parser.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

HtmlXPath xpathSelector(String html) {
  final html1 = parse(html).documentElement!;
  return HtmlXPath.node(html1);
}
