import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final accent = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.45)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? accent : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? accent
                        : colorScheme.outline.withValues(alpha: 0.50),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check, size: 13, color: colorScheme.onPrimary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: selected ? accent : onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hint != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    hint!,
                    style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
            ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Uppercase, muted group label ("QUALITÉ", "RENDU"...) inside a section body.
class SettingsSectionLabel extends StatelessWidget {
  final String text;
  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      child: Text(
        text.toUpperCase(),
        style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
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
  }) : assert(value != null || controller != null, 'Must provide value or controller');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final onSurface = colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.60,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(icon: Icons.remove, onTap: onDecrement),
                if (controller != null)
                  SizedBox(
                    width: 78,
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      textAlign: TextAlign.center,
                      cursorHeight: 14,
                      style: (textTheme.labelMedium ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.w600,
                          ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        border: InputBorder.none,
                        suffixText: suffix,
                        suffixStyle: (textTheme.labelMedium ?? const TextStyle())
                            .copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
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
                      style: (textTheme.labelMedium ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                _StepperButton(icon: Icons.add, onTap: onIncrement),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: colorScheme.onSurface),
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
  final String? tooltip;
  final bool active;
  final bool isCompact;

  const PlayerPillButton({
    super.key,
    required this.onTap,
    this.icon,
    this.label,
    this.tooltip,
    this.active = false,
    this.isCompact = false,
  }) : assert(icon != null || label != null, 'Must provide icon or label');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = active
        ? colorScheme.primaryContainer.withValues(alpha: 0.85)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.70);
    final borderColor = active
        ? colorScheme.primary.withValues(alpha: 0.60)
        : colorScheme.outlineVariant.withValues(alpha: 0.35);
    final fgColor = active ? colorScheme.onPrimaryContainer : Colors.white;

    final padH = isCompact ? 8.0 : 10.0;
    final padV = isCompact ? 4.5 : 6.0;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isCompact ? 14 : 15, color: fgColor),
                if (label != null) SizedBox(width: isCompact ? 4 : 6),
              ],
              if (label != null)
                Text(
                  label!,
                  style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
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
    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}

typedef SettingsSectionBuilder = Widget Function(BuildContext context);

/// One entry in the settings home list ("Qualité", "Vitesse"...): an icon, a
/// label, an optional live current-value widget shown to the right of it
/// (e.g. "1.0×"), and the content shown after drilling into it.
class SettingsEntry {
  final String label;
  final IconData icon;
  final WidgetBuilder? valueBuilder;
  final SettingsSectionBuilder contentBuilder;

  const SettingsEntry({
    required this.label,
    required this.icon,
    required this.contentBuilder,
    this.valueBuilder,
  });
}

class _SettingsHomeRow extends StatelessWidget {
  final SettingsEntry entry;
  final VoidCallback onTap;
  const _SettingsHomeRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final onSurface = colorScheme.onSurface;
    final accent = colorScheme.primary;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Icon(entry.icon, size: 18, color: accent),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  entry.label,
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (entry.valueBuilder != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DefaultTextStyle.merge(
                    style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    child: entry.valueBuilder!(context),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.70),
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
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
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
                      key: const ValueKey('back-button'),
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back, color: onSurface, size: 20),
                      splashRadius: 20,
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('no-back')),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
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
                  style: (textTheme.titleMedium ?? const TextStyle()).copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close, color: onSurface, size: 20),
              splashRadius: 20,
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
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
      index >= 0 && index < widget.entries.length ? index : null;

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
              title: active == null
                  ? widget.title
                  : widget.entries[active].label,
              showBack: !isDirectShortcut && active != null,
              forward: _forward,
              onBack: _goHome,
              onClose: widget.onClose,
            ),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
            ),
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        ...previousChildren.map(
                          (child) => Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: child,
                          ),
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
                      padding: const EdgeInsets.only(bottom: 12),
                      child: active == null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var i = 0; i < widget.entries.length; i++)
                                  _SettingsHomeRow(
                                    entry: widget.entries[i],
                                    onTap: () => _open(i),
                                  ),
                                const SizedBox(height: 4),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: widget.entries[active].contentBuilder(
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.40),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 6),
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
    color: Theme.of(anchor).colorScheme.surfaceContainerHigh,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
