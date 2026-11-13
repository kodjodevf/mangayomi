import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shiori/shiori.dart';

/// Scans a host's QR code; pops with the invite in it.
class PairingScannerScreen extends StatefulWidget {
  const PairingScannerScreen({super.key});

  @override
  State<PairingScannerScreen> createState() => _PairingScannerScreenState();
}

class _PairingScannerScreenState extends State<PairingScannerScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  var _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final invite = PairingInvite.parse(barcode.rawValue ?? '');
      if (invite != null) {
        _done = true;
        Navigator.pop(context, invite);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.device_sync_scan)),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(ShioriSpace.s16),
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s16,
                  vertical: ShioriSpace.s8,
                ),
                decoration: BoxDecoration(
                  // shiori: a scrim over the camera, dark in either theme.
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(ShioriShape.sheet),
                ),
                child: Text(
                  context.l10n.device_sync_scan_hint,
                  textAlign: TextAlign.center,
                  // shiori: on the scrim above, in either theme.
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
