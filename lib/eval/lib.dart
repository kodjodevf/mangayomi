import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/models/source.dart';

import 'dart/service.dart';
import 'javascript/service.dart';
import 'lnreader/service.dart';

ExtensionService getExtensionService(Source source) {
  return switch (source.sourceCodeLanguage) {
    SourceCodeLanguage.dart => DartExtensionService(source),
    SourceCodeLanguage.javascript => JsExtensionService(source),
    SourceCodeLanguage.lnreader => LNReaderExtensionService(source),
  };
}
