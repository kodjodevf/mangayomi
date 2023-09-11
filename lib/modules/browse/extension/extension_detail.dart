import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/media_query.dart';

class ExtensionDetail extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  @override
  ConsumerState<ExtensionDetail> createState() => _ExtensionDetailState();
}

class _ExtensionDetailState extends ConsumerState<ExtensionDetail> {
  late Source source = widget.source;
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extension_detail),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)),
              child: widget.source.iconUrl!.isEmpty
                  ? const Icon(Icons.source_outlined, size: 140)
                  : CachedNetworkImage(
                      imageUrl: widget.source.iconUrl!,
                      fit: BoxFit.contain,
                      width: 140,
                      height: 140,
                      errorWidget: (context, url, error) {
                        return const SizedBox(
                          width: 140,
                          height: 140,
                          child: Center(
                            child: Icon(Icons.source_outlined, size: 140),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.source.name!,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: primaryColor(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.source.version!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.version,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    if (widget.source.isNsfw!)
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "NSFW (18+)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    Column(
                      children: [
                        Text(
                          completeLanguageName(widget.source.lang!),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.language,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: mediaWidth(context, 1),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      side:
                          BorderSide(color: primaryColor(context), width: 0.3),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 0,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(
                              widget.source.name!,
                            ),
                            content: Text(
                                l10n.uninstall_extension(widget.source.name!)),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text(l10n.cancel)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        isar.writeTxnSync(() =>
                                            isar.sources.putSync(widget.source
                                              ..sourceCode = ""
                                              ..isAdded = false
                                              ..isPinned = false));
                                        Navigator.pop(ctx);
                                        Navigator.pop(context);
                                      },
                                      child: Text(l10n.ok)),
                                ],
                              )
                            ],
                          );
                        });
                  },
                  child: Text(
                    l10n.uninstall,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          ref.watch(getMirrorPrefProvider(widget.source.sourceCode!)).when(
                data: (data) => data != null
                    ? ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    l10n.relative_timestamp,
                                  ),
                                  content: SizedBox(
                                      width: mediaWidth(context, 0.8),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data.entries.length,
                                        itemBuilder: (context, index) {
                                          return RadioListTile(
                                            dense: true,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            value: data.entries
                                                .toList()[index]
                                                .value,
                                            groupValue: widget.source.baseUrl!,
                                            onChanged: (value) {
                                              isar.writeTxnSync(() => isar
                                                  .sources
                                                  .putSync(widget.source
                                                    ..baseUrl = data.entries
                                                        .toList()[index]
                                                        .value));
                                              setState(() {
                                                source = isar.sources
                                                    .getSync(source.id!)!;
                                              });

                                              Navigator.pop(context);
                                            },
                                            title: Row(
                                              children: [
                                                Text(data.entries
                                                    .toList()[index]
                                                    .key)
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              l10n.cancel,
                                              style: TextStyle(
                                                  color: primaryColor(context)),
                                            )),
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                        title: Text(l10n.relative_timestamp),
                        subtitle: Text(
                          widget.source.baseUrl!,
                          style: TextStyle(
                              fontSize: 11, color: secondaryColor(context)),
                        ),
                      )
                    : Container(),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Container(),
              )
        ],
      ),
    );
  }
}
