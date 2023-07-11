import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeneralScreen extends ConsumerWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final l10nLocale = ref.watch(l10nLocaleStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.general),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        l10n.app_language,
                      ),
                      content: SizedBox(
                          width: mediaWidth(context, 0.8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppLocalizations.supportedLocales.length,
                            itemBuilder: (context, index) {
                              final locale =
                                  AppLocalizations.supportedLocales[index];
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: locale,
                                groupValue: l10nLocale,
                                onChanged: (value) {
                                  ref
                                      .read(l10nLocaleStateProvider.notifier)
                                      .setLocale(locale);
                                  Navigator.pop(context);
                                },
                                title: Text(completeLanguageName(
                                    locale.toLanguageTag())),
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
                                  style:
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: Text(l10n.app_language),
            subtitle: Text(
              completeLanguageName(l10nLocale.toLanguageTag()),
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
