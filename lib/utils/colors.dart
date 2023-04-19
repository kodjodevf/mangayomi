import 'package:flutter/material.dart';

Color generalColor(BuildContext context) {
  return Theme.of(context).toggleButtonsTheme.color!;
}

Color secondaryColor(BuildContext context) {
  return Theme.of(context).iconTheme.color!.withOpacity(0.7);
}
