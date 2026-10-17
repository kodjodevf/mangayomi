import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';

/// An error where a screen has nothing to offer but the cause: the shared
/// [ErrorState], with a readable line and the technical detail demoted.
/// It used to print the error, stack and all, as bare centred text.
class ErrorText extends StatelessWidget {
  final dynamic errorText;
  const ErrorText(this.errorText, {super.key});

  @override
  Widget build(BuildContext context) =>
      ErrorState(detail: errorText?.toString());
}
