import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'l10n_providers.g.dart';

@riverpod
class L10nLocaleState extends _$L10nLocaleState {
  @override
  Locale build() {
    return Locale(
      _getLocale()!.languageCode ?? "en",
      _getLocale()!.countryCode ?? "",
    );
  }

  L10nLocale? _getLocale() {
    return isar.settings.getSync(227)!.locale ??
        L10nLocale(languageCode: "en", countryCode: "");
  }

  void setLocale(Locale locale) async {
    final settings = isar.settings.getSync(227)!;
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..locale = L10nLocale(
            languageCode: locale.languageCode,
            countryCode: locale.countryCode,
          )
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
    state = locale;
  }
}

AppLocalizations? l10nLocalizations(BuildContext context) =>
    AppLocalizations.of(context);
Locale currentLocale(BuildContext context) {
  return Localizations.localeOf(context);
}

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
