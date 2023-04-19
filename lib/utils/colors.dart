import 'package:flutter/material.dart';

generalColor(BuildContext context) {
  return Theme.of(context).toggleButtonsTheme.color;
}

secondaryColor(BuildContext context) {
  return Theme.of(context).iconTheme.color!.withOpacity(0.7);
}
