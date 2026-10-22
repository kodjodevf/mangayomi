import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Every language the app speaks, each under its own name so a reader finds
/// theirs whatever the app is showing now. A tap applies it at once, so the
/// rest of the flow is already in that language.
class OnboardingLanguageList extends ConsumerWidget {
  const OnboardingLanguageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.shiori;
    final c = tokens.color;
    final current = ref.watch(l10nLocaleStateProvider);
    final locales = [...AppLocalizations.supportedLocales]
      ..sort(
        (a, b) => languageName(context, a.toLanguageTag())
            .toLowerCase()
            .compareTo(languageName(context, b.toLanguageTag()).toLowerCase()),
      );
    bool isCurrent(Locale l) =>
        l.languageCode == current.languageCode &&
        (l.countryCode ?? '') == (current.countryCode ?? '');
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: isTv ? 360 : 300),
      child: Material(
        color: c.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        clipBehavior: Clip.antiAlias,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s4),
          children: [
            for (final locale in locales)
              ListTile(
                autofocus: isTv && isCurrent(locale),
                selected: isCurrent(locale),
                title: Text(
                  languageName(context, locale.toLanguageTag()),
                  style: tokens.text.row.copyWith(
                    color: c.fg,
                    fontWeight: isCurrent(locale)
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                trailing: isCurrent(locale)
                    ? Icon(Symbols.check_rounded, color: c.accentInk)
                    : null,
                onTap: () => ref
                    .read(l10nLocaleStateProvider.notifier)
                    .setLocale(locale),
              ),
          ],
        ),
      ),
    );
  }
}
