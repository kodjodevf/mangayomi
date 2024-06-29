/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:ffi';
import 'dart:async';
import 'dart:isolate';
import 'dart:collection';

import 'package:media_kit/ffi/ffi.dart';
import 'package:media_kit/src/values.dart';
import 'package:media_kit/generated/libmpv/bindings.dart';

/// InitializerIsolate
/// ------------------
///
/// Creates & returns initialized [Pointer<mpv_handle>] whose event loop is running on separate [Isolate].
abstract class InitializerIsolate {
  /// Creates & returns initialized [Pointer<mpv_handle>] whose event loop is running on separate [Isolate].
  static Future<Pointer<mpv_handle>> create(
    String path,
    Future<void> Function(Pointer<mpv_event> event)? callback,
    Map<String, String> options,
  ) async {
    if (callback == null) {
      // No requirement for separate isolate.
      final mpv = MPV(DynamicLibrary.open(path));
      // Creating [mpv_handle].
      final handle = mpv.mpv_create();

      // Set custom defined options before [mpv_initialize].
      for (final entry in options.entries) {
        final name = entry.key.toNativeUtf8();
        final value = entry.value.toNativeUtf8();
        mpv.mpv_set_option_string(
          handle,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }

      // Initializing [mpv_handle].
      mpv.mpv_initialize(handle);
      return handle;
    } else {
      // Used to wait for retrieval of [Pointer<mpv_handle>] from the running [Isolate].
      final completer = Completer();
      // Used to receive events from the separate [Isolate].
      final receiver = ReceivePort();
      // Late initialized [mpv_handle] & [SendPort] of the [ReceievePort] inside the separate [Isolate].
      late Pointer<mpv_handle> handle;
      late SendPort port;
      // Run [_mainloop] in the separate [Isolate].
      final isolate = await Isolate.spawn(
        _mainloop,
        receiver.sendPort,
      );
      receiver.listen(
        (message) async {
          // Receiving [SendPort] of the [ReceivePort] inside the separate [Isolate] to:
          // 1. Send the custom defined options.
          // 2. Send the path to [DynamicLibrary].
          if (!completer.isCompleted && message is SendPort) {
            port = message;
            port.send(options);
            port.send(path);
          }
          // Receiving [Pointer<mpv_handle>] created by separate [Isolate].
          else if (!completer.isCompleted && message is int) {
            handle = Pointer.fromAddress(message);
            completer.complete();
          }
          // Receiving event callbacks.
          else {
            Pointer<mpv_event> event = Pointer.fromAddress(message);
            try {
              await callback(event);
            } catch (exception, stacktrace) {
              print(exception.toString());
              print(stacktrace.toString());
            }
            port.send(true);
          }
        },
      );
      // Awaiting the retrieval of [Pointer<mpv_handle>].
      await completer.future;

      // Save the references.
      _ports[handle.address] = port;
      _isolates[handle.address] = isolate;

      return handle;
    }
  }

  /// Disposes the event loop of the [Pointer<mpv_handle>] created by [create].
  /// NOTE: [Pointer<mpv_handle>] itself is not disposed.
  static void dispose(Pointer<mpv_handle> handle) {
    final port = _ports[handle.address];
    final isolate = _isolates[handle.address];
    if (port != null && isolate != null) {
      port.send(null);
      _ports.remove(handle.address);
      _isolates.remove(handle.address);
      // A voluntary delay. Although, [Isolate.kill] is not necessary since execution in the [Isolate] will stop automatically.
      Future.delayed(const Duration(seconds: 2), () {
        isolate.kill(priority: Isolate.immediate);
      });
    }
  }

  /// Runs on separate [Isolate].
  /// Calls [MPV.mpv_create] & [MPV.mpv_initialize] to create a new [mpv_handle].
  /// Uses [MPV.mpv_wait_event] to wait for the next event & notifies through the passed [SendPort] as the argument.
  ///
  /// First value sent through the [SendPort] is [SendPort] of the internal [ReceivePort].
  /// Second value sent through the [SendPort] is raw address of the [Pointer<mpv_handle>] created by the [Isolate].
  /// Subsequent sent values are [Pointer<mpv_event>].
  static void _mainloop(SendPort port) async {
    // [Completer] used to ensure that the last [mpv_event] is NOT reset to [mpv_event_id.MPV_EVENT_NONE] after waiting using [MPV.mpv_wait_event] again in the continuously running while loop.
    var completer = Completer();

    // Used to recieve the confirmation messages from the main thread about successful receive of the sent event through [SendPort].
    // Upon confirmation, the [Completer] is completed & we jump to next iteration of the while loop waiting with [MPV.mpv_wait_event].
    final receiver = ReceivePort();

    // Send the [SendPort] of internal [ReceivePort].
    port.send(receiver.sendPort);

    // Received data from the [SendPort] for initialization.
    late Map<String, String> options;
    late MPV mpv;

    bool disposed = false;

    Pointer<mpv_handle>? handle;

    // * First received value is [Map<String, String>] of options.
    // * Second received value is [String] of path to [DynamicLibrary].
    // * Subsequent [bool] values are used to notify the successful interpretation of the sent event.
    // * [null] value is used to dispose the event loop.
    receiver.listen(
      (message) {
        if (message is Map<String, String>) {
          options = message;
        } else if (message is String) {
          mpv = MPV(DynamicLibrary.open(message));
          completer.complete();
        } else if (message is bool) {
          completer.complete();
        } else if (message == null) {
          if (handle != null) {
            // Break out of last event await.
            completer.complete();
            // Break out of the possible [MPV.mpv_wait_event] call.
            mpv.mpv_wakeup(handle);
            disposed = true;
          }
        }
      },
    );

    // Wait for the [Completer] to complete.
    await completer.future;

    // Creating [mpv_handle].
    handle ??= mpv.mpv_create();

    // Set custom defined options before [mpv_initialize].
    for (final entry in options.entries) {
      final name = entry.key.toNativeUtf8();
      final value = entry.value.toNativeUtf8();
      mpv.mpv_set_option_string(
        handle,
        name.cast(),
        value.cast(),
      );
      calloc.free(name);
      calloc.free(value);
    }

    // Initializing [mpv_handle].
    mpv.mpv_initialize(handle);

    // Sending the address of the created [mpv_handle] & the [SendPort] of the [receivePort].
    // Raw address is sent as [int] since we cannot transfer objects through Native Ports, only primatives.
    port.send(handle.address);

    // Lookup for events & send to main thread through [SendPort].
    // Ensuring the successful sending of the last event before moving to next [MPV.mpv_wait_event].
    while (true) {
      completer = Completer();
      final event = mpv.mpv_wait_event(handle, kReleaseMode ? -1 : 0.1);

      if (disposed) {
        break;
      }

      if (event.ref.event_id != mpv_event_id.MPV_EVENT_NONE) {
        // Sending raw address of [mpv_event].
        port.send(event.address);
        // Ensuring that the last [mpv_event] (which is at the same address) is NOT reset to [mpv_event_id.MPV_EVENT_NONE] after next [MPV.mpv_wait_event] in the loop.
        await completer.future;
      }
    }
  }

  /// Associated [SendPort] of the [Pointer<mpv_handle>], if events are enabled.
  static final _ports = HashMap<int, SendPort>();

  /// Associated [Isolate] of the [Pointer<mpv_handle>], if events are enabled.
  static final _isolates = HashMap<int, Isolate>();
}
