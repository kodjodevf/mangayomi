import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';

class MChapterBridge {
  final mChapterBridgedClass = BridgedClass(
    nativeType: MChapter,
    name: 'MChapter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return MChapter(
          name: namedArgs.get<String?>('name'),
          url: namedArgs.get<String?>('url'),
          dateUpload: namedArgs.get<String?>('dateUpload'),
          scanlator: namedArgs.get<String?>('scanlator'),
        );
      },
    },
    getters: {
      'name': (visitor, target) => (target as MChapter).name,
      'url': (visitor, target) => (target as MChapter).url,
      'dateUpload': (visitor, target) => (target as MChapter).dateUpload,
      'scanlator': (visitor, target) => (target as MChapter).scanlator,
    },
    setters: {
      'name': (visitor, target, value) =>
          (target as MChapter).name = value as String?,
      'url': (visitor, target, value) =>
          (target as MChapter).url = value as String?,
      'dateUpload': (visitor, target, value) =>
          (target as MChapter).dateUpload = value as String?,
      'scanlator': (visitor, target, value) =>
          (target as MChapter).scanlator = value as String?,
    },
  );
  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      mChapterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
