import 'package:mangayomi/models/source.dart';

//For testing purposes, set to true
const useTestSourceCode = false;

final testSourceModel = Source(
    name: "Test Source",
    // Example: https://gogoanime3.net
    baseUrl: "",
    //
    sourceCode: testSourceCode,
    // Example: en
    lang: "",
    // Example: false for anime or true for manga
    isManga: false);

const testSourceCode = r'''
import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class TestSource extends MProvider {
  TestSource();

  @override
  Future<MPages> getPopular(MSource source, int page) async {
    // TODO: implement
  }

  @override
  Future<MPages> getLatestUpdates(MSource source, int page) async {
    // TODO: implement
  }

  @override
  Future<MPages> search(
      MSource source, String query, int page, FilterList filterList) async {
    // TODO: implement
  }

  @override
  Future<MManga> getDetail(MSource source, String url) async {
    // TODO: implement
  }
  
  // For anime videos
  @override
  Future<List<MVideo>> getVideoList(MSource source, String url) async {
    // TODO: implement
  }

  // For manga pages
  @override
  Future<List<String>> getPageList(MSource source, String url) {
    // TODO: implement
  }

  @override
  List<dynamic> getFilterList(MSource source) {
    // TODO: implement
  }

  @override
  List<dynamic> getSourcePreferences(MSource source) {
    // TODO: implement
  }
}

TestSource main() {
  return TestSource();
}

''';
