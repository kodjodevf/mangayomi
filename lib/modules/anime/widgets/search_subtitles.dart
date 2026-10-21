import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:path/path.dart' as path;

class SubtitlesWidgetSearch extends ConsumerStatefulWidget {
  final Chapter chapter;
  final bool isLocal;
  const SubtitlesWidgetSearch({
    required this.chapter,
    required this.isLocal,
    super.key,
  });

  @override
  ConsumerState<SubtitlesWidgetSearch> createState() =>
      _SubtitlesWidgetSearchState();
}

class _SubtitlesWidgetSearchState extends ConsumerState<SubtitlesWidgetSearch> {
  late final _controller = TextEditingController(
    text: widget.chapter.manga.value?.name?.trim() ?? "",
  );
  List<ImdbTitle> titles = [];
  List<ImdbEpisode>? episodes;
  List<ImdbSubtitle>? subtitles;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  initState() {
    super.initState();
    // After the first frame, so the sheet is up before the network is.
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  /// Runs [load] behind the loading state, and shows its failure if any.
  Future<void> _run(Future<void> Function() load) async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      await load();
    } catch (e) {
      _errorMsg = e.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  /// Searches the titles again, from the field.
  Future<void> _search() => _run(() async {
    subtitles = null;
    episodes = null;
    titles = await fetchImdbTitles(_controller.text.trim());
  });

  /// Goes down a level: a title's episodes (or its subtitles when it has
  /// none), an episode's subtitles.
  Future<void> _open(int index) => _run(() async {
    if (episodes != null) {
      subtitles = await fetchImdbSubtitles(episodes![index].id);
    } else {
      episodes = await fetchImdbEpisodes(titles[index].id);
      if (episodes == null || episodes!.isEmpty) {
        subtitles = await fetchImdbSubtitles(titles[index].id);
      }
    }
  });

  /// Back up a level, to the episodes or the titles.
  void _back() => setState(() {
    _errorMsg = null;
    if (subtitles != null) {
      subtitles = null;
    } else {
      episodes = null;
    }
  });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final count = subtitles?.length ?? episodes?.length ?? titles.length;
    final Widget body;
    if (_isLoading) {
      body = const ShioriLoading();
    } else if (_errorMsg != null) {
      body = ErrorState(detail: _errorMsg, onRetry: _search);
    } else if (count == 0) {
      body = ShioriEmptyState(
        icon: Symbols.search_off_rounded,
        title: l10n.no_result,
        compact: true,
      );
    } else {
      body = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: ShioriSpace.s16),
        itemCount: count,
        itemBuilder: (context, index) => subtitles != null
            ? _subtitleRow(context, subtitles![index], index)
            : episodes != null
            ? _episodeRow(context, episodes![index], index)
            : _titleRow(context, titles[index], index),
      );
    }
    return Padding(
      // The keyboard covers the sheet's foot; the results stay above it.
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      // As tall as the results, up to three quarters of the screen; the
      // loading, empty and failed states keep a modest height of their own.
      child: AnimatedSize(
        duration: ShioriMotion.of(context, ShioriMotion.standard),
        curve: ShioriMotion.standardCurve,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: media.size.height * 0.75),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ShioriSpace.s8,
                  0,
                  ShioriSpace.s16,
                  ShioriSpace.s8,
                ),
                child: Row(
                  spacing: ShioriSpace.s4,
                  children: [
                    if (subtitles != null || episodes != null)
                      IconButton(
                        tooltip: l10n.back_to_results,
                        onPressed: _back,
                        icon: const Icon(Symbols.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: ShioriSpace.s8),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, _) => TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: l10n.search,
                            prefixIcon: const Icon(Symbols.search_rounded),
                            suffixIcon: _controller.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: MaterialLocalizations.of(context)
                                        .clearButtonTooltip,
                                    onPressed: _controller.clear,
                                    icon: const Icon(Symbols.close_rounded),
                                  ),
                          ),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: body is ListView
                    ? body
                    : SizedBox(height: context.shiori.scaled(240), child: body),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A title: its poster, its name, its rating and its years.
  Widget _titleRow(BuildContext context, ImdbTitle title, int index) {
    final tokens = context.shiori;
    final years = [title.startYear, title.endYear].whereType<int>().join(' – ');
    final meta = [
      if (title.aggregateRating != null)
        '★ ${title.aggregateRating!.toStringAsFixed(1)}'
            '${title.voteCount == null ? '' : ' (${title.voteCount})'}',
      if (years.isNotEmpty) years,
    ].join(' · ');
    return InkWell(
      onTap: () => _open(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s16,
          vertical: ShioriSpace.s8,
        ),
        child: Row(
          spacing: ShioriSpace.s12,
          children: [
            ShioriThumbnail(
              height: tokens.scaled(72),
              child: title.primaryImage == null
                  ? Icon(Symbols.movie_rounded, color: tokens.color.fgMuted)
                  : Image(
                      image: CustomExtendedNetworkImageProvider(
                        title.primaryImage!,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    title.primaryTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text.row.copyWith(
                      color: tokens.color.fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (meta.isNotEmpty) Text(meta, style: tokens.caption),
                ],
              ),
            ),
            Icon(Symbols.chevron_forward_rounded, color: tokens.color.fgMuted),
          ],
        ),
      ),
    );
  }

  /// An episode: "S1E2", then its title.
  Widget _episodeRow(BuildContext context, ImdbEpisode episode, int index) {
    return ShioriListRow(
      title: episode.title,
      subtitle: 'S${episode.season}E${episode.episode}',
      trailing: Icon(
        Symbols.chevron_forward_rounded,
        color: context.shiori.color.fgMuted,
      ),
      onTap: () => _open(index),
    );
  }

  /// A subtitle file: its name, its language, format and encoding, and a
  /// download for a local episode.
  Widget _subtitleRow(BuildContext context, ImdbSubtitle subtitle, int index) {
    final meta = [
      subtitle.displayLang,
      subtitle.format?.toUpperCase(),
      subtitle.encoding,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return ShioriListRow(
      title: subtitle.name ?? subtitle.displayLang ?? '',
      titleMaxLines: 2,
      subtitle: meta.isEmpty ? null : meta,
      trailing: widget.isLocal
          ? IconButton(
              tooltip: context.l10n.download,
              onPressed: () => _downloadSubtitle(index),
              icon: const Icon(Symbols.download_rounded),
            )
          : null,
      onTap: () => Navigator.pop(context, subtitle),
    );
  }

  Future<void> _downloadSubtitle(int index) async {
    botToast(context.l10n.started);
    try {
      final subtitle = subtitles![index];
      final storageProvider = StorageProvider();
      final resolvedArchivePath =
          widget.chapter.archivePath?.isNotEmpty ?? false
          ? await resolveLocalArchivePath(widget.chapter.archivePath!)
          : null;
      final animeDir =
          resolvedArchivePath != null &&
              widget.chapter.manga.value?.source == "local"
          ? Directory(path.dirname(resolvedArchivePath))
          : null;
      final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
        widget.chapter,
        mangaMainDirectory: animeDir,
      ))!;
      final subtitleFile = File(
        path.join(
          '${chapterDirectory.path}_subtitles',
          '${subtitle.language}.srt',
        ),
      );
      final client = MClient.httpClient(
        settings: const ClientSettings(
          throwOnStatusCode: false,
          tlsSettings: TlsSettings(verifyCertificates: false),
        ),
      );
      await subtitleFile.create(recursive: true);
      final response = await _withRetry(
        () => client.get(Uri.parse(subtitle.url ?? '')),
      );
      if (response.statusCode != 200) {
        AppLogger.log(
          'Warning: Failed to download subtitle file: ${subtitle.language}',
        );
        return;
      }
      AppLogger.log('Subtitle file downloaded: ${subtitle.language}');
      await subtitleFile.writeAsBytes(response.bodyBytes);
      if (mounted) {
        botToast(context.l10n.finished(""));
      }
    } catch (e) {
      AppLogger.log("Failed to download subtitle:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      if (mounted) {
        botToast(context.l10n.failed);
      }
    }
  }

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= 3) {
          AppLogger.log("Request retries failed", logLevel: LogLevel.error);
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 300 * attempts));
      }
    }
  }
}

/// Opens the subtitle search for [chapter]; resolves to the subtitle
/// picked, or null.
Future<ImdbSubtitle?> subtitlesSearchraggableMenu(
  BuildContext context, {
  required Chapter chapter,
  required bool isLocal,
}) {
  return showShioriSheet<ImdbSubtitle>(
    context,
    title: context.l10n.group_subtitles,
    builder: (_) => SubtitlesWidgetSearch(chapter: chapter, isLocal: isLocal),
  );
}
