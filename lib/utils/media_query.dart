import 'package:flutter/material.dart';

double mediaHeight(BuildContext context, double data) {
  return MediaQuery.of(context).size.height * data;
}

double mediaWidth(BuildContext context, double data) {
  return MediaQuery.of(context).size.width * data;
}

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= 1200;
}

bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600;
}