// shiori-file: a code editor: its syntax colours and type are the editor's, not the app's
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:json_view/json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_code_selection_toolbar.dart';
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
      : sourceRepository.getById(widget.sourceId!);
  final CodeLineEditingController _controller = CodeLineEditingController();
  late final SelectionToolbarController _selectionToolbarController =
      createExtensionCodeSelectionToolbar();
  Timer? _saveDebounceTimer;

  void _persistSourceCodeNow() {
    if (source == null) return;
    sourceRepository.save(source!);
  }

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
        return Symbols.star_rounded;
      case 1:
        return Symbols.update_rounded;
      case 2:
        return Symbols.search_rounded;
      case 3:
        return Symbols.info_rounded;
      case 4:
        return Symbols.image_rounded;
      case 5:
        return Symbols.video_library_rounded;
      case 6:
        return Symbols.article_rounded;
      case 7:
        return Symbols.cleaning_services_rounded;
      default:
        return Symbols.code_rounded;
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
  // Aliases the app-wide Logger's controller - not owned by this widget, so
  // it must never be closed here (that would break logging for the rest of
  // the app once this screen closes).
  // ignore: close_sinks
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
        // Wait for the frame to complete so maxScrollExtent is updated
        await WidgetsBinding.instance.endOfFrame;
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

  /// The phone shows one of these at a time; a wide screen shows them all.
  _CodeView _view = _CodeView.code;

  Future<String?> filterDialog(BuildContext context) {
    return showShioriSheet<String>(
      context,
      title: context.l10n.filter,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => FilterSheetBody(
          filters: filters,
          onChanged: (values) => setState(() => filters = values),
          onReset: () =>
              setState(() => filters = getFilterList(source: source!)),
          onApply: () => Navigator.pop(sheetContext, 'filter'),
          resetLabel: context.l10n.reset,
          applyLabel: context.l10n.filter,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_saveDebounceTimer?.isActive ?? false) {
      _saveDebounceTimer!.cancel();
      _persistSourceCodeNow();
    }
    _logSubscription.cancel();
    _logsNotifier.value.clear();
    _scrollController.dispose();
    _controller.dispose();
    useLogger = false;
    super.dispose();
  }

  void _resetRun() {
    setState(() {
      result = null;
      _isLoading = false;
      _error = false;
      _errorText = "";
      filters = [];
    });
  }

  void _startRun() {
    setState(() {
      result = null;
      _isLoading = true;
      _error = false;
      _errorText = "";
    });
  }

  void _failRun(Object e) {
    if (!mounted) return;
    setState(() {
      _error = true;
      _errorText = e.toString();
      _isLoading = false;
    });
  }

  /// Saves the code, then runs the chosen function of the source with the
  /// inputs given, and shows what it returns.
  Future<void> _execute(List<dynamic> filterList) async {
    source?.sourceCode = _controller.text;
    if (source != null) await sourceRepository.save(source!);
    _startRun();
    if (source == null) return;
    final proxyServer = ref.read(androidProxyServerStateProvider);
    try {
      Future<dynamic> Function(ExtensionService service)? serviceFunc;
      switch (_serviceIndex) {
        case 0 || 1 || 2:
          final pages = await getIsolateService.get<MPages?>(
            page: _page,
            query: _serviceIndex == 2 ? _query : null,
            filterList: _serviceIndex == 2 ? filterList : null,
            source: source,
            serviceType: switch (_serviceIndex) {
              0 => 'getPopular',
              1 => 'getLatestUpdates',
              _ => 'search',
            },
            proxyServer: proxyServer,
            useLogger: true,
          );
          result = pages!.toJson();
        case 3:
          final manga = await getIsolateService.get<MManga>(
            url: _url,
            source: source,
            serviceType: 'getDetail',
            proxyServer: proxyServer,
            useLogger: true,
          );
          result = manga.toJson();
        case 4:
          serviceFunc = (service) async => {
            "pages": (await service.getPageList(_url))
                .map((e) => e.toJson())
                .toList(),
          };
        case 5:
          serviceFunc = (service) async =>
              (await service.getVideoList(_url))
                  .map((e) => e.toJson())
                  .toList();
        case 6:
          serviceFunc = (service) => service.getHtmlContent("test", _url);
        default:
          serviceFunc = (service) => service.cleanHtmlContent(_html);
      }
      if (serviceFunc != null) {
        result = await withExtensionService(source!, proxyServer, serviceFunc);
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      _failRun(e);
    }
  }

  /// Picks the search's filters in a sheet, then searches with them.
  Future<void> _searchWithFilters(List<dynamic> filterList) async {
    if (source == null) return;
    try {
      if (filters.isEmpty) filters = filterList;
      final res = await filterDialog(context);
      if (res != 'filter' || !mounted) return;
      _startRun();
      final pages = await ref.read(
        searchProvider(
          source: source!,
          query: _query,
          page: _page,
          filterList: filters,
        ).future,
      );
      result = pages!.toJson();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      _failRun(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterList = source != null
        ? getFilterList(source: source!)
        : <dynamic>[];
    final tokens = context.shiori;
    final editor = _editor(context);
    final runPanel = _runPanel(context, filterList);
    final console = _console(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              source?.name ?? context.l10n.code_editor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.text.row.copyWith(
                color: tokens.color.fg,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (source != null)
              Text(
                languageName(context, source!.lang ?? ''),
                style: tokens.caption,
              ),
          ],
        ),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Symbols.arrow_back_rounded, fill: 1),
          onPressed: () {
            if (source != null) sourceRepository.save(source!);
            Navigator.pop(context, source);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Wide, the code, the test and the console side by side; on a
          // phone, one at a time, so a source can be tried there too (the
          // test and the console used to exist only on a tablet).
          if (context.isTablet) {
            return Padding(
              padding: const EdgeInsets.all(ShioriSpace.s12),
              child: Column(
                spacing: ShioriSpace.s12,
                children: [
                  Expanded(
                    child: Row(
                      spacing: ShioriSpace.s12,
                      children: [
                        Expanded(flex: 7, child: _panel(context, editor)),
                        Expanded(flex: 3, child: _panel(context, runPanel)),
                      ],
                    ),
                  ),
                  SizedBox(height: 200, child: console),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ShioriSpace.s16,
                  ShioriSpace.s4,
                  ShioriSpace.s16,
                  ShioriSpace.s8,
                ),
                child: ShioriSegmentedControl<_CodeView>(
                  segments: [
                    ShioriSegment(
                      value: _CodeView.code,
                      label: context.l10n.code_view_code,
                      icon: Symbols.code_rounded,
                    ),
                    ShioriSegment(
                      value: _CodeView.test,
                      label: context.l10n.code_view_test,
                      icon: Symbols.play_arrow_rounded,
                    ),
                    ShioriSegment(
                      value: _CodeView.console,
                      label: context.l10n.code_view_console,
                      icon: Symbols.terminal_rounded,
                    ),
                  ],
                  selected: _view,
                  onSelected: (view) => setState(() => _view = view),
                ),
              ),
              Expanded(
                child: switch (_view) {
                  _CodeView.code => editor,
                  _CodeView.test => runPanel,
                  _CodeView.console => Padding(
                    padding: const EdgeInsets.fromLTRB(
                      ShioriSpace.s12,
                      0,
                      ShioriSpace.s12,
                      ShioriSpace.s12,
                    ),
                    child: console,
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// A pane of the wide layout: the app's hairline round the content.
  Widget _panel(BuildContext context, Widget child) {
    final tokens = context.shiori;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: Border.all(color: tokens.color.hairline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ShioriShape.card),
        child: child,
      ),
    );
  }

  Widget _editor(BuildContext context) {
    return CodeEditor(
      toolbarController:
          defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android
          ? _selectionToolbarController
          : null,
      style: CodeEditorStyle(
        fontSize: 15,
        codeTheme: CodeHighlightTheme(
          languages: {
            'dart': CodeHighlightThemeMode(mode: langDart),
            'javascript': CodeHighlightThemeMode(mode: langJavascript),
          },
          theme: vs2015Theme,
        ),
      ),
      controller: _controller,
      onChanged: (_) {
        source?.sourceCode = _controller.text;
        if (source != null && context.mounted) {
          _saveDebounceTimer?.cancel();
          _saveDebounceTimer = Timer(
            const Duration(milliseconds: 1500),
            _persistSourceCodeNow,
          );
        }
      },
      wordWrap: false,
      indicatorBuilder:
          (context, editingController, chunkController, notifier) {
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
      leadingDivider: Container(width: 1, color: context.shiori.color.hairline),
    );
  }

  /// What to run and with what, the buttons, then what came back.
  Widget _runPanel(BuildContext context, List<dynamic> filterList) {
    final l10n = context.l10n;
    final services = _getServices(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShioriValueRow<int>(
          title: l10n.code_function,
          icon: _getServiceIcon(_serviceIndex),
          value: _serviceIndex,
          options: [
            for (final (name, index) in services)
              ShioriChoice(index, name, icon: _getServiceIcon(index)),
          ],
          onChanged: (v) => setState(() => _serviceIndex = v),
        ),
        if (_serviceIndex <= 2)
          _textEditing(
            context,
            label: l10n.code_page,
            hint: "1",
            icon: Symbols.numbers_rounded,
            initialValue: '$_page',
            number: true,
            onChanged: (v) => _page = int.tryParse(v) ?? 1,
          ),
        if (_serviceIndex == 2)
          _textEditing(
            context,
            label: l10n.code_query,
            hint: "one piece",
            icon: Symbols.search_rounded,
            initialValue: _query,
            onChanged: (v) => _query = v,
          ),
        if (_serviceIndex >= 3 && _serviceIndex <= 6)
          _textEditing(
            context,
            label: l10n.code_url,
            hint: "https://…",
            icon: Symbols.link_rounded,
            initialValue: _url,
            onChanged: (v) => _url = v,
          ),
        if (_serviceIndex == 7)
          _textEditing(
            context,
            label: l10n.code_html,
            hint: "<p>Text</p>",
            icon: Symbols.code_rounded,
            initialValue: _html,
            onChanged: (v) => _html = v,
          ),
        Padding(
          padding: const EdgeInsets.all(ShioriSpace.s12),
          child: Wrap(
            spacing: ShioriSpace.s8,
            runSpacing: ShioriSpace.s8,
            alignment: WrapAlignment.center,
            children: [
              ShioriButton(
                icon: Symbols.play_arrow_rounded,
                label: l10n.code_execute,
                onPressed: _isLoading ? null : () => _execute(filterList),
              ),
              if (_serviceIndex == 2 && filterList.isNotEmpty)
                ShioriButton.secondary(
                  icon: Symbols.filter_alt_rounded,
                  label: l10n.filter,
                  onPressed: _isLoading
                      ? null
                      : () => _searchWithFilters(filterList),
                ),
              ShioriButton.quiet(
                icon: Symbols.refresh_rounded,
                label: l10n.reset,
                onPressed: _resetRun,
              ),
            ],
          ),
        ),
        Divider(height: 1, color: context.shiori.color.hairline),
        Expanded(child: _result(context)),
      ],
    );
  }

  Widget _result(BuildContext context) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    if (_error) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ShioriSpace.s16),
            child: SelectableText(
              _errorText,
              style: tokens.text.meta.copyWith(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
      );
    }
    if (_isLoading) {
      return Center(child: ShioriLoading(label: l10n.code_executing));
    }
    if (result != null) {
      return Padding(
        padding: const EdgeInsets.all(ShioriSpace.s12),
        child: JsonConfig(
          data: JsonConfigData(
            gap: 100,
            style: const JsonStyleScheme(
              quotation: JsonQuotation.same('"'),
              openAtStart: false,
              arrow: Icon(Symbols.arrow_forward_rounded, fill: 1),
              depth: 4,
            ),
            color: const JsonColorScheme(),
          ),
          child: JsonView(json: result),
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: ShioriEmptyState(
          icon: Symbols.data_object_rounded,
          title: l10n.code_no_result,
          message: l10n.code_no_result_message,
          compact: true,
        ),
      ),
    );
  }

  /// The source's logs as they come, on a terminal's black.
  Widget _console(BuildContext context) {
    final tokens = context.shiori;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: Border.all(color: tokens.color.hairline),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              ShioriSpace.s12,
              ShioriSpace.s4,
              ShioriSpace.s4,
              ShioriSpace.s4,
            ),
            child: Row(
              spacing: ShioriSpace.s8,
              children: [
                const Icon(
                  Symbols.terminal_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    context.l10n.code_console,
                    style: tokens.text.meta.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Symbols.clear_all_rounded, size: 18),
                  color: Colors.white,
                  tooltip: context.l10n.clear_logs,
                  onPressed: () => setState(() => _logsNotifier.value.clear()),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.white.withValues(alpha: Alphas.hairline),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _logsNotifier,
              builder: (context, logs, child) => logs.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.code_no_logs,
                        style: tokens.text.meta.copyWith(
                          color: Colors.white.withValues(
                            alpha: Alphas.secondary,
                          ),
                        ),
                      ),
                    )
                  : SuperListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: Alphas.tint),
                      ),
                      controller: _scrollController,
                      padding: const EdgeInsets.all(ShioriSpace.s12),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final (level, message, _) = logs[index];
                        final info = level == LoggerLevel.info;
                        // A terminal's own colours, kept from before.
                        final color = info ? Colors.yellow : Colors.blueAccent;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: ShioriSpace.s4,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: ShioriSpace.s8,
                            children: [
                              Icon(
                                info
                                    ? Symbols.info_rounded
                                    : Symbols.bug_report_rounded,
                                size: 14,
                                color: color,
                              ),
                              Expanded(
                                child: SelectableText(
                                  message,
                                  style: tokens.text.badge.copyWith(
                                    fontFamily: 'monospace',
                                    color: color,
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
    );
  }
}

enum _CodeView { code, test, console }

/// An input of the test: the app's text field, with what it is for.
Widget _textEditing(
  BuildContext context, {
  required String label,
  required String hint,
  required IconData icon,
  required String initialValue,
  required ValueChanged<String> onChanged,
  bool number = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: ShioriSpace.s16,
      vertical: ShioriSpace.s4,
    ),
    child: TextFormField(
      initialValue: initialValue,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      style: context.shiori.text.row,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        prefixIcon: Icon(icon, size: 20),
      ),
    ),
  );
}
