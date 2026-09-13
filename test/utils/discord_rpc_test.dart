import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/discord_rpc.dart';

void main() {
  test('an outgoing reader cannot reset a newer chapter presence', () async {
    final rpc = _RecordingDiscordRPC();
    final outgoingReader = rpc.beginReaderSession();
    final incomingReader = rpc.beginReaderSession();

    await rpc.endReaderSession(outgoingReader);

    expect(rpc.idleCalls, 0);

    await rpc.endReaderSession(incomingReader);

    expect(rpc.idleCalls, 1);
  });
}

class _RecordingDiscordRPC extends DiscordRPC {
  _RecordingDiscordRPC() : super(applicationId: 'test');

  int idleCalls = 0;

  @override
  Future<void> showIdleText() async {
    idleCalls++;
  }
}
