import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/bridge/m_chapter.dart';
import 'package:mangayomi/eval/bridge/m_pages.dart';
import 'package:mangayomi/eval/bridge/m_status.dart';
import 'package:mangayomi/eval/bridge/m_provider.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';

class MEvalPlugin extends EvalPlugin {
  @override
  String get identifier => 'package:mangayomi';

  @override
  void configureForCompile(BridgeDeclarationRegistry registry) {
    registry.defineBridgeClass($MProvider.$declaration);
    registry.defineBridgeClass($MPages.$declaration);
    registry.defineBridgeClass($MSource.$declaration);
    registry.defineBridgeClass($MVideo.$declaration);
    registry.defineBridgeClass($MTrack.$declaration);
    registry.defineBridgeClass($MChapter.$declaration);
    registry.defineBridgeClass($MManga.$declaration);
    registry.defineBridgeEnum($MStatus.$declaration);
  }

  @override
  void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'MProvider.', $MProvider.$construct,
        isBridge: true);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MChapter.', $MChapter.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MManga.', $MManga.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MPages.', $MPages.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MSource.', $MSource.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MVideo.', $MVideo.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MTrack.', $MTrack.$new);
    runtime.registerBridgeEnumValues(
        'package:mangayomi/bridge_lib.dart', 'MStatus', $MStatus.$values);
  }
}
