import 'package:flutter/material.dart';

/// The thin outlined text field used by the settings dialogs.
InputDecoration outlinedFieldDecoration({
  String? hintText,
  String? helperText,
  int? helperMaxLines,
  Widget? suffixIcon,
}) => InputDecoration(
  hintText: hintText,
  helperText: helperText,
  helperMaxLines: helperMaxLines,
  suffixIcon: suffixIcon,
  filled: false,
  contentPadding: const EdgeInsets.all(12),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 0.4),
    borderRadius: BorderRadius.circular(5),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(),
    borderRadius: BorderRadius.circular(5),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(),
  ),
);
