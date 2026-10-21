import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/mpv_subtitle_options.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit/media_kit.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shiori/shiori.dart';

/// Encapsulates libmpv property observation, Aniyomi/Mangayomi Lua script IPC,
/// custom button script generation, and subtitle property synchronization.
mixin AnimeMpvBridgeMixin<T extends riv.ConsumerStatefulWidget>
    on riv.ConsumerState<T> {
  Player get mpvBridgePlayer;
  bool get mpvUseLibass;
  bool get mpvUseMpvConfig;
  AnimeStreamController get mpvStreamController;
  ValueNotifier<ActiveCustomButton?> get mpvCustomButton;
  ValueNotifier<List<CustomButton>?> get mpvCustomButtons;
  ValueNotifier<List<(String, int)>> get mpvChapterMarks;
  ValueNotifier<int?> get mpvCurrentChapterMark;
  ValueNotifier<String> get mpvSelectedShader;
  TextEditingController get mpvSubDelayController;
  TextEditingController get mpvSubSpeedController;

  Future<void> mpvSeekTo(int absoluteSeconds);
  Future<void> mpvSeekBy(int deltaSeconds);
  Future<void> mpvPushToNewEpisode(BuildContext context, Chapter episode);

  void applySubtitleSettingsToMpv(PlayerSubtitleSettings settings) {
    if (!mpvUseLibass) return;
    try {
      final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
      for (final MapEntry(:key, :value) in mpvSubtitleStyle(settings).entries) {
        nativePlayer.setProperty(key, value);
      }
    } catch (_) {}
  }

  Future<void> handleMpvEvents(Pointer<generated.mpv_event> event) async {
    try {
      if (event.ref.event_id ==
          generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE) {
        final prop = event.ref.data.cast<generated.mpv_event_property>();
        final propName = prop.ref.name.cast<Utf8>().toDartString();
        if (kDebugMode) {
          if (propName.startsWith("user-data/")) {
            print("DEBUG 00: $propName - ${prop.ref.format}");
          }
        }
        if (propName.startsWith("user-data/") &&
            prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
          final value = prop.ref.data.cast<generated.mpv_node>();
          await _handleMpvNodeEvents(propName, value);
        } else if (propName.startsWith("user-data/") &&
            prop.ref.format == generated.mpv_format.MPV_FORMAT_INT64) {
          final value = prop.ref.data.cast<Int64>().value;
          await _handleMpvNumberEvents(propName, value);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  String? _readMpvString(Pointer<generated.mpv_node> value) {
    if (value.ref.format != generated.mpv_format.MPV_FORMAT_STRING) return null;
    final text = value.ref.u.string.cast<Utf8>().toDartString();
    return text.isEmpty ? null : text;
  }

  Future<void> _handleMpvNodeEvents(
    String propName,
    Pointer<generated.mpv_node> value,
  ) async {
    final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
    switch (propName.substring(10)) {
      case "aniyomi/show_text":
        final text = _readMpvString(value);
        if (text == null) break;
        botToast(
          text,
          alignY: -0.99,
          second: 2,
          dismissDirections: const [
            DismissDirection.vertical,
            DismissDirection.horizontal,
          ],
          showIcon: false,
        );
        nativePlayer.setProperty("user-data/aniyomi/show_text", "");
        break;
      case "aniyomi/toggle_ui":
        final text = _readMpvString(value);
        if (text == null) break;
        nativePlayer.setProperty("user-data/aniyomi/toggle_ui", "");
        break;
      case "aniyomi/show_panel":
        final text = _readMpvString(value);
        if (text == null) break;
        nativePlayer.setProperty("user-data/aniyomi/show_panel", "");
        break;
      case "aniyomi/software_keyboard":
        final text = _readMpvString(value);
        if (text == null) break;
        nativePlayer.setProperty("user-data/aniyomi/software_keyboard", "");
        break;
      case "aniyomi/set_button_title":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = mpvCustomButton.value;
        if (temp == null) break;
        mpvCustomButton.value = temp..currentTitle = text;
        nativePlayer.setProperty("user-data/aniyomi/set_button_title", "");
        break;
      case "aniyomi/reset_button_title":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = mpvCustomButton.value;
        if (temp == null) break;
        mpvCustomButton.value = temp..currentTitle = temp.button.title ?? "";
        nativePlayer.setProperty("user-data/aniyomi/reset_button_title", "");
        break;
      case "aniyomi/toggle_button":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = mpvCustomButton.value;
        if (temp == null) break;
        switch (text) {
          case "show":
            mpvCustomButton.value = temp..visible = true;
            break;
          case "hide":
            mpvCustomButton.value = temp..visible = false;
            break;
          case "toggle":
            mpvCustomButton.value = temp..visible = !temp.visible;
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/toggle_button", "");
        break;
      case "aniyomi/switch_episode":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          case "n":
            await mpvPushToNewEpisode(
              context,
              mpvStreamController.getNextEpisode(),
            );
            break;
          case "p":
            await mpvPushToNewEpisode(
              context,
              mpvStreamController.getPrevEpisode(),
            );
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/switch_episode", "");
        break;
      case "aniyomi/pause":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          case "pause":
            await mpvBridgePlayer.pause();
            break;
          case "unpause":
            await mpvBridgePlayer.play();
            break;
          case "pauseunpause":
            await mpvBridgePlayer.playOrPause();
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/pause", "");
        break;
      case "aniyomi/seek_by":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = int.parse(text.replaceAll("\"", ""));
        await mpvSeekBy(data);
        nativePlayer.setProperty("user-data/aniyomi/seek_by", "");
        break;
      case "aniyomi/seek_to":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = int.parse(text.replaceAll("\"", ""));
        await mpvSeekTo(data);
        nativePlayer.setProperty("user-data/aniyomi/seek_to", "");
        break;
      case "aniyomi/seek_by_with_text":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        await mpvSeekBy(int.parse(data[0].replaceAll("\"", "")));
        nativePlayer.command(["show-text", data[1]]);
        nativePlayer.setProperty("user-data/aniyomi/seek_by_with_text", "");
        break;
      case "aniyomi/seek_to_with_text":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        await mpvSeekTo(int.parse(data[0].replaceAll("\"", "")));
        nativePlayer.command(["show-text", data[1]]);
        nativePlayer.setProperty("user-data/aniyomi/seek_to_with_text", "");
        break;
      case "aniyomi/launch_int_picker":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        final start = int.parse(data[2]);
        final stop = int.parse(data[3]);
        final step = int.parse(data[4]);
        int currentValue = start;
        await showDialog(
          context: context,
          builder: (context) {
            return ShioriDialog(
              title: data[0],
              content: StatefulBuilder(
                builder: (context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NumberPicker(
                      value: currentValue,
                      minValue: start,
                      maxValue: stop,
                      step: step,
                      haptics: true,
                      textMapper: (numberText) =>
                          data[1].replaceAll("%d", numberText),
                      onChanged: (value) =>
                          setState(() => currentValue = value),
                    ),
                  ],
                ),
              ),
              actions: [
                ShioriButton.quiet(
                  label: context.l10n.cancel,
                  onPressed: () => Navigator.pop(context),
                ),
                ShioriButton(
                  label: context.l10n.ok,
                  onPressed: () async {
                    final namePtr = data[5].toNativeUtf8();
                    final valuePtr = calloc<Int64>(1)..value = currentValue;
                    nativePlayer.mpv.mpv_set_property(
                      nativePlayer.ctx,
                      namePtr.cast(),
                      generated.mpv_format.MPV_FORMAT_INT64,
                      valuePtr.cast(),
                    );
                    malloc.free(namePtr);
                    malloc.free(valuePtr);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        nativePlayer.setProperty("user-data/aniyomi/launch_int_picker", "");
        break;
      case "mangayomi/chapter_titles":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          final data = jsonDecode(text) as List<dynamic>;
          mpvChapterMarks.value = data
              .map(
                (e) => (
                  e["title"] as String,
                  e["timestamp"] is double
                      ? (e["timestamp"] as double).toInt() * 1000
                      : (e["timestamp"] as int) * 1000,
                ),
              )
              .toList();
        }
        break;
      case "mangayomi/selected_shader":
        final text = _readMpvString(value);
        mpvSelectedShader.value = text ?? '';
        break;
    }
  }

  Future<void> _handleMpvNumberEvents(String propName, int value) async {
    switch (propName.substring(10)) {
      case "mangayomi/current_chapter":
        mpvCurrentChapterMark.value = max(value, 0);
        break;
    }
  }

  Future<void> initCustomButton() async {
    if (!mpvUseMpvConfig) return;
    final customButtons = customButtonRepository.getAllSortedByPos();
    if (customButtons.isEmpty) return;
    final primaryButton =
        customButtons.firstWhereOrNull((e) => e.isFavourite ?? false) ??
        customButtons.first;
    final provider = StorageProvider();
    if (!(await provider.requestPermission())) {
      return;
    }
    final dir = await provider.getMpvDirectory();
    String scriptsDir = path.join(dir!.path, 'scripts');
    final mpvFile = File('$scriptsDir/init_custom_buttons.lua');
    final content = StringBuffer();
    content.writeln("""local lua_modules = mp.find_config_file('scripts')
if lua_modules then
  package.path = package.path .. ';' .. lua_modules .. '/?.lua;' .. lua_modules .. '/?/init.lua;' .. '\${scriptsDir()!!.filePath}' .. '/?.lua'
end
local aniyomi = require 'init_aniyomi_functions'""");
    for (final button in customButtons) {
      content.writeln(
        """
${button.getButtonStartup(primaryButton.id!).trim()}
function button${button.id}()
  ${button.getButtonPress(primaryButton.id!).trim()}
end
mp.register_script_message('call_button_${button.id}', button${button.id})
function button${button.id}long()
  ${button.getButtonLongPress(primaryButton.id!).trim()}
end
mp.register_script_message('call_button_${button.id}_long', button${button.id}long)""",
      );
    }
    await mpvFile.writeAsString(content.toString());
    final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
    await nativePlayer.command(["load-script", mpvFile.path]);
    mpvCustomButton.value = ActiveCustomButton(
      currentTitle: primaryButton.title!,
      visible: true,
      button: primaryButton,
      onPress: () => nativePlayer.command([
        "script-message",
        "call_button_${primaryButton.id}",
      ]),
      onLongPress: () => nativePlayer.command([
        "script-message",
        "call_button_${primaryButton.id}_long",
      ]),
    );
    mpvCustomButtons.value = customButtons;
  }

  void onSubDelayChanged() {
    final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
    final delayMs = int.tryParse(mpvSubDelayController.text);
    if (delayMs != null) {
      final namePtr = "sub-delay".toNativeUtf8();
      final valuePtr = calloc<Double>(1)..value = delayMs / 1000;
      nativePlayer.mpv.mpv_set_property(
        nativePlayer.ctx,
        namePtr.cast(),
        generated.mpv_format.MPV_FORMAT_DOUBLE,
        valuePtr.cast(),
      );
      malloc.free(namePtr);
      malloc.free(valuePtr);
    }
  }

  void onSubSpeedChanged() {
    final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
    final speed = double.tryParse(mpvSubSpeedController.text);
    if (speed != null) {
      final namePtr = "sub-speed".toNativeUtf8();
      final valuePtr = calloc<Double>(1)
        ..value = speed < 0.1
            ? 0.1
            : speed > 10
            ? 10
            : speed;
      nativePlayer.mpv.mpv_set_property(
        nativePlayer.ctx,
        namePtr.cast(),
        generated.mpv_format.MPV_FORMAT_DOUBLE,
        valuePtr.cast(),
      );
      malloc.free(namePtr);
      malloc.free(valuePtr);
    }
  }

  Future<void> loadAndroidFont() async {
    if (Platform.isAndroid && mpvUseLibass) {
      try {
        final subDir = await getApplicationDocumentsDirectory();
        final fontPath = path.join(subDir.path, 'subfont.ttf');
        final data = await rootBundle.load('assets/fonts/subfont.ttf');
        final bytes = data.buffer.asInt8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        final fontFile = await File(fontPath).create(recursive: true);
        await fontFile.writeAsBytes(bytes);
        final nativePlayer = mpvBridgePlayer.platform as NativePlayer;
        await nativePlayer.setProperty('sub-fonts-dir', subDir.path);
        await nativePlayer.setProperty('sub-font', 'Droid Sans Fallback');
      } catch (_) {}
    }
  }
}
