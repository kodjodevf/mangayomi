import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:url_launcher/url_launcher.dart';

/// How many sources each repository offers, by its index URL; follows the
/// sources as a refresh adds or drops some.
final repoSourceCountsProvider =
    StreamProvider.family<Map<String?, int>, ItemType>((ref, itemType) {
      return sourceRepository.watchByItemType(itemType).map((sources) {
        final counts = <String?, int>{};
        for (final source in sources) {
          final url = source.repo?.jsonUrl;
          counts[url] = (counts[url] ?? 0) + 1;
        }
        return counts;
      });
    });

class SourceRepositories extends ConsumerStatefulWidget {
  final ItemType itemType;
  const SourceRepositories({required this.itemType, super.key});

  @override
  ConsumerState<SourceRepositories> createState() => _SourceRepositoriesState();
}

class _SourceRepositoriesState extends ConsumerState<SourceRepositories> {
  List<Repo> _entries = [];
  String urlInput = "";
  bool isRefreshing = false;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  /// The repository's name, or the last part of its URL when it has none.
  String _name(Repo repo) {
    if (repo.name != null &&
        repo.name!.isNotEmpty &&
        !repo.name!.endsWith('.json')) {
      return repo.name!;
    }
    if (repo.jsonUrl == null) return "Invalid source - remove it";
    return repo.jsonUrl!
            .replaceAll(RegExp(r'/[^/]+\.json$'), '')
            .split('/')
            .where((s) => s.isNotEmpty)
            .lastOrNull ??
        repo.jsonUrl!;
  }

