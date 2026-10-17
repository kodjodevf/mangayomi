import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/language.dart';

/// Turns a language's extensions on or off.
class ExtensionLangListTileWidget extends StatelessWidget {
  final String lang;
  final bool value;
  final Function(bool) onChanged;
  const ExtensionLangListTileWidget({
    super.key,
    required this.lang,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ShioriSwitchRow(
      title: languageName(context, lang.toLowerCase()),
      value: value,
      onChanged: onChanged,
    );
  }
}
