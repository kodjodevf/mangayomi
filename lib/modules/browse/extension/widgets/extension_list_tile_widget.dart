import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';

final extensionListTileWidget = Provider.family<Widget, Source>((ref, source) {
  return ExtensionListTileWidget(source: source);
});

class ExtensionListTileWidget extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionListTileWidget({super.key, required this.source});

  @override
  ConsumerState<ExtensionListTileWidget> createState() =>
      _ExtensionListTileWidgetState();
}

class _ExtensionListTileWidgetState
    extends ConsumerState<ExtensionListTileWidget> {
  bool _isLoading = false;

  late final bool _updateAvailable;
  late final bool _sourceNotEmpty;

  @override
  void initState() {
    super.initState();
    _updateAvailable =
        compareVersions(widget.source.version!, widget.source.versionLast!) < 0;
    _sourceNotEmpty =
        widget.source.sourceCode != null &&
        widget.source.sourceCode!.isNotEmpty;
  }

  Future<void> _handleSourceFetch() async {
    setState(() => _isLoading = true);

    try {
      final provider = fetchItemSourcesListProvider(
        id: widget.source.id,
        reFresh: true,
        itemType: widget.source.itemType,
      );

      if (!widget.source.isAdded!) ref.invalidate(provider);
      await ref.watch(provider.future);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// The row's primary tap: open the extension when it is installed, otherwise
  /// install it.
  void _onMainTap(BuildContext context) {
    if (_isLoading) return;
    if (_sourceNotEmpty) {
      context.push('/extension_detail', extra: widget.source);
    } else {
      _handleSourceFetch();
    }
  }

  /// The action button: settings when installed and up to date, otherwise
  /// install or update.
  void _onActionTap(BuildContext context) {
    if (_isLoading) return;
    if (!_updateAvailable && _sourceNotEmpty) {
      context.push('/extension_detail', extra: widget.source);
    } else {
      _handleSourceFetch();
    }
  }

  IconData _actionIcon(BuildContext context, String label) {
    if (label == context.l10n.install) return Icons.download_outlined;
    if (label == context.l10n.update) return Icons.system_update_alt_outlined;
    return Icons.settings_outlined;
  }

  void _openUninstallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(widget.source.name!),
          content: Text(ctx.l10n.uninstall_extension(widget.source.name!)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(ctx.l10n.cancel),
                ),
                const SizedBox(width: 15),
                TextButton(
                  onPressed: () {
                    final sourcePrefsIds = isar.sourcePreferences
                        .filter()
                        .sourceIdEqualTo(widget.source.id!)
                        .findAllSync()
                        .map((e) => e.id!)
                        .toList();
                    final sourcePrefsStringIds = isar
                        .sourcePreferenceStringValues
                        .filter()
                        .sourceIdEqualTo(widget.source.id!)
                        .findAllSync()
                        .map((e) => e.id)
                        .toList();
                    isar.writeTxnSync(() {
                      if (widget.source.isObsolete ?? false) {
                        isar.sources.deleteSync(widget.source.id!);
                        ref
                            .read(synchingProvider(syncId: 1).notifier)
                            .addChangedPart(
                              ActionType.removeExtension,
                              widget.source.id,
                              "{}",
                              false,
                            );
                      } else {
                        isar.sources.putSync(
                          widget.source
                            ..sourceCode = ""
                            ..isAdded = false
                            ..isPinned = false
                            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
                        );
                      }
                      isar.sourcePreferences.deleteAllSync(sourcePrefsIds);
                      isar.sourcePreferenceStringValues.deleteAllSync(
                        sourcePrefsStringIds,
                      );
                    });

                    Navigator.pop(ctx);
                  },
                  child: Text(ctx.l10n.ok),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _icon() {
    return Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: widget.source.iconUrl!.isEmpty
          ? const Icon(Icons.extension_rounded)
          : cachedNetworkImage(
              imageUrl: widget.source.iconUrl!,
              fit: BoxFit.contain,
              width: 37,
              height: 37,
              errorWidget: const SizedBox(
                width: 37,
                height: 37,
                child: Center(child: Icon(Icons.extension_rounded)),
              ),
              useCustomNetworkImage: false,
            ),
    );
  }

  /// Language, version and the NSFW / repo / obsolete badges.
  Widget _meta(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          completeLanguageName(widget.source.lang!.toLowerCase()),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          widget.source.version!,
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        if (widget.source.isNsfw ?? false)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "NSFW",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (widget.source.repo?.name != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "- ${widget.source.repo!.name!}",
              style: TextStyle(fontSize: 12),
            ),
          ),
        if (widget.source.isObsolete ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "OBSOLETE",
              style: TextStyle(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrailingButton(BuildContext context, String label) {
    return _isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _isLoading ? null : () => _onActionTap(context),
                child: Icon(_actionIcon(context, label), size: 24),
              ),
              if (_sourceNotEmpty)
                TextButton(
                  onPressed: () => _openUninstallDialog(context),
                  child: Icon(Icons.delete_outline, size: 24),
                ),
            ],
          );
  }

  /// The TV row: three focusable buttons once the extension is installed
  /// (extension / settings or update / uninstall), two while it is not
  /// (extension / install), mirroring the source rows.
  Widget _buildTvRow(BuildContext context, String label) {
    return TvListRow(
      children: [
        Expanded(
          child: TvRowButton(
            onTap: () => _onMainTap(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  _icon(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.source.name!,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        _meta(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          )
        else ...[
          TvRowButton(
            onTap: () => _onActionTap(context),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(_actionIcon(context, label), size: 24),
            ),
          ),
          if (_sourceNotEmpty) ...[
            const SizedBox(width: 6),
            TvRowButton(
              onTap: () => _openUninstallDialog(context),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.delete_outline, size: 24),
              ),
            ),
          ],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final buttonLabel = !_sourceNotEmpty
        ? l10n.install
        : _updateAvailable
        ? l10n.update
        : l10n.settings;

    if (isTv) return _buildTvRow(context, buttonLabel);

    return ListTile(
      onTap: _isLoading ? null : () => _onMainTap(context),
      leading: _icon(),
      title: Text(widget.source.name!),
      subtitle: _meta(context),
      trailing: _buildTrailingButton(context, buttonLabel),
    );
  }
}
