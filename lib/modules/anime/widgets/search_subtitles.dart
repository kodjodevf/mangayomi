import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:path/path.dart' as path;
import 'package:super_sliver_list/super_sliver_list.dart';

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
  late final _controller = TextEditingController(text: query);
  List<ImdbTitle> titles = [];
  List<ImdbEpisode>? episodes;
  List<ImdbSubtitle>? subtitles;
  late String query = widget.chapter.manga.value?.name?.trim() ?? "";
  bool hide = false;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  initState() {
    super.initState();
    _init();
  }

  _init() async {
    await Future.delayed(const Duration(microseconds: 100));
    try {
      titles = await fetchImdbTitles(query);
    } catch (e) {
      _errorMsg = e.toString();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: _isLoading
          ? SizedBox(
              height: context.height(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: const ProgressCenter(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: context.height(0.8),
                child: Column(
                  mainAxisAlignment: _errorMsg != null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (subtitles != null || episodes != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (subtitles != null) {
                              subtitles = null;
                            } else if (episodes != null) {
                              episodes = null;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_left),
                      ),
                    if (_errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: ErrorText(_errorMsg!),
                      ),
                    if (_errorMsg == null && !hide)
                      Flexible(child: _showImdbList(context)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        onTap: () {
                          if (Platform.isAndroid || Platform.isIOS) {
                            setState(() {
                              hide = true;
                            });
                          }
                        },
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        onChanged: (d) {
                          setState(() {
                            query = d;
                          });
                        },
                        onFieldSubmitted: (d) async {
                          setState(() {
                            _isLoading = true;
                            _errorMsg = null;
                            subtitles = null;
                            episodes = null;
                          });
                          try {
                            titles = await fetchImdbTitles(query);
                          } catch (e) {
                            _errorMsg = e.toString();
                            hide = false;
                          }

                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                              hide = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.transparent,
                          suffixIcon: query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: context.primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: context.primaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: context.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _showImdbList(BuildContext context) {
    return SuperListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: subtitles?.length ?? episodes?.length ?? titles.length,
      itemBuilder: (context, index) {
        final isSubtitles = subtitles != null;
        final isEpisodes = episodes != null;
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: InkWell(
            onTap: () async {
              if (isSubtitles) {
                Navigator.pop(context, subtitles![index]);
              } else {
                setState(() {
                  _isLoading = true;
                  _errorMsg = null;
                });
                try {
                  if (isEpisodes) {
                    subtitles = await fetchImdbSubtitles(episodes![index].id);
                  } else {
                    episodes = await fetchImdbEpisodes(titles[index].id);
                    if (episodes == null || episodes!.isEmpty) {
                      subtitles = await fetchImdbSubtitles(titles[index].id);
                    }
                  }
                } catch (e) {
                  _errorMsg = e.toString();
                }
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSubtitles && !isEpisodes)
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Ink.image(
                          height: 120,
                          width: 80,
                          fit: BoxFit.cover,
                          image: titles[index].primaryImage != null
                              ? CustomExtendedNetworkImageProvider(
                                  titles[index].primaryImage!,
                                )
                              : const AssetImage('assets/transparent.png'),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width(0.6),
                          child: Text(
                            isSubtitles
                                ? "${subtitles![index].name} (${subtitles![index].displayLang}) - ${subtitles![index].format?.toUpperCase() ?? "Unknown"} - ${subtitles![index].encoding ?? "Unknown"}"
                                : isEpisodes
                                ? "S${episodes![index].season}E${episodes![index].episode}: ${episodes![index].title}"
                                : titles[index].primaryTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (!isSubtitles && !isEpisodes)
                          Row(
                            children: [
                              const Text(
                                "Rating : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                titles[index].aggregateRating?.toStringAsFixed(
                                      2,
                                    ) ??
                                    "?",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        if (!isSubtitles && !isEpisodes)
                          Row(
                            children: [
                              const Text(
                                "Votes : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                titles[index].voteCount?.toString() ?? "?",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        if (!isSubtitles && !isEpisodes)
                          Row(
                            children: [
                              const Text(
                                "Date : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${titles[index].startYear?.toString() ?? "?"} - ${titles[index].endYear?.toString() ?? "?"}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (isSubtitles && widget.isLocal)
                      OutlinedButton.icon(
                        onPressed: () async => _downloadSubtitle(index),
                        label: Text(context.l10n.download),
                        icon: Icon(Icons.download_outlined),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Future<void> _downloadSubtitle(int index) async {
    botToast(context.l10n.started);
    try {
      final subtitle = subtitles![index];
      final storageProvider = StorageProvider();
      final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
        widget.chapter,
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
        }
      }
    }
  }
}

subtitlesSearchraggableMenu(
  BuildContext context, {
  required Chapter chapter,
  required bool isLocal,
}) async {
  var padding = MediaQuery.of(context).padding;
  return await showDialog(
    context: context,
    builder: (context) => Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height(1) - padding.top - padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SubtitlesWidgetSearch(chapter: chapter, isLocal: isLocal),
            ],
          ),
        ),
      ),
    ),
  );
}
