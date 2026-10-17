import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/source_code_errors.dart';

/// The source's own settings, or none when its code will not run.
List<SourcePreference> getSourcePreference({required Source source}) {
  try {
    return getCachedExtensionService(source, "").getSourcePreferences();
  } catch (e, stack) {
    SourceCodeErrors.report(source, 'Settings', e, stack);
    return [];
  }
}
