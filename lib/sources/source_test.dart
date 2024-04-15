import 'package:mangayomi/models/source.dart';

//For testing purposes, set to true
const useTestSourceCode = false;

final testSourceModelList = [
  Source(
      name: "Test Source",
      // Example: https://gogoanime3.net
      baseUrl: "",
      // source code
      sourceCode: testSourceCode,
      // Example: en
      lang: "",
      // Example: false for anime or true for manga
      isManga: false)
];

const testSourceCode = r'''
import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class TestSource extends MProvider {
  TestSource({required this.source});

  MSource source;

  final Client client = Client(source);

  @override
  bool get supportsLatest => true;

  @override
  Map<String, String> getHeaders(String url) {
    // TODO: implement
  }
  
  @override
  Future<MPages> getPopular(int page) async {
    // TODO: implement
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    // TODO: implement
  }

  @override
  Future<MPages> search(String query, int page, FilterList filterList) async {
    // TODO: implement
  }

  @override
  Future<MManga> getDetail(String url) async {
    // TODO: implement
  }
  
  // For anime episode video list
  @override
  Future<List<MVideo>> getVideoList(String url) async {
    // TODO: implement
  }

  // For manga chapter pages
  @override
  Future<List<String>> getPageList(String url) async{
    // TODO: implement
  }

  @override
  List<dynamic> getFilterList() {
    // TODO: implement
  }

  @override
  List<dynamic> getSourcePreferences() {
    // TODO: implement
  }
}

TestSource main(MSource source) {
  return TestSource(source:source);
}

''';
