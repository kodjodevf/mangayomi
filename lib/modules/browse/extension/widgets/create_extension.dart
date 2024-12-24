import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CreateExtension extends StatefulWidget {
  const CreateExtension({super.key});

  @override
  State<CreateExtension> createState() => _CreateExtensionState();
}

class _CreateExtensionState extends State<CreateExtension> {
  String _name = "";
  String _lang = "";
  String _baseUrl = "";
  String _apiUrl = "";
  String _iconUrl = "";
  int _sourceTypeIndex = 0;
  int _itemTypeIndex = 0;
  int _languageIndex = 0;
  final List<String> _sourceTypes = ["single", "multi", "torrent"];
  final List<String> _itemTypes = ["Manga", "Anime", "Novel"];
  final List<String> _languages = ["Dart", "JavaScript"];
  SourceCodeLanguage _sourceCodeLanguage = SourceCodeLanguage.dart;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Extension"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    children: [
                      const Text("Choose extension language"),
                      const SizedBox(width: 20),
                      Flexible(
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,
                          value: _languageIndex,
                          hint: Text(_languages[_languageIndex],
                              style: const TextStyle(fontSize: 13)),
                          items: _languages
                              .map((e) => DropdownMenuItem(
                                    value: _languages.indexOf(e),
                                    child: Text(e,
                                        style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              if (v == 0) {
                                _sourceCodeLanguage = SourceCodeLanguage.dart;
                              } else {
                                _sourceCodeLanguage =
                                    SourceCodeLanguage.javascript;
                              }
                              _languageIndex = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _textEditing("Name", context, "ex: myAnime", (v) {
                  setState(() {
                    _name = v;
                  });
                }),
                _textEditing("Lang", context, "ex: en", (v) {
                  setState(() {
                    _lang = v;
                  });
                }),
                _textEditing("BaseUrl", context, "ex: https://example.com",
                    (v) {
                  setState(() {
                    _baseUrl = v;
                  });
                }),
                _textEditing(
                    "ApiUrl (optional)", context, "ex: https://api.example.com",
                    (v) {
                  setState(() {
                    _apiUrl = v;
                  });
                }),
                _textEditing("iconUrl", context, "Source icon url", (v) {
                  setState(() {
                    _iconUrl = v;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    children: [
                      const Text("Type"),
                      const SizedBox(width: 20),
                      Flexible(
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,
                          value: _sourceTypeIndex,
                          hint: Text(_sourceTypes[_sourceTypeIndex],
                              style: const TextStyle(fontSize: 13)),
                          items: _sourceTypes
                              .map((e) => DropdownMenuItem(
                                    value: _sourceTypes.indexOf(e),
                                    child: Text(e,
                                        style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _sourceTypeIndex = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    children: [
                      const Text("Target"),
                      const SizedBox(width: 20),
                      Flexible(
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,
                          value: _itemTypeIndex,
                          hint: Text(_itemTypes[_itemTypeIndex],
                              style: const TextStyle(fontSize: 13)),
                          items: _itemTypes
                              .map((e) => DropdownMenuItem(
                                    value: _itemTypes.indexOf(e),
                                    child: Text(e,
                                        style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _itemTypeIndex = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_name.isNotEmpty &&
                            _lang.isNotEmpty &&
                            _baseUrl.isNotEmpty &&
                            _iconUrl.isNotEmpty) {
                          try {
                            final id =
                                _sourceCodeLanguage == SourceCodeLanguage.dart
                                    ? 'mangayomi-$_lang.$_name'.hashCode
                                    : 'mangayomi-js-$_lang.$_name'.hashCode;
                            final checkIfExist = isar.sources.getSync(id);
                            if (checkIfExist == null) {
                              Source source = Source(
                                  id: id,
                                  name: _name,
                                  lang: _lang,
                                  baseUrl: _baseUrl,
                                  apiUrl: _apiUrl,
                                  iconUrl: _iconUrl,
                                  typeSource: _sourceTypes[_sourceTypeIndex],
                                  itemType:
                                      ItemType.values.elementAt(_itemTypeIndex),
                                  isAdded: true,
                                  isActive: true,
                                  version: "0.0.1",
                                  isNsfw: false)
                                ..sourceCodeLanguage = _sourceCodeLanguage;
                              source = source
                                ..isLocal = true
                                ..sourceCode = _sourceCodeLanguage ==
                                        SourceCodeLanguage.dart
                                    ? _dartTemplate
                                    : _jsSample(source);
                              isar.writeTxnSync(
                                  () => isar.sources.putSync(source));
                              Navigator.pop(context);
                              botToast("Source created successfully");
                            } else {
                              botToast("Source already exists");
                            }
                          } catch (e) {
                            botToast("Error when creating source");
                          }
                        }
                      },
                      child: Text(context.l10n.save)),
                )
              ],
            ),
          ),
        ));
  }
}

Widget _textEditing(String label, BuildContext context, String hintText,
    void Function(String)? onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
    child: TextFormField(
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.secondaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.secondaryColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: context.secondaryColor))),
    ),
  );
}

const _dartTemplate = r'''
import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class TestSource extends MProvider {
  TestSource({required this.source});

  MSource source;

  final Client client = Client(source);

  @override
  bool get supportsLatest => true;

  @override
  Map<String, String> get headers => {};
  
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
  
  // For novel html content
  @override
  Future<String> getHtmlContent(String url) async {
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
}''';

String _jsSample(Source source) => '''
const mangayomiSources = [{
    "name": "${source.name}",
    "lang": "${source.lang}",
    "baseUrl": "${source.baseUrl}",
    "apiUrl": "${source.apiUrl}",
    "iconUrl": "${source.iconUrl}",
    "typeSource": "${source.typeSource}",
    "isManga": ${source.isManga},
    "version": "${source.version}",
    "dateFormat": "",
    "dateFormatLocale": "",
    "pkgPath": ""
}];

class DefaultExtension extends MProvider {
    getHeaders(url) {
        throw new Error("getHeaders not implemented");
    }
    async getPopular(page) {
        throw new Error("getPopular not implemented");
    }
    get supportsLatest() {
        throw new Error("supportsLatest not implemented");
    }
    async getLatestUpdates(page) {
        throw new Error("getLatestUpdates not implemented");
    }
    async search(query, page, filters) {
        throw new Error("search not implemented");
    }
    async getDetail(url) {
        throw new Error("getDetail not implemented");
    }
    // For novel html content
    async getHtmlContent(url) {
        throw new Error("getHtmlContent not implemented");
    }
    // For anime episode video list
    async getVideoList(url) {
        throw new Error("getVideoList not implemented");
    }
    // For manga chapter pages
    async getPageList() {
        throw new Error("getPageList not implemented");
    }
    getFilterList() {
        throw new Error("getFilterList not implemented");
    }
    getSourcePreferences() {
        throw new Error("getSourcePreferences not implemented");
    }
}
''';
