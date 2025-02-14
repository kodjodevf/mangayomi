import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/languages/javascript.dart';
import 'package:re_highlight/styles/vs2015.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class CodeEditorPage extends ConsumerStatefulWidget {
  final int? sourceId;
  const CodeEditorPage({super.key, this.sourceId});

  @override
  ConsumerState<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends ConsumerState<CodeEditorPage> {
  dynamic result;
  late final source =
      widget.sourceId == null ? null : isar.sources.getSync(widget.sourceId!);
  final CodeLineEditingController _controller = CodeLineEditingController();

  List<(String, int)> _getServices(BuildContext context) => [
        ("getPopular", 0),
        ("getLatestUpdates", 1),
        ("search", 2),
        ("getDetail", 3),
        if (source?.itemType == ItemType.manga) ("getPageList", 4),
        if (source?.itemType == ItemType.anime) ("getVideoList", 5),
        if (source?.itemType == ItemType.novel) ("getHtmlContent", 6),
        if (source?.itemType == ItemType.novel) ("cleanHtmlContent", 7)
      ];

  int _serviceIndex = 0;
  int _page = 1;
  String _query = "";
  String _url = "";
  String _html = "";
  bool _isLoading = false;
  String _errorText = "";
  bool _error = false;
  final _logsNotifier =
      ValueNotifier<List<(LoggerLevel, String, DateTime)>>([]);
  late final _logStreamController = Logger.logStreamController;
  final _scrollController = ScrollController();
  @override
  void initState() {
    _controller.text = source?.sourceCode ?? "";
    useLogger = true;
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
    _logsNotifier.value.clear();
    _scrollController.dispose();
    _controller.dispose();
    useLogger = false;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filterList =
        source != null ? getFilterList(source: source!) : [];
    final appFontFamily = ref.watch(appFontFamilyProvider);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          isar.writeTxnSync(() {
            isar.sources.putSync(source!);
            ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                ActionType.updateExtension,
                source!.id,
                source!.toJson(),
                false);
          });
          Navigator.pop(context, source);
        }),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Flexible(
                    flex: 7,
                    child: CodeEditor(
                        style: CodeEditorStyle(
                          fontSize: 15,
                          fontFamily: appFontFamily,
                          codeTheme: CodeHighlightTheme(languages: {
                            'dart': CodeHighlightThemeMode(mode: langDart),
                            'javascript':
                                CodeHighlightThemeMode(mode: langJavascript),
                          }, theme: vs2015Theme),
                        ),
                        controller: _controller,
                        onChanged: (_) {
                          source?.sourceCode = _controller.text;
                          if (source != null && context.mounted) {
                            isar.writeTxnSync(() {
                              isar.sources.putSync(source!);
                              ref
                                  .read(synchingProvider(syncId: 1).notifier)
                                  .addChangedPart(ActionType.updateExtension,
                                      source!.id, source!.toJson(), false);
                            });
                          }
                        },
                        wordWrap: false,
                        indicatorBuilder: (context, editingController,
                            chunkController, notifier) {
                          return Row(
                            children: [
                              DefaultCodeLineNumber(
                                controller: editingController,
                                notifier: notifier,
                              ),
                              DefaultCodeChunkIndicator(
                                  width: 20,
                                  controller: chunkController,
                                  notifier: notifier)
                            ],
                          );
                        },
                        sperator: Container(
                          width: 1,
                          color: context.dynamicThemeColor,
                        ))),
                if (context.isTablet)
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<(String, int)>(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            value: _getServices(context).firstWhere(
                                (element) => element.$2 == _serviceIndex),
                            hint: Text(
                                _getServices(context)
                                    .firstWhere((element) =>
                                        element.$2 == _serviceIndex)
                                    .$1,
                                style: const TextStyle(fontSize: 13)),
                            items: _getServices(context)
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.$1,
                                          style: const TextStyle(fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _serviceIndex = v!.$2;
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
                            _serviceIndex == 5 ||
                            _serviceIndex == 6)
                          _textEditing("Url", context, "ex: url of the entry",
                              (v) {
                            _url = v;
                          }),
                        if (_serviceIndex == 7)
                          _textEditing("Html", context, "ex. <p>Text</p>", (v) {
                            _html = v;
                          }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    source?.sourceCode = _controller.text;
                                    if (source != null && context.mounted) {
                                      isar.writeTxnSync(() {
                                        isar.sources.putSync(source!);
                                        ref
                                            .read(synchingProvider(syncId: 1)
                                                .notifier)
                                            .addChangedPart(
                                                ActionType.updateExtension,
                                                source!.id,
                                                source!.toJson(),
                                                false);
                                      });
                                    }
                                    setState(() {
                                      result = null;
                                      _isLoading = true;
                                      _error = false;
                                      _errorText = "";
                                    });
                                    if (source != null) {
                                      final service =
                                          getExtensionService(source!);

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
                                          result = {
                                            "pages": (await service
                                                    .getPageList(_url))
                                                .map((e) => e.toJson())
                                                .toList(),
                                          };
                                        } else if (_serviceIndex == 5) {
                                          result =
                                              (await service.getVideoList(_url))
                                                  .map((e) => e.toJson())
                                                  .toList();
                                        } else if (_serviceIndex == 6) {
                                          result = (await service
                                              .getHtmlContent(_url));
                                        } else {
                                          result = (await service
                                              .cleanHtmlContent(_html));
                                        }
                                        if (context.mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
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
                                        setState(() {
                                          filterList =
                                              getFilterList(source: source!);
                                        });
                                        try {
                                          if (filters.isEmpty) {
                                            filters = filterList;
                                          }
                                          final res =
                                              await filterDialog(context);
                                          if (res == 'filter' &&
                                              context.mounted) {
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
                builder: (context, logs, child) => SuperListView.separated(
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
