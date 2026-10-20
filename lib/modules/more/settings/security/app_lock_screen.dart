import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  late final l10n = context.l10n;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: l10n.auth_unlock_msg,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      if (didAuthenticate && mounted) {
        ref.read(appUnlockedStateProvider.notifier).unlock();
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(ShioriSpace.s24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: ShioriSpace.s8,
              children: [
                Icon(
                  Symbols.lock_rounded,
                  fill: 1,
                  size: context.shiori.scaled(72),
                  color: context.shiori.color.accentInk,
                ),
                const SizedBox(height: ShioriSpace.s16),
                Text(
                  l10n.app_locked,
                  textAlign: TextAlign.center,
                  style: context.shiori.text.screenTitle.copyWith(
                    color: context.shiori.color.fg,
                  ),
                ),
                Text(
                  l10n.auth_unlock_msg,
                  textAlign: TextAlign.center,
                  style: context.shiori.text.body.copyWith(
                    color: context.shiori.color.fgMuted,
                  ),
                ),
                const SizedBox(height: ShioriSpace.s24),
                ShioriButton(
                  autofocus: true,
                  icon: Symbols.fingerprint_rounded,
                  label: _isAuthenticating ? l10n.authenticating : l10n.unlock,
                  onPressed: _isAuthenticating ? null : _authenticate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
