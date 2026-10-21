import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'l10n_providers.g.dart';

@riverpod
class L10nLocaleState extends _$L10nLocaleState {
  @override
  Locale build() {
    final locale = _getLocale();
    return Locale(locale.languageCode ?? "en", locale.countryCode ?? "");
  }

  L10nLocale _getLocale() {
    return settingsRepository.current.locale ??
        L10nLocale(languageCode: "en", countryCode: "");
  }

  /// On a new install, whose language was never chosen, takes the device's
  /// language when the app speaks it. A new install otherwise opened in
  /// English whatever the device was set to.
  void adoptDeviceLocaleIfUnset() {
    if (settingsRepository.current.locale != null) return;
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    const supported = AppLocalizations.supportedLocales;
    final match =
        supported
            .where(
              (l) =>
                  l.languageCode == device.languageCode &&
                  (l.countryCode ?? '') == (device.countryCode ?? ''),
            )
            .firstOrNull ??
        supported
            .where((l) => l.languageCode == device.languageCode)
            .firstOrNull;
    if (match != null) setLocale(match);
  }

  void setLocale(Locale locale) async {
    settingsRepository.update(
      (s) => s.locale = L10nLocale(
        languageCode: locale.languageCode,
        countryCode: locale.countryCode,
      ),
    );
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
