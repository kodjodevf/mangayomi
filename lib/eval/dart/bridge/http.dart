import 'dart:convert';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/services/http/m_client.dart';

/// dart_eval wrapper for [InterceptedClient]
class $Client implements $Instance {
  $Client.wrap(this.$value);

  @override
  final InterceptedClient $value;

  late final $Instance _superclass = $Object($value);

  /// Compile-time bridged type reference for [$InterceptedClient]
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'Client'));

  /// Compile-time bridged class declaration for [$InterceptedClient]
  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('source', BridgeTypeAnnotation($MSource.$type), true),
          BridgeParameter('reqcopyWith',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
        ], namedParams: []))
      },
      methods: {
        'get': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$Response.$type])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
            ])),
        'post': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$Response.$type])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
              BridgeParameter(
                  'body',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.object),
                      nullable: true),
                  true),
              BridgeParameter(
                  'encoding',
                  BridgeTypeAnnotation(BridgeTypeRef(ConvertTypes.encoding),
                      nullable: true),
                  true),
            ])),
        'put': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$Response.$type])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
              BridgeParameter(
                  'body',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.object),
                      nullable: true),
                  true),
              BridgeParameter(
                  'encoding',
                  BridgeTypeAnnotation(BridgeTypeRef(ConvertTypes.encoding),
                      nullable: true),
                  true),
            ])),
        'delete': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$Response.$type])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
              BridgeParameter(
                  'body',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.object),
                      nullable: true),
                  true),
              BridgeParameter(
                  'encoding',
                  BridgeTypeAnnotation(BridgeTypeRef(ConvertTypes.encoding),
                      nullable: true),
                  true),
            ])),
        'patch': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.future, [$Response.$type])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
              BridgeParameter(
                  'body',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.object),
                      nullable: true),
                  true),
              BridgeParameter(
                  'encoding',
                  BridgeTypeAnnotation(BridgeTypeRef(ConvertTypes.encoding),
                      nullable: true),
                  true),
            ])),
        'read': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(
                CoreTypes.future, [BridgeTypeRef(CoreTypes.string)])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
            ])),
        'readBytes': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future, [
              BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.int)])
            ])),
            params: [
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.uri)), false),
            ],
            namedParams: [
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.map, [
                        BridgeTypeRef(CoreTypes.string),
                        BridgeTypeRef(CoreTypes.string)
                      ]),
                      nullable: true),
                  true),
            ])),
        'send': BridgeMethodDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation(BridgeTypeRef(
                CoreTypes.future, [BridgeTypeRef(CoreTypes.list)])),
            params: [
              BridgeParameter(
                  'request', BridgeTypeAnnotation($BaseRequest.$type), false),
            ])),
        'close': BridgeMethodDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
        )),
      },
      wrap: true);

  static $Client $new(Runtime runtime, $Value? target, List<$Value?> args) {
    final reqcopyWith = args[1]?.$value == null
        ? null
        : (jsonDecode(args[1]!.$value) as Map)
            .map((key, value) => MapEntry(key.toString(), value));
    return $Client.wrap(
      MClient.init(source: args[0]?.$value, reqcopyWith: reqcopyWith),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'get':
        return __get;
      case 'post':
        return __post;
      case 'put':
        return __put;
      case 'delete':
        return __delete;
      case 'patch':
        return __patch;
      case 'read':
        return __read;
      case 'readBytes':
        return __readBytes;
      case 'close':
        return __close;
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  static const $Function __get = $Function(_get);

  static $Value? _get(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);

    final request =
        (target!.$value as InterceptedClient).get(url, headers: headers);
    return $Future
        .wrap(request.then((value) => $Response.wrap(value)).onErrorMessage());
  }

  static const $Function __post = $Function(_post);

  static $Value? _post(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);
    final body = _toBodyObject(args[2]?.$value);
    final encoding = args[3]?.$value as Encoding?;

    final request = (target!.$value as InterceptedClient)
        .post(url, headers: headers, body: body, encoding: encoding);
    return $Future
        .wrap(request.then((value) => $Response.wrap(value)).onErrorMessage());
  }

  static const $Function __put = $Function(_put);

  static $Value? _put(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);
    final body = _toBodyObject(args[2]?.$value);
    final encoding = args[3]?.$value as Encoding?;

    final request = (target!.$value as InterceptedClient)
        .put(url, headers: headers, body: body, encoding: encoding);
    return $Future
        .wrap(request.then((value) => $Response.wrap(value)).onErrorMessage());
  }

  static const $Function __delete = $Function(_delete);

  static $Value? _delete(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);
    final body = _toBodyObject(args[2]?.$value);
    final encoding = args[3]?.$value as Encoding?;

    final request = (target!.$value as InterceptedClient)
        .delete(url, headers: headers, body: body, encoding: encoding);
    return $Future
        .wrap(request.then((value) => $Response.wrap(value)).onErrorMessage());
  }

  static const $Function __patch = $Function(_patch);

  static $Value? _patch(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);
    final body = _toBodyObject(args[2]?.$value);
    final encoding = args[3]?.$value as Encoding?;

    final request = (target!.$value as InterceptedClient)
        .patch(url, headers: headers, body: body, encoding: encoding);
    return $Future
        .wrap(request.then((value) => $Response.wrap(value)).onErrorMessage());
  }

  static const $Function __read = $Function(_read);

  static $Value? _read(Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = _toMapString(args[1]?.$value);

    final request =
        (target!.$value as InterceptedClient).read(url, headers: headers);
    return $Future
        .wrap(request.then((value) => $String(value)).onErrorMessage());
  }

  static const $Function __readBytes = $Function(_readBytes);

  static $Value? _readBytes(
      Runtime runtime, $Value? target, List<$Value?> args) {
    final url = args[0]!.$value as Uri;
    final headers = (args[1]?.$value as Map<$Value, $Value>?)?.map(
        (key, value) =>
            MapEntry((key.$reified).toString(), (value.$reified).toString()));

    final request =
        (target!.$value as InterceptedClient).readBytes(url, headers: headers);
    return $Future
        .wrap(request.then((value) => $List.wrap(value)).onErrorMessage());
  }

  static const $Function __close = $Function(_close);

  static $Value? _close(Runtime runtime, $Value? target, List<$Value?> args) {
    (target!.$value as InterceptedClient).close();
    return null;
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {}
}

