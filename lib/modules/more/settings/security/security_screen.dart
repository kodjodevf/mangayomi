import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: appLockEnabled,
              title: Text(l10n.app_lock),
              subtitle: Text(
                _canCheckBiometrics
                    ? l10n.require_biometric_or_device_credential
                    : l10n.biometric_or_device_credential_not_available,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              onChanged: _canCheckBiometrics
                  ? (value) async {
                      if (value) {
                        final authenticated = await _authenticate();
                        if (authenticated) {
                          ref
                              .read(appLockEnabledStateProvider.notifier)
                              .set(true);
                        }
                      } else {
                        final authenticated = await _authenticate();
                        if (authenticated) {
                          ref
                              .read(appLockEnabledStateProvider.notifier)
                              .set(false);
                          ref.read(appUnlockedStateProvider.notifier).unlock();
                        }
                      }
                    }
                  : null,
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.app_lock_description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
