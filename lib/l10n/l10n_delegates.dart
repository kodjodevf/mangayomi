import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';

/// The app's strings, then Flutter's own from material_ui.
///
/// `AppLocalizations.localizationsDelegates` is generated with the delegates
/// of flutter_localizations, which serve the old built-in Material library:
/// the widgets now come from material_ui, and would fall back to English.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];