/// dart_eval wrapper for [ClientRequest]
class $BaseRequest implements $Instance {
  $BaseRequest.wrap(this.$value) : _superclass = $Object($value);

  @override
  final BaseRequest $value;

  /// Compile-time bridged type reference for [$BaseRequest]
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'BaseRequest'));

  /// Compile-time bridged class declaration for [$BaseRequest]
  static const $declaration =
      BridgeClassDef(BridgeClassType($type, isAbstract: true),
          constructors: {},
          getters: {
            'contentLength': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                  nullable: true),
            )),
            'finalized': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
            )),
            'followRedirects': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
            )),
            'headers': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeRef(CoreTypes.string),
                  BridgeTypeRef(CoreTypes.string)
                ]),
              ),
            )),
            'maxRedirects': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
            )),
            'method': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string),
              ),
            )),
            'persistentConnection': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string),
              ),
            )),
            'url': BridgeMethodDef(BridgeFunctionDef(
              returns: BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.uri),
              ),
            )),
          },
          wrap: true);

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'contentLength':
        final res = $value.contentLength;
        return res == null ? const $null() : $int(res);
      case 'finalized':
        return $bool($value.persistentConnection);
      case 'followRedirects':
        return $bool($value.persistentConnection);
      case 'headers':
        return $Map.wrap($value.headers);
      case 'maxRedirects':
        return $int($value.maxRedirects);
      case 'method':
        return $String($value.method);
      case 'persistentConnection':
        return $bool($value.persistentConnection);
      case 'url':
        return $Uri.wrap($value.url);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper for [Response]
class $Response implements $Instance {
  $Response.wrap(this.$value) : _superclass = $Object($value);

  @override
  final Response $value;

