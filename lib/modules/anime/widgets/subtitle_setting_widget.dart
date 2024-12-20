import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class FontSettingWidget extends ConsumerStatefulWidget {
  final bool hasSubtitleTrack;
  const FontSettingWidget({super.key, required this.hasSubtitleTrack});

  @override
  ConsumerState<FontSettingWidget> createState() => _FontSettingWidgetState();
}

class _FontSettingWidgetState extends ConsumerState<FontSettingWidget> {
  @override
  Widget build(BuildContext context) {
    final subtitleSettings = ref.watch(subtitleSettingsStateProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!widget.hasSubtitleTrack)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.info_outline_rounded, size: 14),
                  ),
                  Flexible(
                    child: Text(context.l10n.no_subtite_warning_message),
                  )
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconButton(Icons.remove, () {
                ref.read(subtitleSettingsStateProvider.notifier).set(
                    subtitleSettings..fontSize = subtitleSettings.fontSize! - 1,
                    true);
                setState(() {});
              },
                  backgroundColor: context.dynamicWhiteBlackColor,
                  iconColors: context.isLight ? Colors.white : Colors.black,
                  size: 25),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: TextEditingController(
                      text: subtitleSettings.fontSize.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final val = int.tryParse(v);
                    if (val != null) {
                      ref
                          .read(subtitleSettingsStateProvider.notifier)
                          .set(subtitleSettings..fontSize = val, true);
                    }
                  },
                  decoration: InputDecoration(
                      labelText: context.l10n.font_size,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: context.dynamicThemeColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: context.dynamicThemeColor)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: context.dynamicThemeColor))),
                ),
              ),
              iconButton(Icons.add, () {
                ref.read(subtitleSettingsStateProvider.notifier).set(
                    subtitleSettings..fontSize = subtitleSettings.fontSize! + 1,
                    true);
                setState(() {});
              },
                  backgroundColor: context.dynamicWhiteBlackColor,
                  iconColors: context.isLight ? Colors.white : Colors.black,
                  size: 25),
              iconButton(Icons.format_bold, () {
                ref.read(subtitleSettingsStateProvider.notifier).set(
                    subtitleSettings..useBold = !subtitleSettings.useBold!,
                    true);
                setState(() {});
              },
                  iconColors: subtitleSettings.useBold!
                      ? null
                      : context.dynamicWhiteBlackColor.withValues(alpha: 0.5)),
              iconButton(Icons.format_italic, () {
                ref.read(subtitleSettingsStateProvider.notifier).set(
                    subtitleSettings..useItalic = !subtitleSettings.useItalic!,
                    true);
                setState(() {});
              },
                  iconColors: subtitleSettings.useItalic!
                      ? null
                      : context.dynamicWhiteBlackColor.withValues(alpha: 0.5)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Lorem ipsum dolor sit amet",
                style: subtileTextStyle(ref).copyWith(fontSize: 22),
                textAlign: TextAlign.center),
          ),
          TextButton(
              onPressed: () {
                ref.read(subtitleSettingsStateProvider.notifier).set(
                    subtitleSettings
                      ..useItalic = false
                      ..useBold = false
                      ..fontSize = 45,
                    true);
                setState(() {});
              },
              child: Text(context.l10n.reset))
        ],
      ),
    );
  }
}

class ColorSettingWidget extends ConsumerStatefulWidget {
  final bool hasSubtitleTrack;
  const ColorSettingWidget({super.key, required this.hasSubtitleTrack});

  @override
  ConsumerState<ColorSettingWidget> createState() => _ColorSettingWidgetState();
}

class _ColorSettingWidgetState extends ConsumerState<ColorSettingWidget> {
  String selector = "text";

