import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_pages.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/source_provider.dart';
import 'package:mangayomi/models/video.dart';

class $MSourceProvider
    with $Bridge<MSourceProvider>
    implements MSourceProvider {
  static $MSourceProvider $construct(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $MSourceProvider();

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MSourceProvider'));

  static const $declaration = BridgeClassDef(
      BridgeClassType($type, isAbstract: true),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type)))
      },
      methods: {
        'getLatestUpdates': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MSource.$type),
                false,
              ),
              BridgeParameter(
                'page',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                false,
              ),
            ])),
        'getPopular': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MSource.$type),
                false,
              ),
              BridgeParameter(
                'page',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                false,
              ),
            ])),
        'search': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MSource.$type),
                false,
              ),
              BridgeParameter(
                'query',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                false,
              ),
              BridgeParameter(
                'page',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                false,
              ),
            ])),
        'getDetail': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MManga.$type])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MManga.$type),
                false,
              ),
              BridgeParameter(
                'url',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                false,
              ),
            ])),
        'getPageList': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
              BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])
            ])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MManga.$type),
                false,
              ),
              BridgeParameter(
                'url',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                false,
              ),
            ])),
        'getVideoList': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
              BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
            ])),
            params: [
              BridgeParameter(
                'sourceInfo',
                BridgeTypeAnnotation($MManga.$type),
                false,
              ),
              BridgeParameter(
                'url',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                false,
              ),
            ])),
      },
      bridge: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MSourceProvider();
  }

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(String identifier, $Value value) {
    throw UnimplementedError();
  }

  @override
  Future<MManga> getDetail(MSource sourceInfo, String url) async =>
      await $_invoke('getDetail', [$MSource.wrap(sourceInfo), $String(url)]);

  @override
  Future<MPages> getLatestUpdates(MSource sourceInfo, int page) async =>
      await $_invoke(
          'getLatestUpdates', [$MSource.wrap(sourceInfo), $int(page)]);

  @override
  Future<MPages> getPopular(MSource sourceInfo, int page) async =>
      await $_invoke('getPopular', [$MSource.wrap(sourceInfo), $int(page)]);

  @override
  Future<MPages> search(MSource sourceInfo, String query, int page) async =>
      await $_invoke(
          'search', [$MSource.wrap(sourceInfo), $String(query), $int(page)]);

  @override
  Future<List<String>> getPageList(MSource sourceInfo, String url) async {
    final res = await $_invoke(
        'getPageList', [$MSource.wrap(sourceInfo), $String(url)]);
    if (res is $List) {
      return res.$reified.map((e) => e as String).toList();
    }
    return res;
  }

  @override
  Future<List<Video>> getVideoList(MSource sourceInfo, String url) async {
    final res = await $_invoke(
        'getVideoList', [$MSource.wrap(sourceInfo), $String(url)]);
    if (res is $List) {
      return res.$reified.map((e) => e as Video).toList();
    }
    return res;
  }
}
