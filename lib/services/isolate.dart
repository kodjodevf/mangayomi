import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/messages/generated.dart';
import 'package:mangayomi/providers/storage_provider.dart';

Future<void> initInIsolate(RootIsolateToken token) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  await Rinf.initialize();
  HttpOverrides.global = MyHttpoverrides();
  isar = await StorageProvider().initDB(null, inspector: kDebugMode);
  iniDateFormatting();
}
