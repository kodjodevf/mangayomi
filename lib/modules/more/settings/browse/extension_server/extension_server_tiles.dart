import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ExtensionServerStatusTile extends StatelessWidget {
  final String label;
  final String value;
  final bool exists;

  const ExtensionServerStatusTile({
    super.key,
    required this.label,
    required this.value,
    required this.exists,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                exists ? Icons.check_circle_outline : Icons.error_outline,
                size: 18,
                color: exists ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            value.isEmpty ? l10n.not_configured : value,
            style: TextStyle(color: context.secondaryColor),
          ),
        ],
      ),
    );
  }
}

class ExtensionServerInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ExtensionServerInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          SelectableText(
            value.isEmpty ? l10n.unknown : value,
            style: TextStyle(color: context.secondaryColor),
          ),
        ],
      ),
    );
  }
}
