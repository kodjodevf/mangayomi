import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Asks for a category name that none of [existing] already has. With
/// [initial], renames: keeping the same name is allowed and changes
/// nothing. Resolves to the trimmed name, or null when cancelled.
Future<String?> promptCategoryName(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required List<Category> existing,
  String? initial,
}) async {
  final l10n = context.l10n;
  final name = await showShioriPrompt(
    context,
    title: title,
    label: l10n.name,
    confirmLabel: confirmLabel,
    initialValue: initial ?? '',
    validator: (text) {
      final t = text.trim();
      if (t == initial) return null;
      return existing.any((c) => c.name == t)
          ? l10n.add_category_error_exist
          : null;
    },
  );
  final trimmed = name?.trim();
  if (trimmed == null || trimmed.isEmpty || trimmed == initial) return null;
  return trimmed;
}
