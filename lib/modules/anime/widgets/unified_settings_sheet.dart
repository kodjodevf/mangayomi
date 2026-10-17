import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// One selectable row inside a [UnifiedSettingsSheet] section: a label, an
/// optional trailing hint (codec, keyboard shortcut...) and a filled
/// checkmark when selected. This is the single selection language shared by
/// every section — quality, audio, subtitles, chapters, speed, shaders — in
/// place of the mix of italic text, bold text and unmarked popup menu items
/// each used to invent on its own.
class SettingsOptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final String? hint;
  final VoidCallback onTap;

  const SettingsOptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    // The app's own choice row (ShioriChoice): the label in bold and a check
    // at the end when picked, at the density's row height. The check's room
    // is kept when it is not there, so labels and hints do not shift.
    final tokens = context.shiori;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: tokens.density.rowHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
            child: Row(
              spacing: ShioriSpace.s12,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: tokens.text.row.copyWith(
                      color: tokens.color.fg,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hint != null)
                  Text(
                    hint!,
                    style: tokens.caption.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                SizedBox.square(
                  dimension: 24,
                  child: selected
                      ? Icon(
                          Symbols.check_rounded,
                          color: tokens.color.accentInk,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A non-selectable action row ("Load your own subtitles...",
/// "Search subtitles online...") — same density as [SettingsOptionRow], but a
/// leading icon and a chevron instead of a checkmark, so it doesn't read as a
/// dead/never-selected option.
class SettingsActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.shiori.density.rowHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: context.shiori.scaled(24),
                  color: context.shiori.color.fgMuted,
                ),
                const SizedBox(width: ShioriSpace.s16),
                Expanded(
                  child: Text(
                    label,
                    style: context.shiori.text.row.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                ),
                Icon(
                  Symbols.chevron_right_rounded,
                  fill: 1,
                  size: 18,
                  color: context.shiori.color.fgMuted.withValues(alpha: 0.70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A group label ("QUALITY", "RENDERING"...) inside a section body: the
/// app's one group label.
class SettingsSectionLabel extends StatelessWidget {
  final String text;
  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s12,
        ShioriSpace.s16,
        ShioriSpace.s8,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ShioriGroupLabel(text),
      ),
    );
  }
}

/// A "-"/"+" stepper row (subtitle delay, subtitle speed...) supporting optional manual text editing.
class SettingsStepperRow extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final String? suffix;
  final TextInputType? keyboardType;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SettingsStepperRow({
    super.key,
    required this.label,
    this.value,
    this.controller,
    this.suffix,
    this.keyboardType,
    required this.onDecrement,
    required this.onIncrement,
    this.onChanged,
    this.onSubmitted,
  }) : assert(
         value != null || controller != null,
         'Must provide value or controller',
       );

  @override
  Widget build(BuildContext context) {
    final onSurface = context.shiori.color.fg;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.shiori.text.row.copyWith(
                color: context.shiori.color.fgMuted,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.shiori.color.ink3.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(ShioriShape.cover),
              border: Border.all(
                color: context.shiori.color.hairline.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Symbols.remove_rounded,
                  onTap: onDecrement,
                ),
                if (controller != null)
                  SizedBox(
                    width: 78,
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      textAlign: TextAlign.center,
                      cursorHeight: 14,
                      style: context.shiori.text.meta.copyWith(
                        color: onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: ShioriSpace.s8,
                          horizontal: ShioriSpace.s4,
                        ),
                        border: InputBorder.none,
                        suffixText: suffix,
                        suffixStyle: context.shiori.text.badge.copyWith(
                          color: context.shiori.color.fgMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  )
                else
                  SizedBox(
                    width: 64,
                    child: Text(
                      value ?? '',
                      textAlign: TextAlign.center,
                      style: context.shiori.text.meta.copyWith(
                        color: onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                _StepperButton(icon: Symbols.add_rounded, onTap: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: context.shiori.color.fg),
        ),
      ),
    );
  }
}

/// A small persistent pill for the bottom rail (current speed, current fit
/// mode...) so the value stays glanceable without opening a menu — replacing
/// icons that either cycled silently or only surfaced their value in a toast.
class PlayerPillButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final GestureLongPressCallback? onLongPress;
  final String? tooltip;
  final bool active;
  final bool isCompact;
  final bool showLabel;

  const PlayerPillButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.icon,
    this.label,
    this.tooltip,
    this.active = false,
    this.isCompact = false,
    this.showLabel = true,
  }) : assert(
         icon != null || (showLabel && label != null),
         'Must provide a visible icon or label',
       );

  @override
  Widget build(BuildContext context) {
    // Over the video, so on the scrim whatever the theme (a theme surface
    // turned the pill light under its white label in the light theme); on,
    // it is filled with the accent and labelled to be read on it.
    final tokens = context.shiori;
    final bgColor = active ? tokens.color.accent : ShioriScrim.underText;
    final fgColor = active ? tokens.color.onAccent : Colors.white;
    final visibleLabel = showLabel ? label : null;

    final padH = isCompact ? 8.0 : 10.0;
    final padV = isCompact ? 4.5 : 6.0;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ShioriShape.cover),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isCompact ? 14 : 15, color: fgColor),
                if (visibleLabel != null) SizedBox(width: isCompact ? 4 : 6),
              ],
              if (visibleLabel != null)
                Text(
                  visibleLabel,
                  style: context.shiori.text.meta.copyWith(
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                    fontSize: isCompact ? 11 : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    // The pill stays small over the video, but takes a tap anywhere in a
    // target of the density's size around it.
    final target = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: tokens.density.minTarget),
        child: Center(widthFactor: 1, heightFactor: 1, child: button),
      ),
    );
    final accessibleButton = !showLabel && label != null
        ? Semantics(value: label, child: target)
        : target;
    return tooltip != null
        ? Tooltip(message: tooltip!, child: accessibleButton)
        : accessibleButton;
  }
}