  Widget button(String text, String value, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          shadowColor: Colors.transparent),
      onPressed: () {
        setState(() {
          selector = value;
        });
      },
      child: Column(
        children: [
          Text(text, style: TextStyle(color: context.textColor)),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color,
                  border: Border.all(
                      width: 2, color: context.dynamicWhiteBlackColor)),
            ),
          ),
          Text("#${color.hexCode}", style: TextStyle(color: context.textColor)),
          Icon(
            Icons.arrow_drop_down,
            color: selector != value ? Colors.transparent : context.textColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subSets = ref.watch(subtitleSettingsStateProvider);
    final textColor = Color.fromARGB(subSets.textColorA!, subSets.textColorR!,
        subSets.textColorG!, subSets.textColorB!);
    final borderColor = Color.fromARGB(subSets.borderColorA!,
        subSets.borderColorR!, subSets.borderColorG!, subSets.borderColorB!);
    final backgroundColor = Color.fromARGB(
        subSets.backgroundColorA!,
        subSets.backgroundColorR!,
        subSets.backgroundColorG!,
        subSets.backgroundColorB!);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!widget.hasSubtitleTrack)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.info_outline_rounded, size: 14),
                  ),
                  Flexible(
                    child: Text(context.l10n.no_subtite_warning_message),
                  )
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                  flex: 3, child: button(context.l10n.text, "text", textColor)),
              Expanded(
                  flex: 3,
                  child: button(context.l10n.border, "border", borderColor)),
              Expanded(
                  flex: 3,
                  child: button(
                      context.l10n.background, "backgroud", backgroundColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Lorem ipsum dolor sit amet",
                style: subtileTextStyle(ref).copyWith(fontSize: 22),
                textAlign: TextAlign.center),
          ),
          if (selector == "text") ...[
            rgbaFilterWidget(subSets.textColorA!, subSets.textColorR!,
                subSets.textColorG!, subSets.textColorB!, (val) {
              if (val.$3 == "r") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..textColorR = val.$1.toInt(), val.$2);
              } else if (val.$3 == "g") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..textColorG = val.$1.toInt(), val.$2);
              } else if (val.$3 == "b") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..textColorB = val.$1.toInt(), val.$2);
              } else {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..textColorA = val.$1.toInt(), val.$2);
              }
              setState(() {});
            }, context),
          ] else if (selector == "border") ...[
            rgbaFilterWidget(subSets.borderColorA!, subSets.borderColorR!,
                subSets.borderColorG!, subSets.borderColorB!, (val) {
              if (val.$3 == "r") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..borderColorR = val.$1.toInt(), val.$2);
              } else if (val.$3 == "g") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..borderColorG = val.$1.toInt(), val.$2);
              } else if (val.$3 == "b") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..borderColorB = val.$1.toInt(), val.$2);
              } else {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..borderColorA = val.$1.toInt(), val.$2);
              }
              setState(() {});
            }, context),
          ] else ...[
            rgbaFilterWidget(
                subSets.backgroundColorA!,
                subSets.backgroundColorR!,
                subSets.backgroundColorG!,
                subSets.backgroundColorB!, (val) {
              if (val.$3 == "r") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..backgroundColorR = val.$1.toInt(), val.$2);
              } else if (val.$3 == "g") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..backgroundColorG = val.$1.toInt(), val.$2);
              } else if (val.$3 == "b") {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..backgroundColorB = val.$1.toInt(), val.$2);
              } else {
                ref
                    .read(subtitleSettingsStateProvider.notifier)
                    .set(subSets..backgroundColorA = val.$1.toInt(), val.$2);
              }
              setState(() {});
            }, context),
          ],
          TextButton(
              onPressed: () {
                ref.read(subtitleSettingsStateProvider.notifier).resetColor();
                setState(() {});
              },
              child: Text(context.l10n.reset))
        ],
      ),
    );
  }
}

Widget iconButton(IconData icon, void Function()? onPressed,
        {Color? backgroundColor, Color? iconColors, double size = 35}) =>
    Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: size,
        width: size,
        child: IconButton(
            iconSize: size * 0.9,
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(backgroundColor)),
            padding: const EdgeInsets.all(1),
            onPressed: onPressed,
            icon: Icon(icon, color: iconColors)),
      ),
    );
