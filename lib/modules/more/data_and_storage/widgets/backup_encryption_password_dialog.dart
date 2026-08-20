import 'package:flutter/material.dart';
import 'package:mangayomi/services/backup_password_storage.dart';

/// Shows the backup-encryption password setup dialog. Returns `true` if a
/// password was successfully persisted (either to secure storage or, after
/// explicit opt-in, to the plaintext fallback), `false`/`null` otherwise -
/// the caller should only flip the encryption toggle on when this is `true`.
Future<bool?> showBackupEncryptionPasswordDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _BackupEncryptionPasswordDialog(),
  );
}

/// Shown when the OS has no secure storage available (in practice: Linux
/// with no keyring service running). Returns `true` if the user explicitly
/// opted in to storing the password unencrypted, `false`/`null` otherwise.
/// Shared by both the "set a new password" and "restore persisted an
/// embedded password" flows, so the wording/behavior stays consistent.
Future<bool?> showSecureStorageFallbackPrompt(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('No secure storage found'),
      content: const Text(
        'This system doesn\'t have a keyring service available '
        '(e.g. gnome-keyring or kwallet on Linux), so the password '
        'can\'t be stored securely.\n\n'
        'Store it unencrypted in the local app database instead? '
        'Anyone with access to this device\'s app data would be able '
        'to read it.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Store unencrypted'),
        ),
      ],
    ),
  );
}

/// Persists [password] via [BackupPasswordStorage], prompting for the
/// secure-storage-unavailable opt-in fallback if needed. Returns `true` if
/// it ended up stored somewhere, `false` if the user declined the fallback
/// (caller should treat this as "couldn't persist it", not a hard error).
Future<bool> persistResolvedPassword(
  String password,
  BuildContext context,
) async {
  try {
    await BackupPasswordStorage.save(password);
    return true;
  } on SecureStorageUnavailableException {
    if (!context.mounted) return false;
    final useFallback = await showSecureStorageFallbackPrompt(context);
    if (useFallback == true) {
      await BackupPasswordStorage.savePlaintextFallback(password);
      return true;
    }
    return false;
  }
}

/// Prompts for the password to decrypt an existing backup on restore - a
/// single field, no confirmation needed since it's not being newly chosen.
/// Set [wasIncorrect] when re-prompting after a failed attempt to show an
/// error hint. Returns the entered password, or null if cancelled.
Future<String?> showBackupDecryptPasswordDialog(
  BuildContext context, {
  bool wasIncorrect = false,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        _BackupDecryptPasswordDialog(wasIncorrect: wasIncorrect),
  );
}

class _BackupDecryptPasswordDialog extends StatefulWidget {
  final bool wasIncorrect;
  const _BackupDecryptPasswordDialog({required this.wasIncorrect});

  @override
  State<_BackupDecryptPasswordDialog> createState() =>
      _BackupDecryptPasswordDialogState();
}

class _BackupDecryptPasswordDialogState
    extends State<_BackupDecryptPasswordDialog> {
  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter backup password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.wasIncorrect)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Incorrect password, try again.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextField(
            controller: _controller,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (_controller.text.isNotEmpty) {
                Navigator.pop(context, _controller.text);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _controller.text.isEmpty
              ? null
              : () => Navigator.pop(context, _controller.text),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _BackupEncryptionPasswordDialog extends StatefulWidget {
  const _BackupEncryptionPasswordDialog();

  @override
  State<_BackupEncryptionPasswordDialog> createState() =>
      _BackupEncryptionPasswordDialogState();
}

class _BackupEncryptionPasswordDialogState
    extends State<_BackupEncryptionPasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _saving = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_passwordController.text.isEmpty) return false;
    if (!_obscure) return true; // single visible field, nothing to match
    return _passwordController.text == _confirmController.text;
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final password = _passwordController.text;
    final persisted = await persistResolvedPassword(password, context);
    if (!mounted) return;
    if (persisted) {
      Navigator.pop(context, true);
    } else {
      // Declined the fallback prompt (or another error): don't enable
      // encryption without anywhere to persist the password, per the
      // feature's whole point being "set it once".
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set backup password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_obscure) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                errorText:
                    _confirmController.text.isNotEmpty &&
                        _confirmController.text != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (_canSubmit && !_saving) ? _submit : null,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('OK'),
        ),
      ],
    );
  }
}
