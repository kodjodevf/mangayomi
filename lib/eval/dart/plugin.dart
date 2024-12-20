import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/dart/bridge/document.dart';
import 'package:mangayomi/eval/dart/bridge/element.dart';
import 'package:mangayomi/eval/dart/bridge/http.dart';
import 'package:mangayomi/eval/dart/bridge/m_chapter.dart';
import 'package:mangayomi/eval/dart/bridge/filter.dart';
import 'package:mangayomi/eval/dart/bridge/m_pages.dart';
import 'package:mangayomi/eval/dart/bridge/m_status.dart';
import 'package:mangayomi/eval/dart/bridge/m_provider.dart';
import 'package:mangayomi/eval/dart/bridge/m_manga.dart';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/bridge/m_track.dart';
import 'package:mangayomi/eval/dart/bridge/m_video.dart';
import 'package:mangayomi/eval/dart/bridge/source_preference.dart';

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
    //SourcePreferences
    registry.defineBridgeClass($CheckBoxPreference.$declaration);
    registry.defineBridgeClass($SwitchPreferenceCompat.$declaration);
    registry.defineBridgeClass($ListPreference.$declaration);
    registry.defineBridgeClass($MultiSelectListPreference.$declaration);
    registry.defineBridgeClass($CheckBoxPreference.$declaration);
    registry.defineBridgeClass($EditTextPreference.$declaration);
    //DOM HTML
    registry.defineBridgeClass($MElement.$declaration);
    registry.defineBridgeClass($Element.$declaration);
    registry.defineBridgeClass($MDocument.$declaration);
    registry.defineBridgeClass($Document.$declaration);
    //HTTP CLIENT
    registry.defineBridgeClass($Client.$declaration);
    registry.defineBridgeClass($Response.$declaration);
    registry.defineBridgeClass($BaseRequest.$declaration);
    registry.defineBridgeClass($StreamedResponse.$declaration);
    registry.defineBridgeClass($ByteStream.$declaration);
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
    //Sources preferences
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'CheckBoxPreference.', $CheckBoxPreference.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'SwitchPreferenceCompat.', $SwitchPreferenceCompat.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'ListPreference.', $ListPreference.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'MultiSelectListPreference.', $MultiSelectListPreference.$new);
    runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
        'EditTextPreference.', $EditTextPreference.$new);
    //DOM HTML
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MElement.', $MElement.$new);
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'MDocument.', $MDocument.$new);
    //HTTP CLIENT
    runtime.registerBridgeFunc(
        'package:mangayomi/bridge_lib.dart', 'Client.', $Client.$new);
  }
}
