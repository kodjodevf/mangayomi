/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'dart:ffi';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import 'package:media_kit/media_kit.dart';

// ignore_for_file: implementation_imports
import 'package:media_kit/ffi/ffi.dart';
import 'package:media_kit/src/player/native/core/native_library.dart';

import 'package:media_kit/generated/libmpv/bindings.dart';

import 'package:media_kit_video/src/utils/query_decoders.dart';
import 'package:media_kit_video/src/video_controller/platform_video_controller.dart';

/// {@template android_video_controller}
///
/// AndroidVideoController
/// ----------------------
///
/// The [PlatformVideoController] implementation based on native JNI & C/C++ used on Android.
///
/// {@endtemplate}
class AndroidVideoController extends PlatformVideoController {
  /// Whether [AndroidVideoController] is supported on the current platform or not.
  static bool get supported => Platform.isAndroid;

  /// Fixed width of the video output.
  int? width;

  /// Fixed height of the video output.
  int? height;

  // ----------------------------------------------

  bool get androidAttachSurfaceAfterVideoParameters =>
      configuration.androidAttachSurfaceAfterVideoParameters ?? vo == 'gpu';

  /// --vo
  String get vo => configuration.vo ?? 'gpu';

  /// --hwdec
  Future<String> get hwdec async {
    if (_hwdec != null) {
      return _hwdec!;
    }
    bool enableHardwareAcceleration = configuration.enableHardwareAcceleration;
    // Enforce software rendering in emulators.
    final bool isEmulator = await _channel.invokeMethod('Utils.IsEmulator');
    if (isEmulator) {
      debugPrint('media_kit: AndroidVideoController: Emulator detected.');
      debugPrint('media_kit: AndroidVideoController: Enforcing S/W rendering.');
      enableHardwareAcceleration = false;
    }
    _hwdec = configuration.hwdec ??
        (enableHardwareAcceleration ? 'auto-safe' : 'no');
    return _hwdec!;
  }

  String? _hwdec;

  // ----------------------------------------------

  String? _current;

