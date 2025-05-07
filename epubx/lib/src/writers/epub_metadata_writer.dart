import 'package:epubx/src/schema/opf/epub_metadata.dart';
import 'package:epubx/src/schema/opf/epub_version.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubMetadataWriter {
  static const _dc_namespace = 'http://purl.org/dc/elements/1.1/';
  static const _opf_namespace = 'http://www.idpf.org/2007/opf';

  static void writeMetadata(
      XmlBuilder builder, EpubMetadata? meta, EpubVersion? version) {
    builder.element('metadata',
        namespaces: {_opf_namespace: 'opf', _dc_namespace: 'dc'}, nest: () {
      meta!
        ..Titles?.forEach((item) =>
            builder.element('title', nest: item, namespace: _dc_namespace))
        ..Creators?.forEach((item) =>
            builder.element('creator', namespace: _dc_namespace, nest: () {
              if (item.Role != null) {
                builder.attribute('role', item.Role!,
                    namespace: _opf_namespace);
              }
              if (item.FileAs != null) {
                builder.attribute('file-as', item.FileAs!,
                    namespace: _opf_namespace);
              }
              builder.text(item.Creator!);
            }))
        ..Subjects?.forEach((item) =>
            builder.element('subject', namespace: _dc_namespace, nest: item))
        ..Publishers?.forEach((item) =>
            builder.element('publisher', namespace: _dc_namespace, nest: item))
        ..Contributors?.forEach((item) =>
            builder.element('contributor', namespace: _dc_namespace, nest: () {
              if (item.Role != null) {
                builder.attribute('role', item.Role!,
                    namespace: _opf_namespace);
              }
              if (item.FileAs != null) {
                builder.attribute('file-as', item.FileAs!,
                    namespace: _opf_namespace);
              }
              builder.text(item.Contributor!);
            }))
        ..Dates?.forEach((date) =>
            builder.element('date', namespace: _dc_namespace, nest: () {
              if (date.Event != null) {
                builder.attribute('event', date.Event!,
                    namespace: _opf_namespace);
              }
              builder.text(date.Date!);
            }))
        ..Types?.forEach((type) =>
            builder.element('type', namespace: _dc_namespace, nest: type))
        ..Formats?.forEach((format) =>
            builder.element('format', namespace: _dc_namespace, nest: format))
        ..Identifiers?.forEach((id) =>
            builder.element('identifier', namespace: _dc_namespace, nest: () {
              if (id.Id != null) builder.attribute('id', id.Id!);
              if (id.Scheme != null) {
                builder.attribute('scheme', id.Scheme!,
                    namespace: _opf_namespace);
              }
              builder.text(id.Identifier!);
            }))
        ..Sources?.forEach((item) =>
            builder.element('source', namespace: _dc_namespace, nest: item))
        ..Languages?.forEach((item) =>
            builder.element('language', namespace: _dc_namespace, nest: item))
        ..Relations?.forEach((item) =>
            builder.element('relation', namespace: _dc_namespace, nest: item))
        ..Coverages?.forEach((item) =>
            builder.element('coverage', namespace: _dc_namespace, nest: item))
        ..Rights?.forEach((item) =>
            builder.element('rights', namespace: _dc_namespace, nest: item))
        ..MetaItems?.forEach((metaitem) => builder.element('meta', nest: () {
              if (version == EpubVersion.Epub2) {
                if (metaitem.Name != null) {
                  builder.attribute('name', metaitem.Name!);
                }
                if (metaitem.Content != null) {
                  builder.attribute('content', metaitem.Content!);
                }
              } else if (version == EpubVersion.Epub3) {
                if (metaitem.Id != null) {
                  builder.attribute('id', metaitem.Id!);
                }
                if (metaitem.Refines != null) {
                  builder.attribute('refines', metaitem.Refines!);
                }
                if (metaitem.Property != null) {
                  builder.attribute('property', metaitem.Property!);
                }
                if (metaitem.Scheme != null) {
                  builder.attribute('scheme', metaitem.Scheme!);
                }
              }
            }));

      if (meta.Description != null) {
        builder.element('description',
            namespace: _dc_namespace, nest: meta.Description);
      }
    });
  }
}
