import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:win32_registry/win32_registry.dart';

import './protocol.dart';

final _hive = CURRENT_USER;

class WindowsProtocolHandler extends ProtocolHandler {
  @override
  void register(String scheme, {String? executable, List<String>? arguments}) {
    if (defaultTargetPlatform != TargetPlatform.windows) return;

    final prefix = _regPrefix(scheme);
    final capitalized = scheme[0].toUpperCase() + scheme.substring(1);
    final cmd =
        '${executable ?? Platform.resolvedExecutable} ${getArguments(arguments).map(_sanitize).join(' ')}';

    final rootKey = _hive.create(prefix);
    rootKey.setValue('', RegistryValue.string('URL:$capitalized'));
    rootKey.setValue('URL Protocol', RegistryValue.string(''));
    rootKey
        .create(r'shell\open\command')
        .setValue('', RegistryValue.string(cmd));
  }

  @override
  void unregister(String scheme) {
    if (defaultTargetPlatform != TargetPlatform.windows) return;

    _hive.removeSubkey(_regPrefix(scheme));
  }

  String _regPrefix(String scheme) => r'SOFTWARE\Classes\$scheme';

  String _sanitize(String value) {
    value = value.replaceAll(r'%s', '%1').replaceAll(r'"', '\\"');
    return '"$value"';
  }
}
