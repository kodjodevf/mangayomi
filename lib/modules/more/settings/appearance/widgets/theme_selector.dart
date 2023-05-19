import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';

class ThemeSelector extends ConsumerStatefulWidget {
  const ThemeSelector({
    super.key,
    this.contentPadding,
  });
  final EdgeInsetsGeometry? contentPadding;

  @override
  ConsumerState<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends ConsumerState<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    int selected = isar.settings.getSync(227)!.flexSchemeColorIndex!;
    const double height = 45;
    const double width = height * 1.5;
    final ThemeData theme = Theme.of(context);
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 130,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: ThemeAA.schemes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          FlexThemeModeOptionButton(
                            flexSchemeColor: isLight
                                ? ThemeAA.schemes[index].light
                                : ThemeAA.schemes[index].dark,
                            selected: selected == index,
                            selectedBorder: BorderSide(
                              color: theme.primaryColorLight,
                              width: 4,
                            ),
                            unselectedBorder: BorderSide.none,
                            backgroundColor: scheme.background,
                            width: width,
                            height: height,
                            padding: EdgeInsets.zero,
                            borderRadius: 0,
                            onSelect: () {
                              setState(() {
                                selected = index;
                              });
                              isLight
                                  ? ref
                                      .read(
                                          flexSchemeColorStateProvider.notifier)
                                      .setTheme(ThemeAA.schemes[selected].light,
                                          selected)
                                  : ref
                                      .read(
                                          flexSchemeColorStateProvider.notifier)
                                      .setTheme(ThemeAA.schemes[selected].dark,
                                          selected);
                            },
                            optionButtonPadding: EdgeInsets.zero,
                            optionButtonMargin: EdgeInsets.zero,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            ThemeAA.schemes[index].name,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      if (selected == index)
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircleAvatar(
                              radius: 14,
                              backgroundColor: theme.primaryColorLight,
                              child: Icon(
                                FontAwesomeIcons.check,
                                color: secondaryColor(context),
                                size: 16,
                              )),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
