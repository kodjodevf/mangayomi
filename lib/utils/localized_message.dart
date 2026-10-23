import 'package:mangayomi/core/navigation/app_navigator.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// [message] in the app's language, or in English before the app has one.
T localizedMessage<T>(T Function(AppLocalizations l10n) message) {
  final context = navigatorKey.currentContext;
  if (context == null) return message(AppLocalizationsEn());
  final l10n = l10nLocalizations(context);
  if (l10n == null) return message(AppLocalizationsEn());
  return message(l10n);
}
