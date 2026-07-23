import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ThemeSelector extends ConsumerStatefulWidget {
  const ThemeSelector({super.key, this.contentPadding});
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
            child: SuperListView.builder(
              padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: ThemeAA.schemes.length,
              itemBuilder: (BuildContext context, int index) {
                void select() {
                  setState(() => selected = index);
                  isLight
                      ? ref
                            .read(flexSchemeColorStateProvider.notifier)
                            .setTheme(ThemeAA.schemes[index].light, index)
                      : ref
                            .read(flexSchemeColorStateProvider.notifier)
                            .setTheme(ThemeAA.schemes[index].dark, index);
                }

                return _TvSwatchFocus(
                  onSelect: select,
                  child: Padding(
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
                              backgroundColor: scheme.surface,
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
                                            flexSchemeColorStateProvider
                                                .notifier,
                                          )
                                          .setTheme(
                                            ThemeAA.schemes[selected].light,
                                            selected,
                                          )
                                    : ref
                                          .read(
                                            flexSchemeColorStateProvider
                                                .notifier,
                                          )
                                          .setTheme(
                                            ThemeAA.schemes[selected].dark,
                                            selected,
                                          );
                              },
                              optionButtonPadding: EdgeInsets.zero,
                              optionButtonMargin: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              ThemeAA.schemes[index].name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        if (selected == index)
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: theme.primaryColorLight,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: context.secondaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
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

/// Wraps a theme swatch so a remote can focus it: an accent ring on focus and
/// select on OK. Off-TV it is a transparent pass-through.
class _TvSwatchFocus extends StatefulWidget {
  const _TvSwatchFocus({required this.child, required this.onSelect});
  final Widget child;
  final VoidCallback onSelect;

  @override
  State<_TvSwatchFocus> createState() => _TvSwatchFocusState();
}

class _TvSwatchFocusState extends State<_TvSwatchFocus> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    if (!isTv) return widget.child;
    return Focus(
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 200),
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                event.logicalKey == LogicalKeyboardKey.gameButtonA ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _focused ? context.primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
