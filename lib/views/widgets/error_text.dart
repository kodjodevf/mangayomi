import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final dynamic errorText;
  const ErrorText(
    this.errorText, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorText.toString()),
    );
  }
}
