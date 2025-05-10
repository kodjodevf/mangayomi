import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceRepositories extends ConsumerStatefulWidget {
  final ItemType itemType;
  const SourceRepositories({required this.itemType, super.key});

  @override
  ConsumerState<SourceRepositories> createState() => _SourceRepositoriesState();
}

class _SourceRepositoriesState extends ConsumerState<SourceRepositories> {
  List<Repo> _entries = [];
  String urlInput = "";
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final repositories = ref.watch(
      extensionsRepoStateProvider(widget.itemType),
    );
    final data = AsyncValue.data(repositories);
    return Scaffold(
      appBar: AppBar(
        title: switch (widget.itemType) {
          ItemType.manga => Text(l10n.manage_manga_repo_urls),
          ItemType.anime => Text(l10n.manage_anime_repo_urls),
          _ => Text(l10n.manage_novel_repo_urls),
        },
      ),
      body: data.when(
        data: (data) {
          if (data.isEmpty) {
            _entries = [];
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.empty_extensions_repo,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          _entries = data;

          return SuperListView.builder(
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              final repo = _entries[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 15,
                              ),
                              child: const Icon(Icons.label_outline_rounded),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                repo.name ??
                                    repo.jsonUrl ??
                                    "Invalid source - remove it",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (repo.website != null)
                              IconButton(
                                onPressed: () {
                                  _launchInBrowser(Uri.parse(repo.website!));
                                },
                                icon: Icon(Icons.open_in_new_outlined),
                              ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () async {
                                if (repo.jsonUrl != null) {
                                  await Clipboard.setData(
                                    ClipboardData(text: repo.jsonUrl!),
                                  );
                                }
                              },
                              icon: const Icon(Icons.content_copy),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text(
                                            l10n.remove_extensions_repo,
                                          ),
                                          content: Text(
                                            l10n.remove_extensions_repo,
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(l10n.cancel),
                                                ),
                                                const SizedBox(width: 15),
                                                TextButton(
                                                  onPressed: () {
                                                    final mangaRepos =
                                                        ref
                                                            .read(
                                                              extensionsRepoStateProvider(
                                                                widget.itemType,
                                                              ),
                                                            )
                                                            .toList();
                                                    mangaRepos.removeWhere(
                                                      (url) =>
                                                          url ==
                                                          _entries[index],
                                                    );
                                                    ref
                                                        .read(
                                                          extensionsRepoStateProvider(
                                                            widget.itemType,
                                                          ).notifier,
                                                        )
                                                        .set(mangaRepos);
                                                    ref.watch(
                                                      extensionsRepoStateProvider(
                                                        widget.itemType,
                                                      ),
                                                    );
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(l10n.ok),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          _entries = [];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.empty_extensions_repo,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text(l10n.add_extensions_repo),
                      content: TextFormField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.url,
                        onChanged: (value) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.url_cannot_be_empty;
                          }
                          if (!value.endsWith('.json')) {
                            return l10n.url_must_end_with_dot_json;
                          }
                          try {
                            final uri = Uri.parse(value);
                            if (!uri.isAbsolute) {
                              return l10n.invalid_url_format;
                            }
                            return null;
                          } catch (e) {
                            return l10n.invalid_url_format;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: l10n.url_must_end_with_dot_json,
                          filled: false,
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 0.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(),
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(l10n.cancel),
                            ),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed:
                                  controller.text.isEmpty ||
                                          !controller.text.endsWith(".json")
                                      ? null
                                      : () async {
                                        try {
                                          final mangaRepos =
                                              ref
                                                  .read(
                                                    extensionsRepoStateProvider(
                                                      widget.itemType,
                                                    ),
                                                  )
                                                  .toList();
                                          final repo = await ref.read(
                                            getRepoInfosProvider(
                                              jsonUrl: controller.text,
                                            ).future,
                                          );
                                          mangaRepos.add(repo);
                                          ref
                                              .read(
                                                extensionsRepoStateProvider(
                                                  widget.itemType,
                                                ).notifier,
                                              )
                                              .set(mangaRepos);
                                          ref.invalidate(
                                            extensionsRepoStateProvider(
                                              widget.itemType,
                                            ),
                                          );
                                        } catch (e, s) {
                                          botToast('$e\n$s');
                                        }

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                              child: Text(
                                l10n.add,
                                style: TextStyle(
                                  color:
                                      controller.text.isEmpty ||
                                              !controller.text.endsWith(".json")
                                          ? Theme.of(
                                            context,
                                          ).primaryColor.withValues(alpha: 0.2)
                                          : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        label: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 10),
            Text(l10n.add),
          ],
        ),
      ),
    );
  }
}
