import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

class SchemaReader {
  static Future<EpubSchema> readSchema(Archive epubArchive) async {
    var result = EpubSchema();

    var rootFilePath = (await RootFilePathReader.getRootFilePath(epubArchive))!;
    var contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    result.ContentDirectoryPath = contentDirectoryPath;

    var package = await PackageReader.readPackage(epubArchive, rootFilePath);
    result.Package = package;

    var navigation = await NavigationReader.readNavigation(
        epubArchive, contentDirectoryPath, package);
    result.Navigation = navigation;

    return result;
  }
}
