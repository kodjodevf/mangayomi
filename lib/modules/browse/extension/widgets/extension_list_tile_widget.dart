import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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

  bool get _updateAvailable =>
      (widget.source.isAdded ?? false) &&
      !(widget.source.isObsolete ?? false) &&
      compareVersions(
            widget.source.version ?? '',
            widget.source.versionLast ?? '',
          ) <
          0;

  bool get _sourceNotEmpty =>
      widget.source.sourceCode != null && widget.source.sourceCode!.isNotEmpty;

  Future<void> _handleSourceFetch() async {
    setState(() => _isLoading = true);

    try {
      final provider = fetchItemSourcesListProvider(
        id: widget.source.id,
        reFresh: true,
        itemType: widget.source.itemType,
      );

      ref.invalidate(provider);
      await ref.read(provider.future);
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
    if (label == context.l10n.install) return Symbols.download_rounded;
    if (label == context.l10n.update) return Symbols.system_update_alt_rounded;
    return Symbols.settings_rounded;
  }

  Future<void> _openUninstallDialog(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showShioriConfirm(
      context,
      title: widget.source.name!,
      message: l10n.uninstall_extension(widget.source.name!),
      confirmLabel: l10n.uninstall,
      destructive: true,
    );
    if (confirmed) sourceRepository.uninstall(widget.source);
  }

  Widget _icon() => SourceIcon(iconUrl: widget.source.iconUrl);

  /// Language, version and the NSFW / repo / obsolete badges.
  Widget _meta(BuildContext context) {
    final tokens = context.shiori;
    final repo = widget.source.repo?.name;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: ShioriSpace.s4,
        children: [
          Text(
            [
              languageName(context, widget.source.lang!.toLowerCase()),
              widget.source.version!,
              ?repo,
            ].join(' · '),
            style: tokens.caption,
          ),
          if (widget.source.isNsfw ?? false)
            EntryBadgeChip(label: 'NSFW', tone: tokens.color.error),
          if (widget.source.isObsolete ?? false)
            EntryBadgeChip(
              label: context.l10n.obsolete.toUpperCase(),
              tone: tokens.color.offline,
            ),
        ],
      ),
    );
  }

  Widget _buildTrailingButton(BuildContext context, String label) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(ShioriSpace.s12),
            child: ShioriLoading.inline(),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: label,
                onPressed: () => _onActionTap(context),
                icon: Icon(_actionIcon(context, label)),
              ),
              if (_sourceNotEmpty)
                IconButton(
                  tooltip: context.l10n.uninstall,
                  onPressed: () => _openUninstallDialog(context),
                  icon: const Icon(Symbols.delete_rounded),
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
              padding: const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s12,
                vertical: ShioriSpace.s8,
              ),
              child: Row(
                children: [
                  _icon(),
                  const SizedBox(width: ShioriSpace.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.source.name!,
                          style: context.shiori.text.body,
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
        const SizedBox(width: ShioriSpace.s8),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(ShioriSpace.s12),
            child: ShioriLoading.inline(),
          )
        else ...[
          TvRowButton(
            onTap: () => _onActionTap(context),
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s12),
              child: Icon(_actionIcon(context, label), size: 24),
            ),
          ),
          if (_sourceNotEmpty) ...[
            const SizedBox(width: ShioriSpace.s8),
            TvRowButton(
              onTap: () => _openUninstallDialog(context),
              child: const Padding(
                padding: EdgeInsets.all(ShioriSpace.s12),
                child: Icon(Symbols.delete_rounded, size: 24),
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
