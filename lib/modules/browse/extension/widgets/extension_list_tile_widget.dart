import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/fetch_anime_sources.dart';
import 'package:mangayomi/modules/browse/extension/providers/fetch_manga_sources.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';

class ExtensionListTileWidget extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionListTileWidget({
    super.key,
    required this.source,
  });

  @override
  ConsumerState<ExtensionListTileWidget> createState() =>
      _ExtensionListTileWidgetState();
}

class _ExtensionListTileWidgetState
    extends ConsumerState<ExtensionListTileWidget> {
  bool _isLoading = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = l10nLocalizations(context)!;
    final updateAivalable =
        compareVersions(widget.source.version!, widget.source.versionLast!) < 0;
    final sourceNotEmpty = widget.source.sourceCode != null &&
        widget.source.sourceCode!.isNotEmpty;

    return ListTile(
        onTap: () async {
          if (sourceNotEmpty) {
            context.push('/extension_detail', extra: widget.source);
          } else {
            setState(() {
              _isLoading = true;
            });
            widget.source.isManga!
                ? await ref.watch(
                    fetchMangaSourcesListProvider(id: widget.source.id).future)
                : await ref.watch(
                    fetchAnimeSourcesListProvider(id: widget.source.id).future);
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        leading: Container(
          height: 37,
          width: 37,
          decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5)),
          child: widget.source.iconUrl!.isEmpty
              ? const Icon(Icons.source_outlined)
              : CachedNetworkImage(
                  imageUrl: widget.source.iconUrl!,
                  fit: BoxFit.contain,
                  width: 37,
                  height: 37,
                  errorWidget: (context, url, error) {
                    return const SizedBox(
                      width: 37,
                      height: 37,
                      child: Center(
                        child: Icon(Icons.source_outlined),
                      ),
                    );
                  },
                ),
        ),
        title: Text(widget.source.name!),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              completeLanguageName(widget.source.lang!.toLowerCase()),
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
            if (widget.source.isNsfw!)
              Row(
                children: [
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    "18+",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Colors.redAccent.withBlue(5).withOpacity(0.8)),
                  ),
                ],
              )
          ],
        ),
        trailing: TextButton(
          onPressed: !updateAivalable && sourceNotEmpty
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  widget.source.isManga!
                      ? await ref.watch(
                          fetchMangaSourcesListProvider(id: widget.source.id)
                              .future)
                      : await ref.watch(
                          fetchAnimeSourcesListProvider(id: widget.source.id)
                              .future);
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ))
              : Text(!sourceNotEmpty
                  ? l10n.install
                  : updateAivalable
                      ? l10n.update
                      : l10n.latest),
        ));
  }
}
