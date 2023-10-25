import 'dart:convert';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge/m_http_response.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_track.dart';
import 'package:mangayomi/eval/model/m_video.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';
import 'package:mangayomi/models/video.dart';

class $MBridge extends MBridge with $Bridge {
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'MBridge'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type), params: [], namedParams: []))
      },
      methods: {
        'cryptoHandler': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'iv',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'secretKeyString',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'encrypt',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.boolType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'encryptAESCryptoJS': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'plainText',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'passphrase',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'decryptAESCryptoJS': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'encrypted',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'passphrase',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'deobfuscateJsPassword': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'inputString',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'sibnetExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'myTvExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'okruExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'voeExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'vidBomExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'streamlareExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'suffix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'rapidCloudExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'sendVidExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'yourUploadExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'name',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'substringAfter': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'pattern',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'substringBefore': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'pattern',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'substringBeforeLast': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'pattern',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'substringAfterLast': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'pattern',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listParse': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'toVideo': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.dynamicType)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'originalUrl',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'subtitles',
                      BridgeTypeAnnotation(
                          BridgeTypeRef(CoreTypes.list,
                              [BridgeTypeRef.type(RuntimeTypes.dynamicType)]),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'audios',
                      BridgeTypeAnnotation(
                          BridgeTypeRef(CoreTypes.list,
                              [BridgeTypeRef.type(RuntimeTypes.dynamicType)]),
                          nullable: true),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'jsonPathToString': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'join',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getMapValue': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'attr',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: [
                  BridgeParameter(
                      'encode',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.boolType),
                          nullable: true),
                      true),
                ]),
            isStatic: true),
        'jsonPathToList': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'jsonDecodeToList': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'jsonPathToMap': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.mapType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'parseStatus': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.intType)),
                params: [
                  BridgeParameter(
                      'status',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'statusList',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listParseDateTime': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'dateFormat',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormatLocale',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listContain': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.boolType)),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'element',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'querySelector': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'selector',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeElement',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'attributes',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'parseChapterDate': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'date',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormat',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormatLocale',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'querySelectorAll': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: [
                  BridgeParameter(
                      'selector',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeElement',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'attributes',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeRegExp',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ]),
            isStatic: true),
        'xpath': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'xpath',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'http': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.future, [$MHttpResponse.$type])),
                params: [
                  BridgeParameter(
                      'method',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'datas',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'httpMultiparFormData': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'method',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'gogoCdnExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'doodExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'streamTapeExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'mp4UploadExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'suffix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'streamWishExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'filemoonExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
                  BridgeTypeRef(CoreTypes.list,
                      [BridgeTypeRef.type(RuntimeTypes.dynamicType)])
                ])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getHtmlViaWebview': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'rule',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'evalJs': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'code',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'regExp': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'replace',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'group',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'intParse': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.intType)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'sortMapList': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'list',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
      },
      getters: {},
      setters: {},
      fields: {},
      bridge: true);

  static $MBridge $construct(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $MBridge();

  static $Value $xpath(Runtime runtime, $Value? target, List<$Value?> args) =>
      $List.wrap(MBridge.xpath(args[0]!.$value, args[1]!.$value)
          .map((e) => $String(e))
          .toList());

  static $List $listParse(Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.listParse(
      args[0]!.$value,
      args[1]!.$value,
    ).map((e) => $String(e)).toList());
  }

  static $int $parseStatus(
      Runtime runtime, $Value? target, List<$Value?> args) {
    List<dynamic> argss2 = [];

    if (args[1]!.$value is List<$Value>) {
      argss2 = args[1]!.$value as List<$Value>;
    } else {
      argss2 = args[1]!.$value as List<dynamic>;
    }

    return $int(MBridge.parseStatus(args[0]!.$value, argss2));
  }

  static $Value $sortMapList(
      Runtime runtime, $Value? target, List<$Value?> args) {
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
  }

  static $List $listParseDateTime(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.listParseDateTime(
            args[0]!.$value, args[1]!.$value, args[2]!.$value)
        .map((e) => $String(e))
        .toList());
  }

  static $MVideo $toVideo(Runtime runtime, $Value? target, List<$Value?> args) {
    final value = MBridge.toVideo(args[0]!.$value, args[1]!.$value,
        args[2]!.$value, args[3]!.$value, args[4]!.$value, args[5]!.$value);

    return _toMVideo(value);
  }

  static $String $jsonPathToString(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.jsonPathToString(
        args[0]!.$value, args[1]!.$value, args[2]!.$value));
  }

  static $String $substringAfter(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.substringAfter(args[0]!.$value, args[1]!.$value));
  }

  static $String $substringAfterLast(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(
        MBridge.substringAfterLast(args[0]!.$value, args[1]!.$value));
  }

  static $String $substringBefore(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.substringBefore(args[0]!.$value, args[1]!.$value));
  }

  static $String $substringBeforeLast(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(
        MBridge.substringBeforeLast(args[0]!.$value, args[1]!.$value));
  }

  static $String $getMapValue(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.getMapValue(
      args[0]!.$value,
      args[1]!.$value,
      args[2]?.$value ?? false,
    ));
  }

  static $List<$String> $jsonPathToList(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.jsonPathToList(
      args[0]!.$value,
      args[1]!.$value,
      args[2]!.$value,
    ).map((e) => $String(e)).toList());
  }

  static $List<$String> $jsonDecodeToList(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.jsonDecodeToList(
      args[0]!.$value,
      args[1]!.$value,
    ).map((e) => $String(e.toString())).toList());
  }

  static $Map $jsonPathToMap(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Map.wrap(MBridge.jsonPathToMap(args[0]!.$value));
  }

  static $String $cryptoHandler(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.cryptoHandler(
          args[0]!.$value, args[1]!.$value, args[2]!.$value, args[3]!.$value));

  static $String $encryptAESCryptoJS(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.encryptAESCryptoJS(args[0]!.$value, args[1]!.$value));

  static $String $decryptAESCryptoJS(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.decryptAESCryptoJS(args[0]!.$value, args[1]!.$value));

  static $String $evalJs(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.evalJs(
        args[0]!.$value,
      ));

  static $String $regExp(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.regExp(
        args[0]!.$value,
        args[1]!.$value,
        args[2]!.$value,
        args[3]!.$value,
        args[4]!.$value,
      ));

  static $int $intParse(Runtime runtime, $Value? target, List<$Value?> args) =>
      $int(MBridge.intParse(
        args[0]!.$value,
      ));

  static $bool $listContain(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $bool(MBridge.listContain(
          args[0]!.$value as List<$Value>, args[1]!.$value));

  static $String $querySelector(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.querySelector(
          args[0]!.$value, args[1]!.$value, args[2]!.$value, args[3]!.$value));

  static $String $parseChapterDate(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.parseChapterDate(
          args[0]!.$value, args[1]!.$value, args[2]!.$value));

  static $String $deobfuscateJsPassword(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.deobfuscateJsPassword(args[0]!.$value));

  static $Value $querySelectorAll(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $List.wrap(MBridge.querySelectorAll(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value, args[4]!.$value)
          .map((e) => $String(e))
          .toList());

  static $Future $http(Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.http(args[0]!.$value, args[1]!.$value)
          .then((value) => $MHttpResponse.wrap(value)));

  static $Future $httpMultiparFormData(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(
          MBridge.httpMultiparFormData(args[0]!.$value, args[1]!.$value)
              .then((value) => $String(value)));

  static $Future $getHtmlViaWebview(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.getHtmlViaWebview(args[0]!.$value, args[1]!.$value)
          .then((value) => $String(value)));

  static $Future<List<$MVideo>> $gogoCdnExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.gogoCdnExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $doodExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.doodExtractor(args[0]!.$value, args[1]?.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $streamTapeExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamTapeExtractor(args[0]!.$value, args[1]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $mp4UploadExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.mp4UploadExtractor(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $streamWishExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamWishExtractor(args[0]!.$value, args[1]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $filemoonExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.filemoonExtractor(args[0]!.$value, args[1]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $sendVidExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.sendVidExtractor(
              args[0]!.$value, args[1]!.$value, args[2]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $yourUploadExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.yourUploadExtractor(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $sibnetExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.sibnetExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $myTvExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.myTvExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $okruExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.okruExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $voeExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.voeExtractor(args[0]!.$value, args[1]?.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $vidBomExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.vidBomExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  static $Future<List<$MVideo>> $streamlareExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamlareExtractor(
              args[0]!.$value, args[1]!.$value, args[2]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));
  static $Future<List<$MVideo>> $rapidCloudExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.rapidCloudExtractor(args[0]!.$value, args[1]!.$value)
          .then(
              (value) => $List.wrap(value.map((e) => _toMVideo(e)).toList())));

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(String identifier, $Value value) {}
}

$MVideo _toMVideo(Video e) => $MVideo.wrap(MVideo()
  ..headers = e.headers
  ..originalUrl = e.originalUrl
  ..quality = e.quality
  ..url = e.url
  ..subtitles = $List.wrap(e.subtitles == null
      ? []
      : e.subtitles!
          .map((t) => $MTrack.wrap(MTrack()
            ..file = t.file
            ..label = t.label))
          .toList())
  ..audios = $List.wrap(e.audios == null
      ? []
      : e.audios!
          .map((t) => $MTrack.wrap(MTrack()
            ..file = t.file
            ..label = t.label))
          .toList()));
