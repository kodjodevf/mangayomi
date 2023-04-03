import 'package:flutter/material.dart';

mediaHeight(BuildContext context, double data) {
  return MediaQuery.of(context).size.height * data;
}

mediaWidth(BuildContext context, double data) {
  return MediaQuery.of(context).size.width * data;
}
