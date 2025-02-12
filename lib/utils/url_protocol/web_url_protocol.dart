import './protocol.dart';

class WindowsProtocolHandler extends ProtocolHandler {
  @override
  void register(String scheme, {String? executable, List<String>? arguments}) {}

  @override
  void unregister(String scheme) {}
}