  /// {@macro android_video_controller}
  AndroidVideoController._(
    super.player,
    super.configuration,
  ) {
    final platform = player.platform as NativePlayer;
    platform.onLoadHooks.add(() {
      return _lock.synchronized(
        () async {
          final handle = await player.handle;
          NativeLibrary.ensureInitialized();
          final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));

          // Skip surface re-creation if same resource.
          final name = 'path'.toNativeUtf8();
          final path = mpv.mpv_get_property_string(
            Pointer.fromAddress(handle),
            name.cast(),
          );
          final current = path.cast<Utf8>().toDartString();
          calloc.free(name.cast());
          mpv.mpv_free(path.cast());

          bool refresh = _current != current;

          _current = current;

          if (refresh) {
            // It is important to use a new android.view.Surface each time a new video-output is created because: https://stackoverflow.com/a/21564236
            // Not doing so will cause MediaCodec usage inside libavcodec to incorrectly fail with error (because this android.view.Surface would be used twice):
            // "native_window_api_connect returned an error: Invalid argument (-22)" & next less-efficient hwdec will be used redundantly.

            // Create a new android.view.Surface & obtain object reference to it.
            // NOTE: Previous android.view.Surface & object reference is internally released/destroyed by the method.
            final data = await _channel.invokeMethod(
              'VideoOutputManager.CreateSurface',
              {
                'handle': handle.toString(),
              },
            );
            debugPrint(data.toString());
            // Save the android.view.Surface object reference for usage inside player.stream.videoParams.listen.
            _wid = data['wid'];
          }

          // By default, android.view.Surface has a size of 1x1. If we assign --wid here, libmpv will internally start rendering & the first frame will be drawn as a solid color: https://github.com/media-kit/media-kit/issues/339
          // The solution is to assign --wid after android.graphics.SurfaceTexture.setDefaultBufferSize has been called & --android-surface-size has been updated (see inside player.stream.videoParams.listen).

          // Assign --wid here if --vo is not "gpu" or "null" i.e. custom vo/hwdec was passed through [VideoControllerConfiguration].
          try {
            // ----------------------------------------------
            if (!androidAttachSurfaceAfterVideoParameters) {
              final values = {
                // NOTE: ORDER IS IMPORTANT.
                'wid': _wid.toString(),
                'vo': vo,
              };
              for (final entry in values.entries) {
                final name = entry.key.toNativeUtf8();
                final value = entry.value.toNativeUtf8();
                mpv.mpv_set_option_string(
                  Pointer.fromAddress(handle),
                  name.cast(),
                  value.cast(),
                );
                calloc.free(name);
                calloc.free(value);
              }
            }
            // ----------------------------------------------
          } catch (exception, stacktrace) {
            debugPrint(exception.toString());
            debugPrint(stacktrace.toString());
          }
        },
      );
    });
    platform.onUnloadHooks.add(() {
      return _lock.synchronized(
        () async {
          final handle = await player.handle;
          NativeLibrary.ensureInitialized();
          final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));
          // Release any references to current android.view.Surface.
          //
          // It is important to set --vo=null here for 2 reasons:
          // 1. Allow the native code to drop any references to the android.view.Surface.
          // 2. Resize the android.graphics.SurfaceTexture to next video's resolution before setting --vo=gpu.
          try {
            // ----------------------------------------------
            final values = {
              // NOTE: ORDER IS IMPORTANT.
              'vo': 'null',
              'wid': '0',
            };
            for (final entry in values.entries) {
              final name = entry.key.toNativeUtf8();
              final value = entry.value.toNativeUtf8();
              mpv.mpv_set_option_string(
                Pointer.fromAddress(handle),
                name.cast(),
                value.cast(),
              );
              calloc.free(name);
              calloc.free(value);
            }
            // ----------------------------------------------
          } catch (exception, stacktrace) {
            debugPrint(exception.toString());
            debugPrint(stacktrace.toString());
          }
        },
      );
    });

    _subscription = player.stream.videoParams.listen(
      (event) => _lock.synchronized(() async {
        if ([0, null].contains(event.dw) ||
            [0, null].contains(event.dh) ||
            _wid == null) {
          return;
        }

        final int width;
        final int height;
        if (event.rotate == 0 || event.rotate == 180) {
          width = event.dw ?? 0;
          height = event.dh ?? 0;
        } else {
          // width & height are swapped for 90 or 270 degrees rotation.
          width = event.dh ?? 0;
          height = event.dw ?? 0;
        }

        rect.value = Rect.zero;
        try {
          final handle = await player.handle;
          NativeLibrary.ensureInitialized();
          final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));

          if (vo == 'gpu') {
            // NOTE: Only required for --vo=gpu
            // With --vo=gpu, we need to update the android.graphics.SurfaceTexture size & notify libmpv to re-create vo.
            // In native Android, this kind of rendering is done with android.view.SurfaceView + android.view.SurfaceHolder, which offers onSurfaceChanged to handle this.
            await _channel.invokeMethod(
              'VideoOutputManager.SetSurfaceTextureSize',
              {
                'handle': handle.toString(),
                'width': width.toString(),
                'height': height.toString(),
              },
            );

            // ----------------------------------------------
            final values = {
              // NOTE: ORDER IS IMPORTANT.
              'android-surface-size': [width, height].join('x'),
              'wid': _wid.toString(),
              'vo': 'gpu',
            };
            for (final entry in values.entries) {
              final name = entry.key.toNativeUtf8();
              final value = entry.value.toNativeUtf8();
              mpv.mpv_set_option_string(
                Pointer.fromAddress(handle),
                name.cast(),
                value.cast(),
              );
              calloc.free(name);
              calloc.free(value);
            }
          }
          // ----------------------------------------------
        } catch (exception, stacktrace) {
          debugPrint(exception.toString());
          debugPrint(stacktrace.toString());
        }
        rect.value = Rect.fromLTWH(
          0.0,
          0.0,
          width.toDouble(),
          height.toDouble(),
        );
      }),
    );
  }

  /// {@macro android_video_controller}
  static Future<PlatformVideoController> create(
    Player player,
    VideoControllerConfiguration configuration,
  ) async {
    // Retrieve the native handle of the [Player].
    final handle = await player.handle;
    // Return the existing [VideoController] if it's already created.
    if (_controllers.containsKey(handle)) {
      return _controllers[handle]!;
    }

    // In case no video-decoders are found, this means media_kit_libs_***_audio is being used.
    // Thus, --vid=no is required to prevent libmpv from trying to decode video (otherwise bad things may happen).
    //
    // Search for common H264 decoder to check if video support is available.
    final decoders = await queryDecoders(handle);
    if (!decoders.contains('h264')) {
      throw UnsupportedError(
        '[VideoController] is not available.'
        ' '
        'Please use media_kit_libs_***_video instead of media_kit_libs_***_audio.',
      );
    }

    // Creation:
    final controller = AndroidVideoController._(
      player,
      configuration,
    );

    // Register [_dispose] for execution upon [Player.dispose].
    player.platform?.release.add(controller._dispose);

    // Store the [VideoController] in the [_controllers].
    _controllers[handle] = controller;

    final data = await _channel.invokeMethod(
      'VideoOutputManager.Create',
      {
        'handle': handle.toString(),
      },
    );
    debugPrint(data.toString());

    controller._id = data['id'];

    // ----------------------------------------------
    NativeLibrary.ensureInitialized();
    final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));

    final values = configuration.vo == null || configuration.hwdec == null
        ? {
            // It is necessary to set vo=null here to avoid SIGSEGV, --wid must be assigned before vo=gpu is set.
            'vo': 'null',
            'hwdec': await controller.hwdec,
          }
        : {
            'vo': 'null',
            'hwdec': await controller.hwdec,
          };
    values.addAll(
      {
        'vid': 'auto',
        'opengl-es': 'yes',
        'force-window': 'yes',
        'gpu-context': 'android',
        'sub-use-margins': 'no',
        'sub-font-provider': 'none',
        'sub-scale-with-window': 'yes',
        'hwdec-codecs': 'h264,hevc,mpeg4,mpeg2video,vp8,vp9,av1',
      },
    );

    for (final entry in values.entries) {
      final name = entry.key.toNativeUtf8();
      final value = entry.value.toNativeUtf8();
      mpv.mpv_set_property_string(
        Pointer.fromAddress(handle),
        name.cast(),
        value.cast(),
      );
      calloc.free(name);
      calloc.free(value);
    }
    // ----------------------------------------------

    controller.id.value = controller._id;

    // Return the [PlatformVideoController].
    return controller;
  }

  /// Sets the required size of the video output.
  /// This may yield substantial performance improvements if a small [width] & [height] is specified.
  ///
  /// Remember:
  /// * “Premature optimization is the root of all evil”
  /// * “With great power comes great responsibility”
  @override
  Future<void> setSize({
    int? width,
    int? height,
  }) {
    throw UnsupportedError(
      '[AndroidVideoController.setSize] is not available on Android',
    );
  }

  /// Disposes the instance. Releases allocated resources back to the system.
  Future<void> _dispose() async {
    // Dispose the [StreamSubscription]s.
    await _subscription?.cancel();
    // Release the native resources.
    final handle = await player.handle;
    _controllers.remove(handle);
    await _channel.invokeMethod(
      'VideoOutputManager.Dispose',
      {
        'handle': handle.toString(),
      },
    );
  }

  /// Texture ID returned by Flutter's texture registry.
  int? _id;

  /// Pointer address to the global object reference of `android.view.Surface` i.e. `(intptr_t)(*android.view.Surface)`.
  int? _wid;

  /// [Lock] used to synchronize the [_widthStreamSubscription] & [_heightStreamSubscription].
  final _lock = Lock();

  /// [StreamSubscription] for listening to video [Rect] from [_controller].
  StreamSubscription<VideoParams>? _subscription;

  /// Currently created [AndroidVideoController]s.
  static final _controllers = HashMap<int, AndroidVideoController>();

  /// [MethodChannel] for invoking platform specific native implementation.
  static final _channel =
      const MethodChannel('com.alexmercerind/media_kit_video')
        ..setMethodCallHandler(
          (MethodCall call) async {
            try {
              debugPrint(call.method.toString());
              debugPrint(call.arguments.toString());
              switch (call.method) {
                case 'VideoOutput.WaitUntilFirstFrameRenderedNotify':
                  {
                    // Notify about updated texture ID & [Rect].
                    final int handle = call.arguments['handle'];
                    debugPrint(handle.toString());
                    // Notify about the first frame being rendered.
                    final completer = _controllers[handle]
                        ?.waitUntilFirstFrameRenderedCompleter;
                    if (!(completer?.isCompleted ?? true)) {
                      completer?.complete();
                    }
                    break;
                  }
                default:
                  {
                    break;
                  }
              }
            } catch (exception, stacktrace) {
              debugPrint(exception.toString());
              debugPrint(stacktrace.toString());
            }
          },
        );
}
