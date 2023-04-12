import 'package:flutter/material.dart';

class SeachFormTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final VoidCallback onPressed;
  final VoidCallback onSuffixPressed;
  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  const SeachFormTextField(
      {super.key,
      required this.onChanged,
      required this.onPressed,
      required this.controller,
      this.onFieldSubmitted,
      required this.onSuffixPressed});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        autofocus: true,
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Search...',
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.arrow_back,
                )),
            suffixIcon: IconButton(
                onPressed: onSuffixPressed, icon: const Icon(Icons.clear)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
