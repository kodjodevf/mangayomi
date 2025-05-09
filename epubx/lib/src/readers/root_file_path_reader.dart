import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:xml/xml.dart' as xml;

class RootFilePathReader {
  static Future<String?> getRootFilePath(Archive epubArchive) async {
    const EPUB_CONTAINER_FILE_PATH = 'META-INF/container.xml';

    var containerFileEntry = epubArchive.files.firstWhereOrNull(
        (ArchiveFile file) => file.name == EPUB_CONTAINER_FILE_PATH);
    if (containerFileEntry == null) {
      throw Exception(
          'EPUB parsing error: $EPUB_CONTAINER_FILE_PATH file not found in archive.');
    }

    var containerDocument =
        xml.XmlDocument.parse(convert.utf8.decode(containerFileEntry.content));
    var packageElement = containerDocument
        .findAllElements('container',
            namespace: 'urn:oasis:names:tc:opendocument:xmlns:container')
        .firstWhereOrNull((xml.XmlElement? elem) => elem != null);
    if (packageElement == null) {
      throw Exception('EPUB parsing error: Invalid epub container');
    }

    var rootFileElement = packageElement.descendants.firstWhereOrNull(
        (xml.XmlNode testElem) =>
            (testElem is xml.XmlElement) &&
            'rootfile' == testElem.name.local) as xml.XmlElement;

    return rootFileElement.getAttribute('full-path');
  }
}
