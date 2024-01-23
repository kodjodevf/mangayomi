import 'package:mangayomi/messages/boa_js.pb.dart';
import 'dart:async';

int nextId = 0;

Future<String> evalJs(String script) async {
  final currentId = nextId;
  nextId++;
  final completer = Completer<String>();
  BoaInput(
    interactionId: currentId,
    codeScript: script,
  ).sendSignalToRust(null);
  final stream = BoaOutput.rustSignalStream;
  final subscription = stream.listen((rustSignal) {
    if (rustSignal.message.interactionId == currentId) {
      completer.complete(rustSignal.message.response);
    }
  });
  final response = await completer.future;
  subscription.cancel();

  return response;
}