typedef SettingsSectionBuilder = Widget Function(BuildContext context);

/// One entry in the settings home list ("Qualité", "Vitesse"...): an icon, a
/// label, an optional live current-value widget shown to the right of it
/// (e.g. "1.0×"), and either drill-down content or a direct action.
class SettingsEntry {
  final String label;
  final IconData icon;
  final WidgetBuilder? valueBuilder;
  final SettingsSectionBuilder? contentBuilder;
  final ValueChanged<BuildContext>? onTap;

  const SettingsEntry({
    required this.label,
    required this.icon,
    this.contentBuilder,
    this.onTap,
    this.valueBuilder,
  }) : assert(
         (contentBuilder == null) != (onTap == null),
         'Provide either contentBuilder or onTap',
       );
}

class _SettingsHomeRow extends StatelessWidget {
  final SettingsEntry entry;
  final VoidCallback onTap;
  const _SettingsHomeRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final onSurface = context.shiori.color.fg;
    final maxLabelWidth = (MediaQuery.sizeOf(context).width * 0.45).clamp(
      120.0,
      180.0,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        // As the app's setting rows: the icon muted at their size, the
        // label at their weight, at the density's row height.
        child: Container(
          constraints: BoxConstraints(
            minHeight: context.shiori.density.rowHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
          child: Row(
            children: [
              Icon(
                entry.icon,
                size: context.shiori.scaled(24),
                color: context.shiori.color.fgMuted,
              ),
              const SizedBox(width: ShioriSpace.s16),
              if (entry.valueBuilder == null)
                Expanded(
                  child: Text(
                    entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.shiori.text.row.copyWith(color: onSurface),
                  ),
                )
              else ...[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxLabelWidth),
                  child: Text(
                    entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.shiori.text.row.copyWith(color: onSurface),
                  ),
                ),
                const SizedBox(width: ShioriSpace.s8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DefaultTextStyle.merge(
                      style: context.shiori.text.meta.copyWith(
                        color: context.shiori.color.fgMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      child: entry.valueBuilder!(context),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: ShioriSpace.s4),
              Icon(
                Symbols.chevron_right_rounded,
                fill: 1,
                size: 18,
                color: context.shiori.color.fgMuted.withValues(alpha: 0.70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fast exit curve: old page fades out cleanly between t = 1.0 and 0.45,
/// ensuring text never overlaps or creates double-exposure artifacts.
class _FastExitFadeCurve extends Curve {
  const _FastExitFadeCurve();

  @override
  double transformInternal(double t) {
    if (t <= 0.45) return 0.0;
    final p = (t - 0.45) / 0.55;
    return Curves.easeInQuad.transform(p);
  }
}

/// Smooth entrance curve: new page begins fading in at t = 0.15 with easeOutCubic
/// to crystallize gracefully as it finishes sliding into place.
class _SmoothEnterFadeCurve extends Curve {
  const _SmoothEnterFadeCurve();

  @override
  double transformInternal(double t) {
    if (t <= 0.15) return 0.0;
    final p = (t - 0.15) / 0.85;
    return Curves.easeOutCubic.transform(p);
  }
}

class _DrilldownHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final bool forward;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const _DrilldownHeader({
    required this.title,
    required this.showBack,
    required this.forward,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = context.shiori.color.fg;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s4,
        ShioriSpace.s4,
        ShioriSpace.s8,
        ShioriSpace.s4,
      ),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: ShioriMotion.enter,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  axis: Axis.horizontal,
                  alignment: Alignment.centerLeft,
                  sizeFactor: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.8,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              },
              child: showBack
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      key: const ValueKey('back-button'),
                      onPressed: onBack,
                      icon: Icon(
                        Symbols.arrow_back_rounded,
                        fill: 1,
                        color: onSurface,
                        size: 20,
                      ),
                      splashRadius: 20,
                      padding: const EdgeInsets.all(ShioriSpace.s12),
                      constraints: BoxConstraints(
                        minWidth: context.shiori.density.minTarget,
                        minHeight: context.shiori.density.minTarget,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('no-back')),
            ),
            // Without the back arrow, the title starts on the rows' edge.
            SizedBox(width: showBack ? ShioriSpace.s4 : ShioriSpace.s12),
            Expanded(
              child: AnimatedSwitcher(
                duration: ShioriMotion.enter,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previousChildren, ?currentChild],
                  );
                },
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == ValueKey(title);
                  final offsetTween = isIncoming
                      ? (forward
                            ? Tween<Offset>(
                                begin: const Offset(0.16, 0.0),
                                end: Offset.zero,
                              )
                            : Tween<Offset>(
                                begin: const Offset(-0.16, 0.0),
                                end: Offset.zero,
                              ))
                      : (forward
                            ? Tween<Offset>(
                                begin: const Offset(-0.16, 0.0),
                                end: Offset.zero,
                              )
                            : Tween<Offset>(
                                begin: const Offset(0.16, 0.0),
                                end: Offset.zero,
                              ));

                  final opacity = isIncoming
                      ? CurvedAnimation(
                          parent: animation,
                          curve: const _SmoothEnterFadeCurve(),
                        )
                      : CurvedAnimation(
                          parent: animation,
                          curve: const _FastExitFadeCurve(),
                          reverseCurve: const _FastExitFadeCurve(),
                        );

                  return SlideTransition(
                    position: offsetTween.animate(animation),
                    child: FadeTransition(opacity: opacity, child: child),
                  );
                },
                child: Text(
                  title,
                  key: ValueKey(title),
                  style: context.shiori.text.section.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: onClose,
              icon: Icon(
                Symbols.close_rounded,
                fill: 1,
                color: onSurface,
                size: 20,
              ),
              splashRadius: 20,
              padding: const EdgeInsets.all(ShioriSpace.s12),
              constraints: BoxConstraints(
                minWidth: context.shiori.density.minTarget,
                minHeight: context.shiori.density.minTarget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An inherited widget that exposes navigation actions for the active
/// [SettingsDrilldown], allowing options inside a section (e.g. playback speed,
/// fit, video track) to navigate back to the settings home list rather than
/// dismissing the whole sheet or popup menu.
class SettingsDrilldownScope extends InheritedWidget {
  final VoidCallback goHome;
  final VoidCallback close;
  final bool isDirectShortcut;

  const SettingsDrilldownScope({
    super.key,
    required this.goHome,
    required this.close,
    this.isDirectShortcut = false,
    required super.child,
  });

  static SettingsDrilldownScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsDrilldownScope>();
  }

  @override
  bool updateShouldNotify(covariant SettingsDrilldownScope oldWidget) =>
      oldWidget.isDirectShortcut != isDirectShortcut;
}

/// Player settings as a single browsable list — YouTube's pattern instead of
/// the segmented tabs this used to be: a home list of entries (quality,
/// audio, subtitles, speed...), each showing its current value; tapping one
/// slides into its content with a back arrow, and picking a value there
/// slides back home automatically. One shared widget, wrapped differently for
/// the mobile bottom sheet and the desktop anchored popup below.
class SettingsDrilldown extends StatefulWidget {
  final String title;
  final List<SettingsEntry> entries;
  final int initialIndex;
  final VoidCallback onClose;

  const SettingsDrilldown({
    super.key,
    required this.title,
    required this.entries,
    required this.onClose,
    this.initialIndex = -1,
  });

  @override
  State<SettingsDrilldown> createState() => _SettingsDrilldownState();
}

class _SettingsDrilldownState extends State<SettingsDrilldown> {
  late int? _active = _clampActive(widget.initialIndex);
  bool _forward = true;

  int? _clampActive(int index) =>
      index >= 0 &&
          index < widget.entries.length &&
          widget.entries[index].contentBuilder != null
      ? index
      : null;

  @override
  void didUpdateWidget(SettingsDrilldown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Not a route on desktop (it's the same popup staying open), so jumping
    // to a different section (the speed pill, the chapter label...) while
    // already open has to move the selection itself.
    if (widget.initialIndex != oldWidget.initialIndex) {
      final next = _clampActive(widget.initialIndex);
      if (next != _active) {
        _forward = next != null;
        _active = next;
      }
    }
  }

  void _goHome() {
    if (_active != null) {
      setState(() {
        _forward = false;
        _active = null;
      });
    }
  }

  void _open(int index) {
    if (_active != index) {
      setState(() {
        _forward = true;
        _active = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _active;
    final isDirectShortcut = widget.initialIndex >= 0;
    final currentKey = active == null
        ? const ValueKey('home')
        : ValueKey('section-$active');

    final screenHeight = MediaQuery.of(context).size.height;
    final maxBodyHeight = screenHeight * 0.72;

    return SettingsDrilldownScope(
      goHome: _goHome,
      close: widget.onClose,
      isDirectShortcut: isDirectShortcut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DrilldownHeader(
            title: active == null ? widget.title : widget.entries[active].label,
            showBack: !isDirectShortcut && active != null,
            forward: _forward,
            onBack: _goHome,
            onClose: widget.onClose,
          ),
          Divider(
            height: 1,
            color: context.shiori.color.hairline.withValues(alpha: 0.15),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: ShioriMotion.enter,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: ShioriMotion.enter,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      ...previousChildren.map(
                        (child) =>
                            Positioned(top: 0, left: 0, right: 0, child: child),
                      ),
                      ?currentChild,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == currentKey;
                  final offsetTween = isIncoming
                      ? (_forward
                            ? Tween<Offset>(
                                begin: const Offset(0.20, 0.0),
                                end: Offset.zero,
                              )
                            : Tween<Offset>(
                                begin: const Offset(-0.20, 0.0),
                                end: Offset.zero,
                              ))
                      : (_forward
                            ? Tween<Offset>(
                                begin: const Offset(-0.20, 0.0),
                                end: Offset.zero,
                              )
                            : Tween<Offset>(
                                begin: const Offset(0.20, 0.0),
                                end: Offset.zero,
                              ));

                  final opacity = isIncoming
                      ? CurvedAnimation(
                          parent: animation,
                          curve: const _SmoothEnterFadeCurve(),
                        )
                      : CurvedAnimation(
                          parent: animation,
                          curve: const _FastExitFadeCurve(),
                          reverseCurve: const _FastExitFadeCurve(),
                        );

                  return SlideTransition(
                    position: offsetTween.animate(animation),
                    child: FadeTransition(opacity: opacity, child: child),
                  );
                },
                child: ConstrainedBox(
                  key: currentKey,
                  constraints: BoxConstraints(maxHeight: maxBodyHeight),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: ShioriSpace.s12),
                    child: active == null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < widget.entries.length; i++)
                                _SettingsHomeRow(
                                  entry: widget.entries[i],
                                  onTap: () {
                                    final action = widget.entries[i].onTap;
                                    if (action != null) {
                                      action(context);
                                    } else {
                                      _open(i);
                                    }
                                  },
                                ),
                              const SizedBox(height: ShioriSpace.s4),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              bottom: ShioriSpace.s8,
                            ),
                            child: widget.entries[active].contentBuilder!(
                              context,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The mobile chrome around [SettingsDrilldown]: a modal bottom sheet with a
/// drag handle and rounded top corners.
class UnifiedSettingsSheet extends StatelessWidget {
  final String title;
  final List<SettingsEntry> entries;
  final int initialIndex;

  const UnifiedSettingsSheet({
    super.key,
    required this.title,
    required this.entries,
    this.initialIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: context.shiori.color.ink1,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ShioriShape.sheet),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: ShioriSpace.s12),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: context.shiori.color.fgMuted.withValues(alpha: 0.40),
                  borderRadius: BorderRadius.circular(ShioriShape.pill),
                ),
              ),
              const SizedBox(height: ShioriSpace.s8),
              SettingsDrilldown(
                title: title,
                entries: entries,
                initialIndex: initialIndex,
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the mobile settings bottom sheet.
Future<T?> showUnifiedPlayerSettings<T>(
  BuildContext context, {
  required String title,
  required List<SettingsEntry> entries,
  int initialIndex = -1,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => UnifiedSettingsSheet(
      title: title,
      entries: entries,
      initialIndex: initialIndex,
    ),
  );
}

/// Opens the desktop settings menu as a small popup anchored to [anchor]
/// (the gear icon, the speed pill...) — matching YouTube desktop's own
/// settings gear, rather than a sheet or a docked panel. It grows from the
/// anchor with the platform's usual popup-menu animation and dismisses on an
/// outside click or Escape, same as any other popup menu.
Future<void> showDesktopPlayerSettingsMenu(
  BuildContext anchor, {
  required String title,
  required List<SettingsEntry> entries,
  int initialIndex = -1,
}) {
  final navigator = Navigator.of(anchor);
  final overlay = navigator.overlay!.context.findRenderObject() as RenderBox;
  final renderObject = anchor.findRenderObject();
  final button = renderObject is RenderBox ? renderObject : null;

  // Anchored to the button's own rect — showMenu grows the popup from it,
  // flipping above when (as here, a bottom control bar) there's no room
  // below, exactly like YouTube's gear menu growing upward from the bar.
  final RelativeRect position;
  if (button != null &&
      button.attached &&
      button.hasSize &&
      button.size != overlay.size) {
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  } else {
    // Fallback if anchor is the full screen or unmeasured: anchor to bottom-right corner
    final right = 16.0;
    final bottom = 64.0;
    position = RelativeRect.fromLTRB(
      overlay.size.width - right - 40,
      overlay.size.height - bottom - 40,
      right,
      bottom,
    );
  }
  return showMenu<void>(
    context: anchor,
    position: position,
    color: anchor.shiori.color.ink2,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ShioriShape.card),
    ),
    menuPadding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 360),
    items: [
      PopupMenuItem<void>(
        enabled: false,
        padding: EdgeInsets.zero,
        child: Builder(
          builder: (menuContext) => SettingsDrilldown(
            title: title,
            entries: entries,
            initialIndex: initialIndex,
            onClose: () {
              if (menuContext.mounted) {
                Navigator.of(menuContext).pop();
              } else if (navigator.mounted) {
                navigator.pop();
              }
            },
          ),
        ),
      ),
    ],
  );
}
