import 'dart:async';
import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
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
  late final source = widget.sourceId == null
      ? null
      : isar.sources.getSync(widget.sourceId!);
  final CodeLineEditingController _controller = CodeLineEditingController();

  List<(String, int)> _getServices(BuildContext context) => [
    ("getPopular", 0),
    ("getLatestUpdates", 1),
    ("search", 2),
    ("getDetail", 3),
    if (source?.itemType == ItemType.manga) ("getPageList", 4),
    if (source?.itemType == ItemType.anime) ("getVideoList", 5),
    if (source?.itemType == ItemType.novel) ("getHtmlContent", 6),
    if (source?.itemType == ItemType.novel) ("cleanHtmlContent", 7),
  ];

  IconData _getServiceIcon(int index) {
    switch (index) {
      case 0:
        return Icons.star_rounded;
      case 1:
        return Icons.update_rounded;
      case 2:
        return Icons.search_rounded;
      case 3:
        return Icons.info_outline_rounded;
      case 4:
        return Icons.image_rounded;
      case 5:
        return Icons.video_library_rounded;
      case 6:
        return Icons.article_rounded;
      case 7:
        return Icons.cleaning_services_rounded;
      default:
        return Icons.code_rounded;
    }
  }

  int _serviceIndex = 0;
  int _page = 1;
  String _query = "";
  String _url = "";
  String _html = "";
  bool _isLoading = false;
  String _errorText = "";
  bool _error = false;
  final _logsNotifier = ValueNotifier<List<(LoggerLevel, String, DateTime)>>(
    [],
  );
  late final _logStreamController = Logger.logStreamController;
  late final StreamSubscription _logSubscription;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.text = source?.sourceCode ?? "";
    useLogger = true;
    _logSubscription = _logStreamController.stream.listen((event) async {
      _addLog(event);
      try {
        await Future.delayed(const Duration(milliseconds: 5));
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (_) {}
    });
  }

  static const int _maxLogs = 200;

  void _addLog((LoggerLevel, String, DateTime) log) {
    final logs = _logsNotifier.value;
    final newLogs = List<(LoggerLevel, String, DateTime)>.from(logs);
    if (newLogs.length >= _maxLogs) {
      newLogs.removeAt(0);
    }
    newLogs.add(log);
    _logsNotifier.value = newLogs;
  }

  List<dynamic> filters = [];

  Future<String?> filterDialog(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
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
                        backgroundColor: context.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context, 'filter');
                      },
                      child: Text(
                        context.l10n.filter,
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
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
        },
      ),
    );
  }

  @override
  void dispose() {
    _logSubscription.cancel();
    _logsNotifier.value.clear();
    _scrollController.dispose();
    _controller.dispose();
    useLogger = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filterList = source != null
        ? getFilterList(source: source!)
        : [];
    final appFontFamily = ref.watch(appFontFamilyProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source?.name ?? 'Code Editor',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (source != null)
                    Text(
                      completeLanguageName(source!.lang ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            isar.writeTxnSync(() {
              isar.sources.putSync(
                source!..updatedAt = DateTime.now().millisecondsSinceEpoch,
              );
            });
            Navigator.pop(context, source);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Flexible(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: CodeEditor(
                        style: CodeEditorStyle(
                          fontSize: 15,
                          fontFamily: appFontFamily,
                          codeTheme: CodeHighlightTheme(
                            languages: {
                              'dart': CodeHighlightThemeMode(mode: langDart),
                              'javascript': CodeHighlightThemeMode(
                                mode: langJavascript,
                              ),
                            },
                            theme: vs2015Theme,
                          ),
                        ),
                        controller: _controller,
                        onChanged: (_) {
                          source?.sourceCode = _controller.text;
                          if (source != null && context.mounted) {
                            isar.writeTxnSync(() {
                              isar.sources.putSync(
                                source!
                                  ..updatedAt =
                                      DateTime.now().millisecondsSinceEpoch,
                              );
                            });
                          }
                        },
                        wordWrap: false,
                        indicatorBuilder:
                            (
                              context,
                              editingController,
                              chunkController,
                              notifier,
                            ) {
                              return Row(
                                children: [
                                  DefaultCodeLineNumber(
                                    controller: editingController,
                                    notifier: notifier,
                                  ),
                                  DefaultCodeChunkIndicator(
                                    width: 20,
                                    controller: chunkController,
                                    notifier: notifier,
                                  ),
                                ],
                              );
                            },
                        sperator: Container(
                          width: 1,
                          color: context.dynamicThemeColor.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (context.isTablet)
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.primaryColor.withValues(alpha: 0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.5,
                                ),
                                color: context.primaryColor.withValues(
                                  alpha: 0.05,
                                ),
                              ),
                              child: DropdownButton<(String, int)>(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: context.primaryColor,
                                ),
                                isExpanded: true,
                                underline: const SizedBox.shrink(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                value: _getServices(context).firstWhere(
                                  (element) => element.$2 == _serviceIndex,
                                ),
                                hint: Text(
                                  _getServices(context)
                                      .firstWhere(
                                        (element) =>
                                            element.$2 == _serviceIndex,
                                      )
                                      .$1,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                items: _getServices(context)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Icon(
                                              _getServiceIcon(e.$2),
                                              size: 18,
                                              color: context.primaryColor,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              e.$1,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _serviceIndex = v!.$2;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (_serviceIndex == 0 ||
                              _serviceIndex == 1 ||
                              _serviceIndex == 2)
                            _textEditing("Page", context, "ex: 1", (v) {
                              _page = int.tryParse(v) ?? 1;
                            }),
                          if (_serviceIndex == 2)
                            _textEditing("Query", context, "ex: one piece", (
                              v,
                            ) {
                              _query = v;
                            }),
                          if (_serviceIndex == 3 ||
                              _serviceIndex == 4 ||
                              _serviceIndex == 5 ||
                              _serviceIndex == 6)
                            _textEditing(
                              "Url",
                              context,
                              "ex: url of the entry",
                              (v) {
                                _url = v;
                              },
                            ),
                          if (_serviceIndex == 7)
                            _textEditing("Html", context, "ex. <p>Text</p>", (
                              v,
                            ) {
                              _html = v;
                            }),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: context.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    "Execute",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    source?.sourceCode = _controller.text;
                                    if (source != null && context.mounted) {
                                      isar.writeTxnSync(() {
                                        isar.sources.putSync(
                                          source!
                                            ..updatedAt = DateTime.now()
                                                .millisecondsSinceEpoch,
                                        );
                                      });
                                    }
                                    setState(() {
                                      result = null;
                                      _isLoading = true;
                                      _error = false;
                                      _errorText = "";
                                    });
                                    if (source != null) {
                                      final proxyServer = ref.read(
                                        androidProxyServerStateProvider,
                                      );
                                      try {
                                        Future<dynamic> Function(
                                          ExtensionService service,
                                        )?
                                        serviceFunc;
                                        if (_serviceIndex == 0) {
                                          final getManga =
                                              await getIsolateService
                                                  .get<MPages?>(
                                                    page: _page,
                                                    source: source,
                                                    serviceType: 'getPopular',
                                                    proxyServer: proxyServer,
                                                    useLogger: true,
                                                  );
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 1) {
                                          final getManga =
                                              await getIsolateService
                                                  .get<MPages?>(
                                                    page: _page,
                                                    source: source,
                                                    serviceType:
                                                        'getLatestUpdates',
                                                    proxyServer: proxyServer,
                                                    useLogger: true,
                                                  );
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 2) {
                                          final getManga =
                                              await getIsolateService
                                                  .get<MPages?>(
                                                    query: _query,
                                                    filterList: filterList,
                                                    source: source,
                                                    page: _page,
                                                    serviceType: 'search',
                                                    proxyServer: proxyServer,
                                                    useLogger: true,
                                                  );
                                          result = getManga!.toJson();
                                        } else if (_serviceIndex == 3) {
                                          final getManga =
                                              await getIsolateService
                                                  .get<MManga>(
                                                    url: _url,
                                                    source: source,
                                                    serviceType: 'getDetail',
                                                    proxyServer: proxyServer,
                                                    useLogger: true,
                                                  );
                                          result = getManga.toJson();
                                        } else if (_serviceIndex == 4) {
                                          serviceFunc = (service) async {
                                            return {
                                              "pages":
                                                  (await service.getPageList(
                                                        _url,
                                                      ))
                                                      .map((e) => e.toJson())
                                                      .toList(),
                                            };
                                          };
                                        } else if (_serviceIndex == 5) {
                                          serviceFunc = (service) async {
                                            return (await service.getVideoList(
                                              _url,
                                            )).map((e) => e.toJson()).toList();
                                          };
                                        } else if (_serviceIndex == 6) {
                                          serviceFunc = (service) async {
                                            return await service.getHtmlContent(
                                              "test",
                                              _url,
                                            );
                                          };
                                        } else {
                                          serviceFunc = (service) async {
                                            return await service
                                                .cleanHtmlContent(_html);
                                          };
                                        }
                                        if (serviceFunc != null) {
                                          result = await withExtensionService(
                                            source!,
                                            proxyServer,
                                            serviceFunc,
                                          );
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
                                ),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: context.primaryColor,
                                    side: BorderSide(
                                      color: context.primaryColor.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                  ),
                                  label: Text(
                                    context.l10n.reset,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      result = null;
                                      _isLoading = false;
                                      _error = false;
                                      _errorText = "";
                                      filters = [];
                                    });
                                  },
                                ),
                                if (_serviceIndex == 2 && filterList.isNotEmpty)
                                  FilledButton.tonalIcon(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: context.primaryColor
                                          .withValues(alpha: 0.15),
                                      foregroundColor: context.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.filter_alt_rounded,
                                      size: 20,
                                    ),
                                    label: Text(
                                      context.l10n.filter,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (source != null) {
                                        setState(() {
                                          filterList = getFilterList(
                                            source: source!,
                                          );
                                        });
                                        try {
                                          if (filters.isEmpty) {
                                            filters = filterList;
                                          }
                                          final res = await filterDialog(
                                            context,
                                          );
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
                                                filterList: filters,
                                              ).future,
                                            );
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
                                  ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: _error
                                ? Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.red.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: SelectableText(
                                          _errorText,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : _isLoading
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: context.primaryColor,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Executing...',
                                          style: TextStyle(
                                            color: context.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : result != null
                                ? Container(
                                    padding: const EdgeInsets.all(12),
                                    child: JsonConfig(
                                      data: JsonConfigData(
                                        gap: 100,
                                        style: const JsonStyleScheme(
                                          quotation: JsonQuotation.same('"'),
                                          openAtStart: false,
                                          arrow: Icon(
                                            Icons.arrow_forward_rounded,
                                          ),
                                          depth: 4,
                                        ),
                                        color: const JsonColorScheme(),
                                      ),
                                      child: JsonView(json: result),
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.data_object_rounded,
                                          size: 64,
                                          color: Colors.grey.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No results yet',
                                          style: TextStyle(
                                            color: Colors.grey.withValues(
                                              alpha: 0.7,
                                            ),
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Execute a service to see results',
                                          style: TextStyle(
                                            color: Colors.grey.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (context.isTablet)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                height: 200,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: context.primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.terminal_rounded,
                            size: 18,
                            color: context.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Console Logs',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.clear_all_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                            tooltip: 'Clear logs',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _logsNotifier.value.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: _logsNotifier,
                        builder: (context, logs, child) => logs.isEmpty
                            ? Center(
                                child: Text(
                                  'No logs yet',
                                  style: TextStyle(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : SuperListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                controller: _scrollController,
                                padding: const EdgeInsets.all(12),
                                itemCount: logs.length,
                                itemBuilder: (context, index) {
                                  final value = logs[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          value.$1 == LoggerLevel.info
                                              ? Icons.info_outline_rounded
                                              : Icons.bug_report_rounded,
                                          size: 14,
                                          color: value.$1 == LoggerLevel.info
                                              ? Colors.yellow
                                              : Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SelectableText(
                                            value.$2,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                              color:
                                                  value.$1 == LoggerLevel.info
                                                  ? Colors.yellow
                                                  : Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _textEditing(
  String label,
  BuildContext context,
  String hintText,
  void Function(String)? onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: TextFormField(
      keyboardType: label == "Page" ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: context.primaryColor.withValues(alpha: 0.05),
        prefixIcon: Icon(
          label == "Page"
              ? Icons.numbers_rounded
              : label == "Query"
              ? Icons.search_rounded
              : label == "Url"
              ? Icons.link_rounded
              : Icons.code_rounded,
          size: 20,
          color: context.primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.dynamicThemeColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.dynamicThemeColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 12,
          color: context.primaryColor.withValues(alpha: 0.7),
        ),
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey.withValues(alpha: 0.5),
        ),
      ),
    ),
  );
}