  Future<void> _refresh() async {
    setState(() => isRefreshing = true);
    final sources = fetchItemSourcesListProvider(
      id: null,
      reFresh: true,
      itemType: widget.itemType,
    );
    ref.invalidate(sources);
    await ref.read(sources.future);
    if (mounted) setState(() => isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final repositories = ref.watch(
      extensionsRepoStateProvider(widget.itemType),
    );
    _entries = repositories;
    final sourceCounts =
        ref.watch(repoSourceCountsProvider(widget.itemType)).asData?.value ??
        const {};
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.itemType) {
          ItemType.manga => l10n.manage_manga_repo_urls,
          ItemType.anime => l10n.manage_anime_repo_urls,
          _ => l10n.manage_novel_repo_urls,
        }),
        actions: [
          if (isRefreshing)
            const Padding(
              padding: EdgeInsets.all(ShioriSpace.s16),
              child: ShioriLoading.inline(),
            )
          else
            IconButton(
              tooltip: l10n.refresh,
              onPressed: _refresh,
              icon: const Icon(Symbols.refresh_rounded),
            ),
        ],
      ),
      body: repositories.isEmpty
          ? ShioriEmptyState(
              icon: Symbols.source_rounded,
              title: l10n.empty_extensions_repo,
              actionLabel: l10n.add_extensions_repo,
              onAction: () => _showAddRepoDialog(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: ShioriSpace.s48 * 2),
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                final isHidden = repo.hidden ?? false;
                final count = sourceCounts[repo.jsonUrl] ?? 0;
                return ShioriListRow(
                  leading: const Icon(
                    Symbols.source_rounded,
                    key: Key('repository-icon'),
                  ),
                  title: _name(repo),
                  // What it brings, then where it is.
                  subtitle: [l10n.n_sources(count), ?repo.jsonUrl].join(' · '),
                  // A hidden repository's sources are left out of Browse.
                  dimmed: isHidden,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: isHidden
                            ? l10n.show_repository
                            : l10n.hide_repository,
                        isSelected: !isHidden,
                        onPressed: () => ref
                            .read(
                              extensionsRepoStateProvider(widget.itemType)
                                  .notifier,
                            )
                            .setVisibility(repo, !isHidden),
                        icon: Icon(
                          isHidden
                              ? Symbols.visibility_off_rounded
                              : Symbols.visibility_rounded,
                        ),
                      ),
                      ShioriMenuButton(
                        tooltip: MaterialLocalizations.of(context)
                            .moreButtonTooltip,
                        items: [
                          if (repo.website != null)
                            ShioriMenuItem(
                              label: l10n.open_in_browser,
                              icon: Symbols.open_in_new_rounded,
                              onSelected: () =>
                                  _launchInBrowser(Uri.parse(repo.website!)),
                            ),
                          if (repo.jsonUrl != null)
                            ShioriMenuItem(
                              label: MaterialLocalizations.of(context)
                                  .copyButtonLabel,
                              icon: Symbols.content_copy_rounded,
                              onSelected: () => Clipboard.setData(
                                ClipboardData(text: repo.jsonUrl!),
                              ),
                            ),
                          null,
                          ShioriMenuItem(
                            label: MaterialLocalizations.of(context)
                                .deleteButtonTooltip,
                            icon: Symbols.delete_rounded,
                            destructive: true,
                            onSelected: () => _removeRepo(repo),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRepoDialog(context),
        icon: const Icon(Symbols.add_rounded),
        label: Text(l10n.add),
      ),
    );
  }

  /// #774: when a repo is removed, drop its *not-installed* sources so they
  /// don't linger as placeholders with a dead install button. Installed
  /// sources (non-empty [Source.sourceCode]) are kept so users don't lose them.
  Future<void> _removeOrphanSources(Repo removedRepo) async {
    final repoUrl = removedRepo.jsonUrl;
    if (repoUrl == null) return;
    final orphanIds = sourceRepository
        .getByItemType(widget.itemType)
        .where(
          (s) => s.repo?.jsonUrl == repoUrl && (s.sourceCode?.isEmpty ?? true),
        )
        .map((s) => s.id!)
        .toList();
    if (orphanIds.isNotEmpty) {
      await sourceRepository.deleteAll(orphanIds);
    }
  }

  Future<void> _removeRepo(Repo removedRepo) async {
    final l10n = context.l10n;
    final confirmed = await showShioriConfirm(
      context,
      title: l10n.remove_extensions_repo,
      message: _name(removedRepo),
      confirmLabel: l10n.remove,
      destructive: true,
    );
    if (!confirmed) return;
    final repos = ref
        .read(extensionsRepoStateProvider(widget.itemType))
        .where((r) => r != removedRepo)
        .toList();
    await ref
        .read(extensionsRepoStateProvider(widget.itemType).notifier)
        .set(repos);
    await _removeOrphanSources(removedRepo);
  }

  void _showAddRepoDialog(BuildContext context) {
    bool isLoading = false;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: StatefulBuilder(
            builder: (context, setState) {
              final l10n = context.l10n;
              return ShioriDialog(
                title: l10n.add_extensions_repo,
                content: TextFormField(
                  controller: controller,
                  // On Android TV, don't autofocus: it instantly pops the
                  // full-screen leanback keyboard over the dialog before the
                  // user can even see the Cancel/Add buttons. Let them navigate
                  // to the field and open the keyboard with select instead.
                  // Phones keep autofocus for the usual ready-to-type flow.
                  autofocus: !isTv,
                  keyboardType: TextInputType.url,
                  onChanged: (value) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.url_cannot_be_empty;
                    }
                    try {
                      final uri = Uri.parse(value.trim());
                      if (!uri.isAbsolute ||
                          (uri.scheme != 'http' && uri.scheme != 'https')) {
                        return l10n.invalid_url_format;
                      }
                      final clean = value.trim().toLowerCase();
                      final alreadyExists = _entries.any((r) {
                        final rUrl = r.jsonUrl?.trim().toLowerCase();
                        if (rUrl == null) return false;
                        return rUrl == clean ||
                            rUrl == '$clean/' ||
                            '$rUrl/' == clean;
                      });
                      if (alreadyExists) {
                        return l10n.repo_already_exists;
                      }
                      return null;
                    } catch (e) {
                      return l10n.invalid_url_format;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: l10n.url,
                    hintText: l10n.url_must_end_with_dot_json_or_dot_pb,
                  ),
                ),
                actions: [
                  ShioriButton.quiet(
                    label: l10n.cancel,
                    onPressed: () => Navigator.pop(context),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      final text = controller.text.trim();
                      final clean = text.toLowerCase();
                      final alreadyExists = _entries.any((r) {
                        final rUrl = r.jsonUrl?.trim().toLowerCase();
                        if (rUrl == null) return false;
                        return rUrl == clean ||
                            rUrl == '$clean/' ||
                            '$rUrl/' == clean;
                      });
                      final isValid =
                          text.isNotEmpty &&
                          !alreadyExists &&
                          Uri.tryParse(text)?.isAbsolute == true;
                      if (isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(ShioriSpace.s8),
                          child: ShioriLoading.inline(),
                        );
                      }
                      return ShioriButton(
                        label: l10n.add,
                        onPressed: !isValid
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  final repoNotifier = ref.read(
                                    extensionsRepoStateProvider(widget.itemType)
                                        .notifier,
                                  );
                                  final currentRepos = ref.read(
                                    extensionsRepoStateProvider(
                                      widget.itemType,
                                    ),
                                  );
                                  final repo = await ref.read(
                                    getRepoInfosProvider(jsonUrl: text).future,
                                  );
                                  if (repo == null) {
                                    if (context.mounted) {
                                      setState(() => isLoading = false);
                                    }
                                    botToast(l10n.unsupported_repo);
                                    return;
                                  }
                                  final repoUrl = repo.jsonUrl
                                      ?.trim()
                                      .toLowerCase();
                                  final isDuplicate = currentRepos.any((r) {
                                    final rUrl = r.jsonUrl
                                        ?.trim()
                                        .toLowerCase();
                                    return (rUrl != null &&
                                            (rUrl == repoUrl ||
                                                rUrl == clean ||
                                                rUrl == '$clean/' ||
                                                '$rUrl/' == clean ||
                                                (repoUrl != null &&
                                                    (rUrl == '$repoUrl/' ||
                                                        '$rUrl/' ==
                                                            repoUrl)))) ||
                                        r == repo;
                                  });
                                  if (isDuplicate) {
                                    setState(() => isLoading = false);
                                    botToast(l10n.repo_already_exists);
                                    return;
                                  }
                                  await repoNotifier.set([
                                    ...currentRepos,
                                    repo,
                                  ]);
                                  botToast(l10n.repo_added);
                                } catch (e, s) {
                                  if (context.mounted) {
                                    setState(() => isLoading = false);
                                  }
                                  toastError(
                                    e,
                                    stack: s,
                                    source: 'sourceRepositories',
                                  );
                                  return;
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                      );
                    },
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
