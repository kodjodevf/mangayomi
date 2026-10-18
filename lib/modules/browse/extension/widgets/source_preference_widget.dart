import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// An extension's own settings, as it declares them: text, a box to tick, a
/// switch, one value of a list, or several.
class SourcePreferenceWidget extends StatefulWidget {
  final List<SourcePreference> sourcePreference;
  final Source source;
  const SourcePreferenceWidget({
    super.key,
    required this.sourcePreference,
    required this.source,
  });

  @override
  State<SourcePreferenceWidget> createState() => _SourcePreferenceWidgetState();
}

class _SourcePreferenceWidgetState extends State<SourcePreferenceWidget> {
  void _save(SourcePreference preference, VoidCallback change) {
    setState(change);
    setPreferenceSetting(preference, widget.source);
  }

  Widget _row(SourcePreference preference) {
    if (preference.editTextPreference case final pref?) {
      return ShioriSettingRow(
        title: pref.title!,
        subtitle: pref.summary,
        onTap: () async {
          final message = pref.dialogMessage ?? '';
          final value = await showShioriPrompt(
            context,
            title: (pref.dialogTitle?.isNotEmpty ?? false)
                ? pref.dialogTitle!
                : pref.title!,
            message: message.isEmpty ? null : message,
            confirmLabel: context.l10n.ok,
            initialValue: pref.value ?? '',
            allowEmpty: true,
          );
          if (value != null) _save(preference, () => pref.value = value);
        },
      );
    }
    if (preference.checkBoxPreference case final pref?) {
      return ShioriSwitchRow(
        title: pref.title!,
        subtitle: pref.summary,
        value: pref.value ?? false,
        onChanged: (v) => _save(preference, () => pref.value = v),
      );
    }
    if (preference.switchPreferenceCompat case final pref?) {
      return ShioriSwitchRow(
        title: pref.title!,
        subtitle: pref.summary,
        value: pref.value!,
        onChanged: (v) => _save(preference, () => pref.value = v),
      );
    }
    if (preference.listPreference case final pref?) {
      return ShioriValueRow<int>(
        title: pref.title!,
        description: (pref.summary?.isNotEmpty ?? false) ? pref.summary : null,
        value: pref.valueIndex!,
        options: [
          for (final (i, entry) in pref.entries!.indexed)
            ShioriChoice(i, entry),
        ],
        onChanged: (i) => _save(preference, () => pref.valueIndex = i),
      );
    }
    if (preference.multiSelectListPreference case final pref?) {
      return ShioriSettingRow(
        title: pref.title!,
        subtitle: pref.summary,
        onTap: () async {
          // Saved on confirm, so dismissing the sheet changes nothing.
          final picked = await showShioriMultiChoice<String>(
            context,
            title: pref.title!,
            selected: {...?pref.values},
            options: [
              for (final (i, entry) in pref.entries!.indexed)
                ShioriChoice(pref.entryValues![i], entry),
            ],
          );
          if (picked == null) return;
          _save(preference, () => pref.values = picked.toList());
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final preference in widget.sourcePreference) _row(preference),
      ],
    );
  }
}
