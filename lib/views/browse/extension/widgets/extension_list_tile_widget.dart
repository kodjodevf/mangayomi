import 'package:flutter/material.dart';
import 'package:mangayomi/utils/lang.dart';

class ExtensionListTileWidget extends StatelessWidget {
  final String sourceName;
  final String lang;
  final bool value;
  final Function(bool) onChanged;
  const ExtensionListTileWidget(
      {super.key,
      required this.sourceName,
      required this.lang,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onChanged(!value);
        },
        leading: Container(
          height: 37,
          width: 37,
          decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(5)),
          child: const Icon(Icons.source_outlined),
        ),
        title: Text(sourceName),
        subtitle: Text(completeLang(lang.toLowerCase())),
        trailing: Switch(
            value: value,
            onChanged: (value) {
              onChanged(value);
            }));
    ;
  }
}
