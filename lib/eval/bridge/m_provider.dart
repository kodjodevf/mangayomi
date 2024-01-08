import 'dart:convert';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge/document.dart';
import 'package:mangayomi/eval/bridge/filter.dart';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_pages.dart';
import 'package:mangayomi/eval/bridge/m_status.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/services/boa_js.dart';

class $MProvider extends MProvider with $Bridge<MProvider> {
  static $MProvider $construct(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $MProvider();

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MProvider'));

  static const $declaration = BridgeClassDef(
      BridgeClassType($type, isAbstract: true),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type)))
      },
      getters: {
        'supportsLatest': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
        )),
      },
      methods: {
        'getLatestUpdates': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('page',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
            ])),
        'getPopular': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('page',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
            ])),
        'search': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$MPages.$type])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('query',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
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
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
            ])),
        'getPageList': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
              BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])
            ])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
            ])),
        'getVideoList': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
              BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
            ])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false),
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
            ])),
        'getFilterList': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false)
            ])),
        'getSourcePreferences': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(
                CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
            params: [
              BridgeParameter(
                  'source', BridgeTypeAnnotation($MSource.$type), false)
            ])),
        'getPreferenceValue': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
            params: [
              BridgeParameter('sourceId',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
            ])),
        'cryptoHandler': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'text',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'iv',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'secretKeyString',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter('encrypt',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)), false),
              ]),
        ),
        'encryptAESCryptoJS': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'plainText',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'passphrase',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'decryptAESCryptoJS': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'encrypted',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'passphrase',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'deobfuscateJsPassword': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'inputString',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'sibnetExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    true),
              ]),
        ),
        'myTvExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'okruExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'voeExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'quality',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    true),
              ]),
        ),
        'vidBomExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'streamlareExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'suffix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'sendVidExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'headers',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'yourUploadExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'headers',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
                BridgeParameter(
                    'name',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
              ]),
        ),
        'substringAfter': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'text',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'pattern',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'substringBefore': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'text',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'pattern',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'substringBeforeLast': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'text',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'pattern',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'substringAfterLast': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'text',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'pattern',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'toVideo': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'quality',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'originalUrl',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'headers',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    true),
                BridgeParameter(
                    'subtitles',
                    BridgeTypeAnnotation(
                        BridgeTypeRef(
                            CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)]),
                        nullable: true),
                    true),
                BridgeParameter(
                    'audios',
                    BridgeTypeAnnotation(
                        BridgeTypeRef(
                            CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)]),
                        nullable: true),
                    true),
              ]),
        ),
        'jsonPathToString': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'source',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'expression',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'join',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'getMapValue': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'source',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'attr',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ],
              namedParams: [
                BridgeParameter(
                    'encode',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool),
                        nullable: true),
                    true),
              ]),
        ),
        'jsonPathToList': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
              params: [
                BridgeParameter(
                    'source',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'expression',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter('type',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              ]),
        ),
        'parseStatus': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation($MStatus.$type),
              params: [
                BridgeParameter(
                    'status',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'statusList',
                    BridgeTypeAnnotation(BridgeTypeRef(
                        CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
                    false),
              ]),
        ),
        'parseDates': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
              params: [
                BridgeParameter(
                    'value',
                    BridgeTypeAnnotation(BridgeTypeRef(
                        CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
                    false),
                BridgeParameter(
                    'dateFormat',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'dateFormatLocale',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'xpath': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
              params: [
                BridgeParameter(
                    'html',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'xpath',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'http': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.future, [BridgeTypeRef(CoreTypes.string)])),
              params: [
                BridgeParameter(
                    'method',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'datas',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'gogoCdnExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'doodExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'quality',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    true),
              ]),
        ),
        'streamTapeExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'quality',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    true),
              ]),
        ),
        'mp4UploadExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'headers',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'suffix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'streamWishExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'filemoonExtractor': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                BridgeTypeRef(CoreTypes.list, [$MVideo.$type])
              ])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'prefix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
                BridgeParameter(
                    'suffix',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                        nullable: true),
                    false),
              ]),
        ),
        'getHtmlViaWebview': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.future, [BridgeTypeRef(CoreTypes.string)])),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'rule',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'unpackJs': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'code',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'evalJs': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.future, [BridgeTypeRef(CoreTypes.string)])),
              params: [
                BridgeParameter(
                    'code',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
              ]),
        ),
        'regExp': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'expression',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'source',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter(
                    'replace',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter('type',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
                BridgeParameter('group',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              ]),
        ),
        'sortMapList': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              params: [
                BridgeParameter(
                    'list',
                    BridgeTypeAnnotation(BridgeTypeRef(
                        CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
                    false),
                BridgeParameter(
                    'value',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false),
                BridgeParameter('type',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              ]),
        ),
        'parseHtml': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation($MDocument.$type),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getUrlWithoutDomain': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
      },
      bridge: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MProvider();
  }

  @override
  $Value? $bridgeGet(String identifier) {
    return switch (identifier) {
      'evalJs' => $Function((_, __, List<$Value?> args) {
          return $Future
              .wrap(evalJs(args[0]!.$reified).then((value) => $String(value)));
        }),
      'getUrlWithoutDomain' => $Function((_, __, List<$Value?> args) {
          final uri = Uri.parse(args[0]!.$value.replaceAll(' ', '%20'));
          String out = uri.path;
          if (uri.query.isNotEmpty) {
            out += '?${uri.query}';
          }
          if (uri.fragment.isNotEmpty) {
            out += '#${uri.fragment}';
          }
          return $String(out);
        }),
      'http' => $Function((_, __, List<$Value?> args) {
          return $Future.wrap(MBridge.http(args[0]!.$reified, args[1]!.$reified)
              .then((value) => $String(value)));
        }),
      'parseHtml' => $Function((_, __, List<$Value?> args) {
          final res = MBridge.parsHtml(args[0]!.$reified);
          return $MDocument.wrap(res);
        }),
      'getPreferenceValue' => $Function((_, __, List<$Value?> args) {
          final value =
              getPreferenceValue(args[0]!.$reified, args[1]!.$reified);
          if (value is String) {
            return $String(value);
          } else if (value is bool) {
            return $bool(value);
          }
          return $List.wrap(value.map((e) => $String(e)).toList());
        }),
      "cryptoHandler" => $Function((_, __, List<$Value?> args) {
          return $String(MBridge.cryptoHandler(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value));
        }),
      "encryptAESCryptoJS" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.encryptAESCryptoJS(args[0]!.$value, args[1]!.$value));
        }),
      "decryptAESCryptoJS" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.decryptAESCryptoJS(args[0]!.$value, args[1]!.$value));
        }),
      "deobfuscateJsPassword" => $Function((_, __, List<$Value?> args) {
          return $String(MBridge.deobfuscateJsPassword(args[0]!.$value));
        }),

      ///////////////////////////////////////////////////////////////////////

      "substringAfter" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.substringAfter(args[0]!.$value, args[1]!.$value));
        }),
      "substringBefore" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.substringBefore(args[0]!.$value, args[1]!.$value));
        }),
      "substringBeforeLast" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.substringBeforeLast(args[0]!.$value, args[1]!.$value));
        }),
      "substringAfterLast" => $Function((_, __, List<$Value?> args) {
          return $String(
              MBridge.substringAfterLast(args[0]!.$value, args[1]!.$value));
        }),

      ///////////////////////////////////////////////////////////////////////

      "sibnetExtractor" => $Function((_, __, List<$Value?> args) => $Future
          .wrap(MBridge.sibnetExtractor(args[0]!.$value, args[1]?.$value ?? "")
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "myTvExtractor" => $Function((_, __, List<$Value?> args) => $Future.wrap(
          MBridge.myTvExtractor(args[0]!.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "okruExtractor" => $Function((_, __, List<$Value?> args) => $Future.wrap(
          MBridge.okruExtractor(args[0]!.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "voeExtractor" => $Function((_, __, List<$Value?> args) => $Future.wrap(
          MBridge.voeExtractor(args[0]!.$value, args[1]?.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "vidBomExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.vidBomExtractor(args[0]!.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "streamlareExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.streamlareExtractor(
                  args[0]!.$value, args[1]?.$value, args[2]?.$value)
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "sendVidExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.sendVidExtractor(
                  args[0]!.$value, args[1]?.$value, args[2]?.$value)
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "yourUploadExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.yourUploadExtractor(args[0]!.$value,
                  args[1]?.$value, args[2]?.$value, args[3]?.$value ?? "")
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "gogoCdnExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.gogoCdnExtractor(args[0]!.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "doodExtractor" => $Function((_, __, List<$Value?> args) => $Future.wrap(
          MBridge.doodExtractor(args[0]!.$value, args[1]?.$value).then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "streamTapeExtractor" => $Function((_, __, List<$Value?> args) => $Future
          .wrap(MBridge.streamTapeExtractor(args[0]!.$value, args[1]!.$value)
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "mp4UploadExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.mp4UploadExtractor(args[0]!.$value,
                  args[1]!.$value, args[2]?.$value, args[3]!.$value)
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "streamWishExtractor" => $Function((_, __, List<$Value?> args) => $Future
          .wrap(MBridge.streamWishExtractor(args[0]!.$value, args[1]!.$value)
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "filemoonExtractor" => $Function((_, __, List<$Value?> args) =>
          $Future.wrap(MBridge.filemoonExtractor(
                  args[0]!.$value, args[1]?.$value ?? "", args[2]?.$value ?? "")
              .then((value) =>
                  $List.wrap(value.map((e) => _toMVideo(e)).toList())))),
      "toVideo" => $Function((_, __, List<$Value?> args) {
          final value = MBridge.toVideo(
              args[0]!.$value,
              args[1]!.$value,
              args[2]!.$value,
              args[3]?.$value,
              args[4]?.$value,
              args[5]?.$value);
          return _toMVideo(value);
        }),

      ///////////////////////////////////////////////////////////////////////

      "getHtmlViaWebview" => $Function((_, __, List<$Value?> args) {
          return $Future.wrap(
              MBridge.getHtmlViaWebview(args[0]!.$value, args[1]!.$value)
                  .then((value) => $String(value)));
        }),
      "unpackJs" => MBridge.unpackJs,
      "regExp" => $Function((_, __, List<$Value?> args) {
          return $String(MBridge.regExp(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value, args[4]!.$value));
        }),
      "jsonPathToString" => MBridge.jsonPathToString,
      "jsonPathToList" => MBridge.jsonPathToList,
      "sortMapList" => $Function((_, __, List<$Value?> args) {
          List list = args[0]!.$value;
          if (list is $List) {
            list = list.$reified;
          }
          list = list.map((e) {
            if (e is $Map<$Value?, $Value?>) {
              return e.$reified;
            }
            return e;
          }).toList();
          return $String(jsonEncode(
              MBridge.sortMapList(list, args[1]!.$value, args[2]!.$value)));
        }),
      "getMapValue" => $Function((_, __, List<$Value?> args) {
          return $String(MBridge.getMapValue(
            args[0]!.$value,
            args[1]!.$value,
            args[2]?.$value ?? false,
          ));
        }),
      "parseStatus" => $Function((_, __, List<$Value?> args) {
          List<dynamic> argss2 = [];
          if (args[1]!.$value is List<$Value>) {
            argss2 = args[1]!.$value as List<$Value>;
          } else {
            argss2 = args[1]!.$value as List<dynamic>;
          }
          return $MStatus.wrap(MBridge.parseStatus(args[0]!.$value, argss2));
        }),
      "parseDates" => $Function((_, __, List<$Value?> args) {
          return $List.wrap(MBridge.parseDates(
                  args[0]!.$value, args[1]!.$value, args[2]!.$value)
              .map((e) => $String(e))
              .toList());
        }),
      "xpath" => MBridge.xpath,
      _ => $Function((_, __, List<$Value?> args) {
          throw UnimplementedError('Unknown property $identifier');
        }),
    };
  }

  @override
  void $bridgeSet(String identifier, $Value value) {
    throw UnimplementedError();
  }

  @override
  bool get supportsLatest => $_get('supportsLatest');

  @override
  Future<MManga> getDetail(MSource source, String url) async =>
      await $_invoke('getDetail', [$MSource.wrap(source), $String(url)]);

  @override
  Future<MPages> getLatestUpdates(MSource source, int page) async =>
      await $_invoke('getLatestUpdates', [$MSource.wrap(source), $int(page)]);

  @override
  Future<MPages> getPopular(MSource source, int page) async =>
      await $_invoke('getPopular', [$MSource.wrap(source), $int(page)]);

  @override
  Future<MPages> search(MSource source, String query, int page,
          FilterList filterList) async =>
      await $_invoke('search', [
        $MSource.wrap(source),
        $String(query),
        $int(page),
        $FilterList.wrap(FilterList(_toValueList(filterList.filters)))
      ]);

  @override
  Future<List<String>> getPageList(MSource source, String url) async {
    final res =
        await $_invoke('getPageList', [$MSource.wrap(source), $String(url)]);
    if (res is $List) {
      return res.$reified.map((e) => e as String).toList();
    }
    return res;
  }

  @override
  List getFilterList(MSource source) {
    final res = $_invoke('getFilterList', [$MSource.wrap(source)]);
    if (res is $List) {
      return res.$reified;
    }
    return res;
  }

  @override
  List getSourcePreferences(MSource source) {
    final res = $_invoke('getSourcePreferences', [$MSource.wrap(source)]);
    if (res is $List) {
      return res.$reified;
    }
    return res;
  }

  @override
  Future<List<Video>> getVideoList(MSource source, String url) async {
    final res =
        await $_invoke('getVideoList', [$MSource.wrap(source), $String(url)]);
    if (res is $List) {
      return res.$reified.map((e) => e as Video).toList();
    }
    return res;
  }

  $MVideo _toMVideo(Video e) =>
      $MVideo.wrap(Video(e.url, e.quality, e.originalUrl)
        ..headers = e.headers
        ..subtitles = $List.wrap(e.subtitles == null
            ? []
            : e.subtitles!
                .map((t) => $MTrack.wrap(Track(file: t.file, label: t.label)))
                .toList())
        ..audios = $List.wrap(e.audios == null
            ? []
            : e.audios!
                .map((t) => $MTrack.wrap(Track(file: t.file, label: t.label)))
                .toList()));

  _toValueList(List filters) {
    return (filters).map((e) {
      if (e is SelectFilter) {
        return $SelectFilter.wrap(
            SelectFilter(e.type, e.name, e.state, _toValueList(e.values)));
      } else if (e is TextFilter) {
        return $TextFilter.wrap(e);
      } else if (e is HeaderFilter) {
        return $HeaderFilter.wrap(e);
      } else if (e is CheckBoxFilter) {
        return $CheckBoxFilter.wrap(e);
      } else if (e is TriStateFilter) {
        return $TriStateFilter.wrap(e);
      } else if (e is SeparatorFilter) {
        return $SeparatorFilter.wrap(e);
      } else if (e is SortFilter) {
        return $SortFilter
            .wrap(SortFilter(e.type, e.name, e.state, _toValueList(e.values)));
      } else if (e is SortState) {
        return $SortState.wrap(e);
      } else if (e is CheckBoxFilter) {
        return $CheckBoxFilter.wrap(e);
      } else if (e is SelectFilterOption) {
        return $SelectFilterOption.wrap(e);
      } else if (e is GroupFilter) {
        return $GroupFilter
            .wrap(GroupFilter(e.type, e.name, _toValueList(e.state)));
      }
      return e;
    }).toList();
  }
}
