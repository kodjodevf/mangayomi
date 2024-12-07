import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:json_view/json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/log.dart';

class CodeEditor extends ConsumerStatefulWidget {
  final int? sourceId;
  const CodeEditor({super.key, this.sourceId});

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor> {
  dynamic result;
  late final source =
      widget.sourceId == null ? null : isar.sources.getSync(widget.sourceId!);
  late final controller = CodeController(
      text: source?.sourceCode ?? "",
      language: source == null
          ? dart
          : source!.sourceCodeLanguage == SourceCodeLanguage.dart
              ? dart
              : javascript,
      namedSectionParser: const BracketsStartEndNamedSectionParser());

  List<(String, int)> _getServices(BuildContext context) => [
        ("getPopular", 0),
        ("getLatestUpdates", 1),
        ("search", 2),
        ("getDetail", 3),
        ("getPageList", 4),
        ("getVideoList", 5)
      ];

  int _serviceIndex = 0;
  int _page = 1;
  String _query = "";
  String _url = "";
  bool _isLoading = false;
  String _errorText = "";
  bool _error = false;
  final _logsNotifier =
      ValueNotifier<List<(LoggerLevel, String, DateTime)>>([]);
  late final _logStreamController = Logger.logStreamController;
  final _scrollController = ScrollController();
  @override
  void initState() {
    _logStreamController.stream.asBroadcastStream().listen((event) async {
      _logsNotifier.value.add(event);
      try {
        await Future.delayed(const Duration(milliseconds: 5));
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } catch (_) {}
    });
    super.initState();
  }

  List<dynamic> filters = [];

  Future<String?> filterDialog(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filters = getFilterList(source: source!);
                      });
                    },
                    child: Text(context.l10n.reset),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor),
                    onPressed: () {
                      Navigator.pop(context, 'filter');
                    },
                    child: Text(
                      context.l10n.filter,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: FilterWidget(
                filterList: filters,
                onChanged: (values) {
                  setState(() {
                    filters = values;
                  });
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterList = source != null ? getFilterList(source: source!) : [];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          isar.writeTxnSync(() => isar.sources.putSync(source!));
          Navigator.pop(context, source);
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                    flex: 7,
                    child: CodeTheme(
                      data: CodeThemeData(styles: atomOneDarkTheme),
                      child: SingleChildScrollView(
                        child: CodeField(
                          controller: controller,
                          gutterStyle: const GutterStyle(
                            textStyle: TextStyle(
                              color: Colors.grey,
                              height: 1.5, // Issue #307 fix, found in package: flutter-code-editor issue #270
                            ),
                            showLineNumbers:true,
                          ),
                          onChanged: (a) {
                            setState(() {
                              source?.sourceCode = a;
                            });
                            if (source != null && mounted) {
                              isar.writeTxnSync(
                                  () => isar.sources.putSync(source!));
                            }
                          },
                        ),
                      ),
                    )),
                if (context.isTablet)
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            value: _serviceIndex,
                            hint: Text(_getServices(context)[_serviceIndex].$1,
                                style: const TextStyle(fontSize: 13)),
                            items: _getServices(context)
                                .map((e) => DropdownMenuItem(
                                      value: e.$2,
                                      child: Text(e.$1,
                                          style: const TextStyle(fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _serviceIndex = v!;
                              });
                            },
                          ),
                        ),
                        if (_serviceIndex == 0 ||
                            _serviceIndex == 1 ||
                            _serviceIndex == 2)
                          _textEditing("Page", context, "ex: 1", (v) {
                            _page = int.tryParse(v) ?? 1;
                          }),
                        if (_serviceIndex == 2)
                          _textEditing("Query", context, "ex: one piece", (v) {
                            _query = v;
                          }),
                        if (_serviceIndex == 3 ||
                            _serviceIndex == 4 ||
                            _serviceIndex == 5)
                          _textEditing("Url", context, "ex: url of the entry",
                              (v) {
                            _url = v;
                          }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      source?.sourceCode = controller.text;
                                    });
                                    if (source != null && mounted) {
                                      isar.writeTxnSync(
                                          () => isar.sources.putSync(source!));
                                    }
                                    setState(() {
                                      result = null;
                                      _isLoading = true;
                                      _error = false;
                                      _errorText = "";
                                    });
                                    if (source != null) {
                                      try {
                                        if (_serviceIndex == 0) {
                                          final getManga = await ref.watch(
                                              getPopularProvider(
                                                      source: source!,
                                                      page: _page)
                                                  .future);
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 1) {
                                          final getManga = await ref.watch(
                                              getLatestUpdatesProvider(
                                                      source: source!,
                                                      page: _page)
                                                  .future);
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 2) {
                                          final getManga = await ref.watch(
                                              searchProvider(
                                                      source: source!,
                                                      query: _query,
                                                      page: _page,
                                                      filterList: filterList)
                                                  .future);
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 3) {
                                          final getManga = await ref.watch(
                                              getDetailProvider(
                                                      source: source!,
                                                      url: _url)
                                                  .future);
                                          result = getManga.toJson();
                                        } else if (_serviceIndex == 4) {
                                          if (source!.sourceCodeLanguage ==
                                              SourceCodeLanguage.dart) {
                                            result =
                                                (await DartExtensionService(
                                                            source)
                                                        .getPageList(_url))
                                                    .map((e) => e.toJson())
                                                    .toList();
                                          } else {
                                            result = (await JsExtensionService(
                                                        source)
                                                    .getPageList(_url))
                                                .map((e) => e.toJson())
                                                .toList();
                                          }
                                          result = {"pages": result};
                                        } else {
                                          if (source!.sourceCodeLanguage ==
                                              SourceCodeLanguage.dart) {
                                            result =
                                                (await DartExtensionService(
                                                            source)
                                                        .getVideoList(_url))
                                                    .map((e) => e.toJson())
                                                    .toList();
                                          } else {
                                            result = (await JsExtensionService(
                                                        source)
                                                    .getVideoList(_url))
                                                .map((e) => e.toJson())
                                                .toList();
                                          }
                                        }
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          setState(() {
                                            _error = true;
                                            _errorText = e.toString();
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: const Text("Execute")),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        result = null;
                                        _isLoading = false;
                                        _error = false;
                                        _errorText = "";
                                        filters = [];
                                      });
                                    },
                                    child: Text(context.l10n.reset)),
                              ),
                              if (_serviceIndex == 2 && filterList.isNotEmpty)
                                ElevatedButton(
                                    onPressed: () async {
                                      if (source != null) {
                                        try {
                                          if (filters.isEmpty) {
                                            filters = filterList;
                                          }
                                          final res =
                                              await filterDialog(context);
                                          if (res == 'filter' && mounted) {
                                            setState(() {
                                              result = null;
                                              _isLoading = true;
                                              _error = false;
                                              _errorText = "";
                                            });
                                            final getManga = await ref.watch(
                                                searchProvider(
                                                        source: source!,
                                                        query: _query,
                                                        page: _page,
                                                        filterList: filters)
                                                    .future);
                                            result = getManga!.toJson();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        } catch (e) {
                                          setState(() {
                                            _error = true;
                                            _errorText = e.toString();
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Text(context.l10n.filter)),
                            ],
                          ),
                        ),
                        Expanded(
                            child: _error
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(_errorText),
                                      ],
                                    ),
                                  )
                                : _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : result != null
                                        ? JsonConfig(
                                            data: JsonConfigData(
                                              gap: 100,
                                              style: const JsonStyleScheme(
                                                quotation:
                                                    JsonQuotation.same('"'),
                                                openAtStart: false,
                                                arrow:
                                                    Icon(Icons.arrow_forward),
                                                depth: 4,
                                              ),
                                              color: const JsonColorScheme(),
                                            ),
                                            child: JsonView(json: result),
                                          )
                                        : const SizedBox.shrink())
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (context.isTablet)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
              width: context.width(1),
              height: 200,
              child: ValueListenableBuilder(
                valueListenable: _logsNotifier,
                builder: (context, logs, child) => ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final value = logs[index];
                    return SelectableText(value.$2,
                        style: TextStyle(
                            color: value.$1 == LoggerLevel.info
                                ? Colors.yellow
                                : Colors.blueAccent));
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}

Widget _textEditing(String label, BuildContext context, String hintText,
    void Function(String)? onChanged) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: TextFormField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.dynamicThemeColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.dynamicThemeColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: context.dynamicThemeColor))),
    ),
  );
}
