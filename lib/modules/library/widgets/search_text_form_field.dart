import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class SeachFormTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final VoidCallback onPressed;
  final VoidCallback onSuffixPressed;
  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;
  const SeachFormTextField({
    super.key,
    required this.onChanged,
    required this.onPressed,
    required this.controller,
    this.onFieldSubmitted,
    required this.onSuffixPressed,
    this.autofocus = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Flexible(
      child: TextFormField(
        autofocus: autofocus,
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          isDense: true,
          hintText: l10n.search,
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: onPressed,
            icon: const Icon(Symbols.arrow_back_rounded, fill: 1),
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                  onPressed: onSuffixPressed,
                  icon: const Icon(Symbols.clear_rounded, fill: 1),
                ),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
