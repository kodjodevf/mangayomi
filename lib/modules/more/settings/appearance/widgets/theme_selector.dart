import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
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
    final selected = ref.watch(
      flexSchemeColorStateProvider.select((t) => t.$2),
    );
    const double height = 45;
    const double width = height * 1.5;
    final ThemeData theme = Theme.of(context);
    final isDark = ref.watch(themeModeStateProvider);
    return SizedBox(
      height: 130,
      child: Row(
        children: [
          Expanded(
            child: SuperListView.builder(
              padding: const EdgeInsetsDirectional.only(
                start: ShioriSpace.s8,
                end: ShioriSpace.s16,
              ),
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: ThemeAA.schemes.length,
              itemBuilder: (BuildContext context, int index) {
                final scheme = ThemeAA.schemes[index];
                final color = isDark ? scheme.dark : scheme.light;

                return _TvSwatchFocus(
                  onSelect: () {
                    ref
                        .read(flexSchemeColorStateProvider.notifier)
                        .setTheme(color, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(ShioriSpace.s8),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            FlexThemeModeOptionButton(
                              flexSchemeColor: color,
                              selected: selected == index,
                              selectedBorder: BorderSide(
                                color: context.shiori.color.accent,
                                width: 4,
                              ),
                              unselectedBorder: BorderSide.none,
                              backgroundColor: theme.colorScheme.surface,
                              width: width,
                              height: height,
                              padding: EdgeInsets.zero,
                              borderRadius: 0,
                              onSelect: () {
                                ref
                                    .read(flexSchemeColorStateProvider.notifier)
                                    .setTheme(color, index);
                              },
                              optionButtonPadding: EdgeInsets.zero,
                              optionButtonMargin: EdgeInsets.zero,
                            ),
                            const SizedBox(height: ShioriSpace.s4),
                            Text(
                              ThemeAA.schemes[index].name,
                              style: TextStyle(
                                fontSize: context.shiori.text.meta.fontSize,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        if (selected == index)
                          Padding(
                            padding: const EdgeInsets.all(ShioriSpace.s4),
                            // The picked palette's check, in the accent,
                            // as the app marks a choice.
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: context.shiori.color.accent,
                              child: Icon(
                                Symbols.check_rounded,
                                color: context.shiori.color.onAccent,
                                size: 18,
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
            duration: ShioriMotion.standard,
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
        duration: ShioriMotion.fast,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ShioriShape.cover),
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
