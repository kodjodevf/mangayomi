import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_host/sync_host_controller.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shiori/shiori.dart';

/// Shows a new invite until a device pairs with it or the user closes it.
/// The host only takes a pairing while this is open, and asks here whether
/// to let the device in.
Future<void> showPairingInvite(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(syncHostControllerProvider.notifier);
  await showDialog<void>(
    context: context,
    builder: (_) => const _PairingInviteDialog(),
  );
  controller.closePairing();
}

class _PairingInviteDialog extends ConsumerStatefulWidget {
  const _PairingInviteDialog();

  @override
  ConsumerState<_PairingInviteDialog> createState() =>
      _PairingInviteDialogState();
}

class _PairingInviteDialogState extends ConsumerState<_PairingInviteDialog> {
  var _opening = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(syncHostControllerProvider.notifier).openPairing();
      if (mounted) setState(() => _opening = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(syncHostControllerProvider);
    final pending = state.pending;
    final invite = state.invite;

    // The invite is spent once a device was let in or turned down.
    ref.listen(syncHostControllerProvider.select((s) => s.invite), (
      before,
      after,
    ) {
      if (before != null && after == null && mounted) Navigator.pop(context);
    });

    if (pending != null) {
      return ShioriDialog(
        title: l10n.device_sync_allow_title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ShioriSpace.s8,
          children: [
            Text(l10n.device_sync_allow_message(pending.request.deviceName)),
            Text(pending.request.address, style: context.shiori.caption),
          ],
        ),
        actions: [
          ShioriButton.quiet(
            label: l10n.device_sync_deny,
            onPressed: () => pending.answer(false),
          ),
          ShioriButton(
            label: l10n.device_sync_allow,
            onPressed: () => pending.answer(true),
          ),
        ],
      );
    }

    final Widget content;
    if (_opening && invite == null) {
      content = const Padding(
        padding: EdgeInsets.all(ShioriSpace.s24),
        child: Center(child: ShioriLoading.inline()),
      );
    } else if (invite == null || invite.addresses.isEmpty) {
      content = Text(l10n.device_sync_no_network);
    } else {
      final link = invite.toLink();
      content = Column(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s16,
        children: [
          InviteQrCode(link: link),
          Text(l10n.device_sync_invite_info, style: context.shiori.caption),
          ShioriButton.secondary(
            icon: Symbols.content_copy_rounded,
            label: l10n.device_sync_copy_link,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link));
              botToast(l10n.device_sync_link_copied, second: 2);
            },
          ),
        ],
      );
    }

    return ShioriDialog(
      title: l10n.device_sync_add_device,
      content: SingleChildScrollView(child: content),
      actions: [
        ShioriButton.quiet(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

/// [link] as a QR code, dark on white whatever the theme.
class InviteQrCode extends StatelessWidget {
  const InviteQrCode({super.key, required this.link});

  final String link;

  static const size = 220.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // shiori: a QR code reads best dark on white, in either theme.
      color: Colors.white,
      padding: const EdgeInsets.all(ShioriSpace.s8),
      // A set size: a dialog asks its content how big it wants to be, which
      // a QR code painted to fit its box cannot answer by itself.
      child: SizedBox.square(
        dimension: size,
        child: PrettyQrView.data(
          data: link,
          // Medium correction: still reads with a smudge or glare on screen.
          errorCorrectLevel: QrErrorCorrectLevel.M,
          decoration: const PrettyQrDecoration(
            // shiori: a QR code reads best dark on white, in either theme.
            shape: PrettyQrSmoothSymbol(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
