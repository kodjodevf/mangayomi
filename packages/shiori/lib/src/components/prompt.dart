import 'package:flutter/material.dart';

import '../tokens.dart';
import 'button.dart';
import 'dialog.dart';

/// Asks for a line of text: a name, a URL, a password. Resolves to the text
/// confirmed, or null when the dialog is cancelled.
///
/// [validator] returns an error to show under the field, or null when the
/// text is acceptable; the confirm button stays off while the text is
/// empty unless [allowEmpty]. Enter confirms.
Future<String?> showShioriPrompt(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? message,
  String initialValue = '',
  String? label,
  String? hint,
  bool obscure = false,
  bool allowEmpty = false,
  int maxLines = 1,
  TextInputType? keyboardType,
  String? Function(String text)? validator,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _Prompt(
      title: title,
      confirmLabel: confirmLabel,
      message: message,
      initialValue: initialValue,
      label: label,
      hint: hint,
      obscure: obscure,
      allowEmpty: allowEmpty,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    ),
  );
}

class _Prompt extends StatefulWidget {
  const _Prompt({
    required this.title,
    required this.confirmLabel,
    required this.message,
    required this.initialValue,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.allowEmpty,
    required this.maxLines,
    required this.keyboardType,
    required this.validator,
  });

  final String title;
  final String confirmLabel;
  final String? message;
  final String initialValue;
  final String? label;
  final String? hint;
  final bool obscure;
  final bool allowEmpty;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String text)? validator;

  @override
  State<_Prompt> createState() => _PromptState();
}

class _PromptState extends State<_Prompt> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue)
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.initialValue.length,
        );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      (widget.allowEmpty || _controller.text.trim().isNotEmpty) &&
      _error == null;

  void _onChanged(String text) =>
      setState(() => _error = widget.validator?.call(text));

  void _confirm() {
    final error = widget.validator?.call(_controller.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    if (!_canConfirm) return;
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return ShioriDialog(
      title: widget.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: ShioriSpace.s16,
        children: [
          if (widget.message != null) Text(widget.message!),
          TextField(
            controller: _controller,
            autofocus: true,
            obscureText: widget.obscure,
            maxLines: widget.obscure ? 1 : widget.maxLines,
            keyboardType: widget.keyboardType,
            textInputAction: widget.maxLines == 1
                ? TextInputAction.done
                : TextInputAction.newline,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              errorText: _error,
            ),
            onChanged: _onChanged,
            onSubmitted: (_) => _confirm(),
          ),
        ],
      ),
      actions: [
        ShioriButton.quiet(
          label: MaterialLocalizations.of(context).cancelButtonLabel,
          onPressed: () => Navigator.pop(context),
        ),
        ShioriButton(
          label: widget.confirmLabel,
          onPressed: _canConfirm ? _confirm : null,
        ),
      ],
    );
  }
}
