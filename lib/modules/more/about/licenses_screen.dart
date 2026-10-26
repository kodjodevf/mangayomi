import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Every package the app ships with, and the license texts that cover it.
class _PackageLicenses {
  const _PackageLicenses(this.name, this.texts);

  final String name;
  final List<String> texts;
}

/// Reads [LicenseRegistry], where each package registers its license, and
/// groups the texts by package name.
Future<List<_PackageLicenses>> _loadPackageLicenses() async {
  final byPackage = <String, List<String>>{};
  await for (final entry in LicenseRegistry.licenses) {
    final text = entry.paragraphs
        .map((p) => '${'  ' * math.max(p.indent, 0)}${p.text}')
        .join('\n');
    for (final package in entry.packages) {
      final texts = byPackage.putIfAbsent(package, () => []);
      if (!texts.contains(text)) texts.add(text);
    }
  }
  final names = byPackage.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return [for (final name in names) _PackageLicenses(name, byPackage[name]!)];
}

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.open_source_licenses)),
      body: FutureBuilder<List<_PackageLicenses>>(
        future: _loadPackageLicenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const ShioriLoading();
          }
          final packages = snapshot.data ?? const <_PackageLicenses>[];
          if (packages.isEmpty) {
            return ShioriEmptyState(
              icon: Symbols.gavel_rounded,
              title: l10n.open_source_licenses_empty,
            );
          }
          return ListView(
            padding: tvPageInsets,
            children: [
              ShioriSettingsGroup(
                footer: l10n.open_source_licenses_subtitle,
                children: [
                  for (final package in packages)
                    ShioriSettingRow(
                      title: package.name,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _LicenseTextScreen(package: package),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LicenseTextScreen extends StatelessWidget {
  const _LicenseTextScreen({required this.package});

  final _PackageLicenses package;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(package.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: SelectableText(
          package.texts.join('\n\n${'-' * 40}\n\n'),
          style: context.shiori.text.meta.copyWith(
            color: context.shiori.color.fg,
          ),
        ),
      ),
    );
  }
}
