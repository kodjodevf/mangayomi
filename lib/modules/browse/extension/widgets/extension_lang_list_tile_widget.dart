import 'package:flutter/material.dart';
import 'package:mangayomi/utils/language.dart';

class ExtensionLangListTileWidget extends StatelessWidget {
  final String lang;
  final bool value;
  final Function(bool) onChanged;
  const ExtensionLangListTileWidget(
      {super.key,
      required this.lang,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onChanged(!value);
        },
        title: Text(completeLanguageName(lang.toLowerCase())),
        trailing: Switch(
            value: value,
            onChanged: (value) {
              onChanged(value);
            }));
  }
}
