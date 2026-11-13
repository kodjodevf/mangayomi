import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/settings/sync/device_sync/pairing_invite_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

void main() {
  testWidgets('the invite QR code lays out inside a dialog', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AlertDialog(
          title: Text('Add a device'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InviteQrCode(link: 'mangayomi-sync://pair?u=https://a:1'),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(PrettyQrView), findsOneWidget);
  });
}
