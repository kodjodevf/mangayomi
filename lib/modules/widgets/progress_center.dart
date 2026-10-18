import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// The app's loading indicator, centred: [ShioriLoading]. Kept as a name for
/// the screens that already use it.
class ProgressCenter extends StatelessWidget {
  const ProgressCenter({super.key});

  @override
  Widget build(BuildContext context) => const ShioriLoading();
}
