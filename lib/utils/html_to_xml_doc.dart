// import 'package:html/dom.dart';
// import 'package:html/parser.dart';
// import 'package:xml/xml.dart';
// import 'package:xml/xpath.dart';

// class HtmlToXml {
//   HtmlToXml();

//   static XmlDocument fromHtml(String html) => fromDocument(parse(html));

//   static XmlDocument? from(Node node) => switch (node) {
//         final Document document => fromDocument(document),
//         final Element element => fromElement(element),
//         _ => null
//       };

//   static XmlDocument fromDocument(Document doc) {
//     final builder = XmlBuilder();
//     builder.processing('xml', 'version="1.0"');
//     builder.element('root', nest: () {
//       _convertElement(doc.documentElement!, builder);
//     });
//     return builder.buildDocument();
//   }

//   static void _convertElement(Element element, XmlBuilder builder) {
//     builder.element(element.localName!, nest: () {
//       element.attributes.forEach((key, value) {
//         builder.attribute(key.toString(), value);
//       });
//       for (final node in element.nodes) {
//         if (node is Element) {
//           _convertElement(node, builder);
//         } else if (node is Text) {
//           builder.text(node.text);
//         } else if (node is Comment) {
//           builder.comment(node.data!);
//         } else if (node is DocumentType) {
//           builder.doctype(node.name!,
//               publicId: node.publicId, systemId: node.systemId);
//         }
//       }
//     });
//   }

//   static XmlDocument fromElement(Element element) {
//     final builder = XmlBuilder();
//     _convertElement(element, builder);
//     return builder.buildDocument();
//   }
// }

// extension XmlDocumentExtension on XmlDocument {
//   String? query(String expression) {
//     final list = queryXpath(expression);
//     return list.isNotEmpty ? list.first : null;
//   }

//   List<String> queryXpath(String expression) {
//     try {
//       var query = xpath(expression);
//       if (query.isNotEmpty) {
//         return query
//             .map((e) => (e.value ?? "").trim().trimLeft().trimRight())
//             .toList();
//       }
//     } catch (_) {}
//     return [];
//   }
// }
