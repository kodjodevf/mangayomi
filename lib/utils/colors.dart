import 'package:flutter/material.dart';

Color primaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

Color secondaryColor(BuildContext context) {
  return Theme.of(context).iconTheme.color!.withOpacity(0.7);
}
