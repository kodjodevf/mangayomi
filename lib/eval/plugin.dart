import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/bridge/m_chapter.dart';
import 'package:mangayomi/eval/bridge/filter.dart';
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
    //Filter
    registry.defineBridgeClass($FilterList.$declaration);
    registry.defineBridgeClass($SelectFilter.$declaration);
    registry.defineBridgeClass($SeparatorFilter.$declaration);
    registry.defineBridgeClass($HeaderFilter.$declaration);
    registry.defineBridgeClass($TextFilter.$declaration);
    registry.defineBridgeClass($SortFilter.$declaration);
    registry.defineBridgeClass($TriStateFilter.$declaration);
    registry.defineBridgeClass($GroupFilter.$declaration);
    registry.defineBridgeClass($CheckBoxFilter.$declaration);
    registry.defineBridgeClass($SortState.$declaration);
    registry.defineBridgeClass($SelectFilterOption.$declaration);
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
    //Filter
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'FilterList.', $FilterList.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'SelectFilter.', $SelectFilter.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'SeparatorFilter.', $SeparatorFilter.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'HeaderFilter.', $HeaderFilter.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'TextFilter.', $TextFilter.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'SortFilter.', $SortFilter.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'TriStateFilter.', $TriStateFilter.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'GroupFilter.', $GroupFilter.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'CheckBoxFilter.', $CheckBoxFilter.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'SortState.', $SortState.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'SelectFilterOption.', $SelectFilterOption.$new);
  }
}
