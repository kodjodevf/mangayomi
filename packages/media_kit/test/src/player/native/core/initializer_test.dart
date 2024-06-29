/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:ffi';
import 'dart:async';
import 'package:path/path.dart';
import 'package:test/test.dart';

import 'package:media_kit/ffi/ffi.dart';

import 'package:media_kit/src/player/native/core/initializer.dart';
import 'package:media_kit/src/player/native/core/native_library.dart';

import 'package:media_kit/generated/libmpv/bindings.dart';

void main() {
  setUp(NativeLibrary.ensureInitialized);
  test(
    'initializer-create',
    () {
      expect(
        Initializer.create(NativeLibrary.path, (_) async {}),
        completes,
      );
    },
  );
  test(
    'initializer-dispose',
    () async {
      final handle = await Initializer.create(NativeLibrary.path, (_) async {});
      expect(
        () => Initializer.dispose(handle),
        returnsNormally,
      );
    },
  );
  test(
    'initializer-callback',
    () async {
      final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));

      int count = 0;
      final shutdown = Completer();

      final expectPauseFalse = expectAsync1((value) {
        print(value);
        expect(value, isFalse);
        count++;
        if (count == 2) {
          shutdown.complete();
        }
      });
      final expectPauseTrue = expectAsync1((value) {
        print(value);
        expect(value, isTrue);
        count++;
        if (count == 2) {
          shutdown.complete();
        }
      });
      final expectShutdown = expectAsync0(() {
        print('shutdown');
        expect(true, isTrue);
      });

      final handle = await Initializer.create(
        NativeLibrary.path,
        (event) async {
          if (event.ref.event_id == mpv_event_id.MPV_EVENT_PROPERTY_CHANGE) {
            final prop = event.ref.data.cast<mpv_event_property>();
            if (prop.ref.name.cast<Utf8>().toDartString() == 'pause' &&
                prop.ref.format == mpv_format.MPV_FORMAT_FLAG) {
              final value = prop.ref.data.cast<Bool>().value;
              if (value) {
                expectPauseTrue(value);
              }
              if (!value) {
                expectPauseFalse(value);
              }
            }
          }
          if (event.ref.event_id == mpv_event_id.MPV_EVENT_SHUTDOWN) {
            expectShutdown();
          }
        },
      );
      await Future.delayed(Duration(seconds: 5));
      {
        final name = 'pause'.toNativeUtf8();
        mpv.mpv_observe_property(
          handle,
          0,
          name.cast(),
          mpv_format.MPV_FORMAT_FLAG,
        );
        calloc.free(name);
      }
      {
        final command = 'cycle pause'.toNativeUtf8();
        mpv.mpv_command_string(
          handle,
          command.cast(),
        );
        calloc.free(command);
      }
      await shutdown.future;
      {
        final command = 'quit 0'.toNativeUtf8();
        mpv.mpv_command_string(
          handle,
          command.cast(),
        );
        calloc.free(command);
      }

      await Future.delayed(const Duration(seconds: 5));

      Initializer.dispose(handle);
    },
  );
  test(
    'initializer-options-with-callback',
    () async {
      final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));
      final handle = await Initializer.create(
        NativeLibrary.path,
        (_) async {},
        options: {
          'config': 'yes',
          'config-dir': dirname(Platform.script.toFilePath()),
        },
      );
      {
        final name = 'config'.toNativeUtf8();
        final value = mpv.mpv_get_property_string(
          handle,
          name.cast(),
        );
        calloc.free(name);
        expect(
          value.cast<Utf8>().toDartString(),
          'yes',
        );
      }
      {
        final name = 'config-dir'.toNativeUtf8();
        final value = mpv.mpv_get_property_string(
          handle,
          name.cast(),
        );
        calloc.free(name);
        expect(
          value.cast<Utf8>().toDartString(),
          dirname(Platform.script.toFilePath()),
        );
      }

      await Future.delayed(const Duration(seconds: 5));

      Initializer.dispose(handle);
    },
  );
  test(
    'initializer-options-without-callback',
    () async {
      final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));
      final handle = await Initializer.create(
        NativeLibrary.path,
        null,
        options: {
          'config': 'yes',
          'config-dir': dirname(Platform.script.toFilePath()),
        },
      );
      {
        final name = 'config'.toNativeUtf8();
        final value = mpv.mpv_get_property_string(
          handle,
          name.cast(),
        );
        calloc.free(name);
        expect(
          value.cast<Utf8>().toDartString(),
          'yes',
        );
      }
      {
        final name = 'config-dir'.toNativeUtf8();
        final value = mpv.mpv_get_property_string(
          handle,
          name.cast(),
        );
        calloc.free(name);
        expect(
          value.cast<Utf8>().toDartString(),
          dirname(Platform.script.toFilePath()),
        );
      }

      await Future.delayed(const Duration(seconds: 5));

      Initializer.dispose(handle);
    },
  );
}
