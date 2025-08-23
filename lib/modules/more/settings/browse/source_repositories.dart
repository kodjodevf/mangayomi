import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceRepositories extends ConsumerStatefulWidget {
  final ItemType itemType;
  const SourceRepositories({required this.itemType, super.key});

  @override
  ConsumerState<SourceRepositories> createState() => _SourceRepositoriesState();
}

class _SourceRepositoriesState extends ConsumerState<SourceRepositories> {
  final urlRegex = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );
  List<Repo> _entries = [];
  String urlInput = "";
  bool isRefreshing = false;

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
        actions: [
          isRefreshing
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () async {
                      setState(() {
                        isRefreshing = true;
                      });
                      final result = await ref.refresh(
                        fetchItemSourcesListProvider(
                          id: null,
                          reFresh: true,
                          itemType: widget.itemType,
                        ).future,
                      );
                      setState(() {
                        isRefreshing = false;
                      });
                      return result;
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
        ],
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
              final isHidden = repo.hidden ?? false;
              final repoAvatar = urlRegex
                  .firstMatch(repo.jsonUrl ?? "")
                  ?.group(4)
                  ?.split("/")
                  .elementAtOrNull(1);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: isHidden ? 0.3 : 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (repoAvatar != null)
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: cachedNetworkImage(
                                    imageUrl:
                                        "https://github.com/$repoAvatar.png?size=64",
                                    fit: BoxFit.contain,
                                    width: 64,
                                    height: 64,
                                    errorWidget: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 15,
                                      ),
                                      child: Icon(Icons.label_outline_rounded),
                                    ),
                                    useCustomNetworkImage: false,
                                  ),
                                ),
                              if (repoAvatar == null)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 15,
                                  ),
                                  child: Icon(Icons.label_outline_rounded),
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  repo.name ??
                                      repo.jsonUrl ??
                                      "Invalid source - remove it",
                                  style: TextStyle(
                                    decoration: isHidden
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              onPressed: () => ref
                                  .read(
                                    extensionsRepoStateProvider(
                                      widget.itemType,
                                    ).notifier,
                                  )
                                  .setVisibility(repo, !isHidden),
                              icon: Stack(
                                children: [
                                  const Icon(Icons.remove_red_eye_outlined),
                                  if (!isHidden)
                                    Positioned(
                                      right: 8,
                                      child: Transform.scale(
                                        scaleX: 2.5,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '\\',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () =>
                                  _showRemoveRepoDialog(context, index),
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
        onPressed: () => _showAddRepoDialog(context),
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

  _showRemoveRepoDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = context.l10n;
            return AlertDialog(
              title: Text(l10n.remove_extensions_repo),
              content: Text(l10n.remove_extensions_repo),
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
                      onPressed: () {
                        final mangaRepos = ref
                            .read(extensionsRepoStateProvider(widget.itemType))
                            .toList();
                        mangaRepos.removeWhere((url) => url == _entries[index]);
                        ref
                            .read(
                              extensionsRepoStateProvider(
                                widget.itemType,
                              ).notifier,
                            )
                            .set(mangaRepos);
                        ref.watch(extensionsRepoStateProvider(widget.itemType));
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
  }

  _showAddRepoDialog(BuildContext context) {
    bool isLoading = false;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: StatefulBuilder(
            builder: (context, setState) {
              final l10n = context.l10n;
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
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextButton(
                            onPressed:
                                controller.text.isEmpty ||
                                    !controller.text.endsWith(".json")
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    try {
                                      final mangaRepos = ref
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
                                      if (repo == null) {
                                        botToast(l10n.unsupported_repo);
                                        return;
                                      }
                                      mangaRepos.add(repo);
                                      ref
                                          .read(
                                            extensionsRepoStateProvider(
                                              widget.itemType,
                                            ).notifier,
                                          )
                                          .set(mangaRepos);
                                    } catch (e, s) {
                                      setState(() => isLoading = false);
                                      botToast('$e\n$s');
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                            child: isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    l10n.add,
                                    style: TextStyle(
                                      color:
                                          controller.text.isEmpty ||
                                              !controller.text.endsWith(".json")
                                          ? Theme.of(context).primaryColor
                                                .withValues(alpha: 0.2)
                                          : null,
                                    ),
                                  ),
                          );
                        },
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
  }
}
