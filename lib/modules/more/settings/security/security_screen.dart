import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  late final l10n = context.l10n;
  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _canCheckBiometrics = canAuth || isDeviceSupported;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _canCheckBiometrics = false);
      }
    }
  }

  Future<bool> _authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: l10n.auth_to_change_security_setting,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLockEnabled = ref.watch(appLockEnabledStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.security)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            footer: l10n.app_lock_description,
            children: [
              ShioriSwitchRow(
                autofocus: isTv,
                icon: Symbols.lock_rounded,
                title: l10n.app_lock,
                subtitle: _canCheckBiometrics
                    ? l10n.require_biometric_or_device_credential
                    : l10n.biometric_or_device_credential_not_available,
                value: appLockEnabled,
                // Turning the lock either way asks for the device's own
                // authentication first.
                onChanged: _canCheckBiometrics
                    ? (value) async {
                        if (!await _authenticate()) return;
                        ref
                            .read(appLockEnabledStateProvider.notifier)
                            .set(value);
                        if (!value) {
                          ref.read(appUnlockedStateProvider.notifier).unlock();
                        }
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
