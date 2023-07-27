import 'package:flutter/material.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<Category> entries;
  final BuildContext context;
  final Function(bool) exist;
  final bool isExist;
  final String name;
  final Function(String) val;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.entries,
    required this.context,
    required this.exist,
    required this.isExist,
    this.name = "",
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return TextFormField(
      autofocus: true,
      controller: controller,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (name != controller.text) {
          exist(entries
              .where((element) => element.name == controller.text)
              .toList()
              .isNotEmpty);
        }
        val(value);
      },
      onFieldSubmitted: (s) {},
      decoration: InputDecoration(
          helperText: isExist == true
              ? l10n!.add_category_error_exist
              : l10n!.category_name_required,
          helperStyle: TextStyle(color: isExist == true ? Colors.red : null),
          isDense: true,
          label: Text(l10n.name,
              style: TextStyle(color: isExist == true ? Colors.red : null)),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isExist == true
                      ? Colors.red
                      : Theme.of(context).primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isExist == true
                      ? Colors.red
                      : Theme.of(context).primaryColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isExist == true
                      ? Colors.red
                      : Theme.of(context).primaryColor))),
    );
  }
}
