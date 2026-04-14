import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';

String localizedMessage(String Function(AppLocalizations l10n) message) {
  final context = navigatorKey.currentContext;
  if (context == null) return message(AppLocalizationsEn());
  final l10n = l10nLocalizations(context);
  if (l10n == null) return message(AppLocalizationsEn());
  return message(l10n);
}
