import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(Ref ref, {required Source source}) {
  bool? supportsLatest;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    supportsLatest = DartExtensionService(source).supportsLatest;
  } else {
    supportsLatest = true;
  }
  return supportsLatest;
}
