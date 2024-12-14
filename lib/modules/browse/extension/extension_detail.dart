import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_source_preference.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';

class ExtensionDetail extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  @override
  ConsumerState<ExtensionDetail> createState() => _ExtensionDetailState();
}

class _ExtensionDetailState extends ConsumerState<ExtensionDetail> {
  late Source source = widget.source;
  late List<SourcePreference> sourcePreference =
      getSourcePreference(source: source)
          .map((e) => getSourcePreferenceEntry(e.key!, source.id!))
          .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n.extension_detail),
          leading: BackButton(onPressed: () => Navigator.pop(context, source))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: widget.source.iconUrl!.isEmpty
                    ? const Icon(Icons.source_outlined, size: 140)
                    : cachedNetworkImage(
                        imageUrl: widget.source.iconUrl!,
                        fit: BoxFit.contain,
                        width: 140,
                        height: 140,
                        errorWidget: const SizedBox(
                          width: 140,
                          height: 140,
                          child: Center(
                            child: Icon(Icons.source_outlined, size: 140),
                          ),
                        ),
                        headers: {},
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.source.name!,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.2),
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
                width: context.width(1),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      final res =
                          await context.push('/codeEditor', extra: source.id);
                      if (res != null && mounted) {
                        setState(() {
                          source = res as Source;
                          sourcePreference = getSourcePreference(source: source)
                              .map((e) =>
                                  getSourcePreferenceEntry(e.key!, source.id!))
                              .toList();
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            l10n.edit_code,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.code)
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: context.width(1),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      MClient.deleteAllCookies(source.baseUrl ?? "");
                      botToast("Cookies deleted!");
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Delete all cookies",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: context.width(1),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side:
                            BorderSide(color: context.primaryColor, width: 0.3),
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
                              content: Text(l10n
                                  .uninstall_extension(widget.source.name!)),
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
                                          final sourcePrefsIds = isar
                                              .sourcePreferences
                                              .filter()
                                              .sourceIdEqualTo(source.id!)
                                              .findAllSync()
                                              .map((e) => e.id!)
                                              .toList();
                                          final sourcePrefsStringIds = isar
                                              .sourcePreferenceStringValues
                                              .filter()
                                              .sourceIdEqualTo(source.id!)
                                              .findAllSync()
                                              .map((e) => e.id)
                                              .toList();
                                          isar.writeTxnSync(() {
                                            if (source.isObsolete ?? false) {
                                              isar.sources.deleteSync(
                                                  widget.source.id!);
                                            } else {
                                              isar.sources.putSync(widget.source
                                                ..sourceCode = ""
                                                ..isAdded = false
                                                ..isPinned = false);
                                            }
                                            isar.sourcePreferences
                                                .deleteAllSync(sourcePrefsIds);
                                            isar.sourcePreferenceStringValues
                                                .deleteAllSync(
                                                    sourcePrefsStringIds);
                                          });

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
            SourcePreferenceWidget(
                sourcePreference: sourcePreference, source: source)
          ],
        ),
      ),
    );
  }
}
