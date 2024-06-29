/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:io';
import 'dart:ffi';

import 'package:media_kit/ffi/ffi.dart';

/// {@template android_helper}
///
/// AndroidHelper
/// -------------
///
/// Learn more: https://github.com/media-kit/media-kit-android-helper
///
/// {@endtemplate}
abstract class AndroidHelper {
  /// {@macro android_helper}
  static void ensureInitialized() {
    try {
      if (Platform.isAndroid) {
        // Load the required shared libraries:
        // * libmpv.so
        // * libavcodec.so
        // * libmediakitandroidhelper.so.
        DynamicLibrary? libmpv, libavcodec, libmediakitandroidhelper;
        try {
          libmpv = DynamicLibrary.open(
            'libmpv.so',
          );
        } catch (_) {}
        try {
          libavcodec = DynamicLibrary.open(
            'libavcodec.so',
          );
        } catch (_) {}
        try {
          libmediakitandroidhelper = DynamicLibrary.open(
            'libmediakitandroidhelper.so',
          );
        } catch (_) {}
        // Look for the required symbols.
        try {
          _mpv_lavc_set_java_vm = libmpv?.lookupFunction<
              mpv_lavc_set_java_vmCXX, mpv_lavc_set_java_vmDart>(
            'mpv_lavc_set_java_vm',
          );
        } catch (_) {}
        try {
          _av_jni_set_java_vm = libavcodec
              ?.lookupFunction<av_jni_set_java_vmCXX, av_jni_set_java_vmDart>(
            'av_jni_set_java_vm',
          );
        } catch (_) {}
        try {
          _MediaKitAndroidHelperGetJavaVM =
              libmediakitandroidhelper?.lookupFunction<
                  MediaKitAndroidHelperGetJavaVMCXX,
                  MediaKitAndroidHelperGetJavaVMDart>(
            'MediaKitAndroidHelperGetJavaVM',
          );
        } catch (_) {}
        try {
          MediaKitAndroidHelperGetFilesDir =
              libmediakitandroidhelper?.lookupFunction<
                  MediaKitAndroidHelperGetFilesDirCXX,
                  MediaKitAndroidHelperGetFilesDirDart>(
            'MediaKitAndroidHelperGetFilesDir',
          );
        } catch (_) {}
        try {
          _MediaKitAndroidHelperIsEmulator =
              libmediakitandroidhelper?.lookupFunction<
                  MediaKitAndroidHelperIsEmulatorCXX,
                  MediaKitAndroidHelperIsEmulatorDart>(
            'MediaKitAndroidHelperIsEmulator',
          );
        } catch (_) {}
        try {
          _MediaKitAndroidHelperGetAPILevel =
              libmediakitandroidhelper?.lookupFunction<
                  MediaKitAndroidHelperGetAPILevelCXX,
                  MediaKitAndroidHelperGetAPILevelDart>(
            'MediaKitAndroidHelperGetAPILevel',
          );
        } catch (_) {}

        if ((_mpv_lavc_set_java_vm ?? _av_jni_set_java_vm) == null) {
          throw UnsupportedError(
            'Cannot load mpv_lavc_set_java_vm (libmpv.so) or av_jni_set_java_vm (libavcodec.so).',
          );
        }
        if (_MediaKitAndroidHelperGetJavaVM == null) {
          throw UnsupportedError(
            'Cannot load MediaKitAndroidHelperGetJavaVM (libmediakitandroidhelper.so).',
          );
        }

        Pointer<Void>? vm;
        while (true) {
          // Invoke av_jni_set_java_vm to set reference to JavaVM*.
          // It is important to call av_jni_set_java_vm so that libavcodec can access JNI environment & thus, mediacodec APIs.
          vm = _MediaKitAndroidHelperGetJavaVM?.call();
          if (vm != null) {
            if (vm != nullptr) {
              // FFmpeg may be statically linked with libmpv, in that case libavcodec.so will not be available.
              // Following patch exposes mpv_lavc_set_java_vm which internally calls av_jni_set_java_vm.
              // https://github.com/media-kit/libmpv-android-video-build/blob/main/buildscripts/patches/mpv/mpv_lavc_set_java_vm.patch
              // https://github.com/media-kit/libmpv-android-audio-build/blob/main/buildscripts/patches/mpv/mpv_lavc_set_java_vm.patch
              final fn = _mpv_lavc_set_java_vm ?? _av_jni_set_java_vm;
              if (fn != null) {
                fn(vm);
                break;
              }
            }
          }
          sleep(const Duration(milliseconds: 20));
        }
      }
    } catch (_) {}
  }

  static String? get filesDir {
    if (Platform.isAndroid) {
      final filesDir = MediaKitAndroidHelperGetFilesDir?.call();
      if (filesDir != null) {
        if (filesDir != nullptr) {
          return filesDir.toDartString();
        }
      }
    }
    return null;
  }

  static bool get isEmulator {
    if (Platform.isAndroid) {
      return _MediaKitAndroidHelperIsEmulator?.call() == 1;
    }
    return false;
  }

  static bool get isPhysicalDevice {
    if (Platform.isAndroid) {
      return !isEmulator;
    }
    return false;
  }

  static int get APILevel {
    if (Platform.isAndroid) {
      return _MediaKitAndroidHelperGetAPILevel?.call() ?? -1;
    }
    return -1;
  }

  static av_jni_set_java_vmDart? _av_jni_set_java_vm;
  static mpv_lavc_set_java_vmDart? _mpv_lavc_set_java_vm;
  static MediaKitAndroidHelperGetJavaVMDart? _MediaKitAndroidHelperGetJavaVM;
  static MediaKitAndroidHelperGetFilesDirDart? MediaKitAndroidHelperGetFilesDir;
  static MediaKitAndroidHelperIsEmulatorDart? _MediaKitAndroidHelperIsEmulator;
  static MediaKitAndroidHelperGetAPILevelDart?
      _MediaKitAndroidHelperGetAPILevel;
}

typedef av_jni_set_java_vmCXX = Int32 Function(Pointer<Void> vm);
typedef av_jni_set_java_vmDart = int Function(Pointer<Void> vm);

typedef mpv_lavc_set_java_vmCXX = Int32 Function(Pointer<Void> vm);
typedef mpv_lavc_set_java_vmDart = int Function(Pointer<Void> vm);

typedef MediaKitAndroidHelperGetJavaVMCXX = Pointer<Void> Function();
typedef MediaKitAndroidHelperGetJavaVMDart = Pointer<Void> Function();

typedef MediaKitAndroidHelperGetFilesDirCXX = Pointer<Utf8> Function();
typedef MediaKitAndroidHelperGetFilesDirDart = Pointer<Utf8> Function();

typedef MediaKitAndroidHelperIsEmulatorCXX = Int8 Function();
typedef MediaKitAndroidHelperIsEmulatorDart = int Function();

typedef MediaKitAndroidHelperGetAPILevelCXX = Int32 Function();
typedef MediaKitAndroidHelperGetAPILevelDart = int Function();