  /// Compile-time bridged type reference for [$Response]
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'Response'));

  /// Compile-time bridged class declaration for [$Response]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
          BridgeFunctionDef(returns: BridgeTypeAnnotation($type)))
    },
    getters: {
      'body': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
      )),
      'bodyBytes': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.int)])),
      )),
      'contentLength': BridgeMethodDef(BridgeFunctionDef(
        returns:
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int), nullable: true),
      )),
      'headers': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.map, [
            BridgeTypeRef(CoreTypes.string),
            BridgeTypeRef(CoreTypes.string)
          ]),
        ),
      )),
      'isRedirect': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
      )),
      'persistentConnection': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
      )),
      'reasonPhrase': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
            nullable: true),
      )),
      'statusCode': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
      )),
      'request': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation($BaseRequest.$type, nullable: true),
      )),
    },
    wrap: true,
  );

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'body':
        return $String($value.body);
      case 'bodyBytes':
        return $List.wrap(($value.bodyBytes).map((e) => $int(e)).toList());
      case 'contentLength':
        final res = $value.contentLength;
        return res == null ? const $null() : $int(res);
      case 'headers':
        return $Map.wrap($value.headers);
      case 'isRedirect':
        return $bool($value.isRedirect);
      case 'persistentConnection':
        return $bool($value.persistentConnection);
      case 'reasonPhrase':
        final res = $value.reasonPhrase;
        return res == null ? const $null() : $String(res);
      case 'statusCode':
        return $int($value.statusCode);
      case 'request':
        final res = $value.request;
        return res == null ? const $null() : $BaseRequest.wrap(res);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper for [StreamedResponse]
class $StreamedResponse implements $Instance {
  $StreamedResponse.wrap(this.$value) : _superclass = $Object($value);

  @override
  final StreamedResponse $value;

  /// Compile-time bridged type reference for [$StreamedResponse]
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'StreamedResponse'));

  /// Compile-time bridged class declaration for [$StreamedResponse]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
          BridgeFunctionDef(returns: BridgeTypeAnnotation($type)))
    },
    getters: {
      'stream': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation($ByteStream.$type),
      )),
      'contentLength': BridgeMethodDef(BridgeFunctionDef(
        returns:
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int), nullable: true),
      )),
      'headers': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.map, [
            BridgeTypeRef(CoreTypes.string),
            BridgeTypeRef(CoreTypes.string)
          ]),
        ),
      )),
      'isRedirect': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
      )),
      'persistentConnection': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
      )),
      'reasonPhrase': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
            nullable: true),
      )),
      'statusCode': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
      )),
      'request': BridgeMethodDef(BridgeFunctionDef(
        returns: BridgeTypeAnnotation($BaseRequest.$type, nullable: true),
      )),
    },
    wrap: true,
  );

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'stream':
        return $ByteStream.wrap($value.stream);
      case 'contentLength':
        final res = $value.contentLength;
        return res == null ? const $null() : $int(res);
      case 'headers':
        return $Map.wrap($value.headers);
      case 'isRedirect':
        return $bool($value.isRedirect);
      case 'persistentConnection':
        return $bool($value.persistentConnection);
      case 'reasonPhrase':
        final res = $value.reasonPhrase;
        return res == null ? const $null() : $String(res);
      case 'statusCode':
        return $int($value.statusCode);
      case 'request':
        final res = $value.request;
        return res == null ? const $null() : $BaseRequest.wrap(res);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper for [ByteStream]
class $ByteStream implements $Instance {
  $ByteStream.wrap(this.$value) : _superclass = $Object($value);

  @override
  final ByteStream $value;

  /// Compile-time bridged type reference for [$ByteStream]
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'ByteStream'));

  /// Compile-time bridged class declaration for [$ByteStream]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
          BridgeFunctionDef(returns: BridgeTypeAnnotation($type)))
    },
    getters: {},
    wrap: true,
  );

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    _superclass.$setProperty(runtime, identifier, value);
  }
}

Map<String, String>? _toMapString(Map<$Value, $Value>? value) {
  return value?.map((key, value) =>
      MapEntry((key.$reified).toString(), (value.$reified).toString()));
}

Object? _toBodyObject(Object? value) {
  Object? body;
  if (value is Map<$Value, $Value>) {
    body = value.map((key, value) =>
        MapEntry((key.$reified).toString(), (value.$reified).toString()));
  } else if (value is List<$Value>) {
    body = value.map((e) => e.$reified).toList();
  } else {
    body = value;
  }
  return body;
}

extension FutureResponseExtension<T> on Future<T> {
  Future<T> onErrorMessage() {
    onError((error, stackTrace) {
      if (kDebugMode) {
        print("Http error: $error");
      }
      botToast(error.toString());
      throw error.toString();
    });
    return this;
  }
}
