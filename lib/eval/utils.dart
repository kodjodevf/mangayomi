const utils = r'''
import 'package:bridge_lib/bridge_lib.dart';
class Substring {
  final String _text;

  Substring(this._text);

  Substring substringAfter(String pattern) {
    return Substring(MBridge.substringAfter(_text,pattern));
  }

  Substring substringBefore(String pattern) {
    return Substring(MBridge.substringBefore(_text,pattern));
  }

  Substring substringBeforeLast(String pattern) {
    return Substring(MBridge.substringBeforeLast(_text,pattern));
  }


  String get text => _text;
}''';
