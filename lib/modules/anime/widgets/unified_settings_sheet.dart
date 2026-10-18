import 'package:flutter/foundation.dart';
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
    // Shiori's pill over a picture: on the scrim whatever the theme, filled
    // with the accent when on, a full-size target around a small pill.
    final visibleLabel = showLabel ? label : null;
    return ShioriOverlayPill(
      icon: icon,
      label: visibleLabel,
      // Named whole for a screen reader even when only the icon shows.
      tooltip: tooltip ?? (visibleLabel == null ? label : null),
      semanticsValue: visibleLabel == null && tooltip != null ? label : null,
      emphasized: active,
      compact: isCompact,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

typedef SettingsSectionBuilder = Widget Function(BuildContext context);

/// One entry in the settings home: an icon, a label, its current value
/// (e.g. "1×"), and what a tap does: open a section ([contentBuilder]), run
/// an action ([onTap]), or flip a switch ([toggle] and [onToggle]).
///
/// [featured] entries, the ones changed while watching, open the home as
/// tiles; the rest follow as rows under their [group]'s label.
class SettingsEntry {
  final String label;
  final IconData icon;
  final WidgetBuilder? valueBuilder;
  final SettingsSectionBuilder? contentBuilder;
  final ValueChanged<BuildContext>? onTap;
  final ValueListenable<bool>? toggle;
  final ValueChanged<bool>? onToggle;
  final bool featured;
  final String? group;

  const SettingsEntry({
    required this.label,
    required this.icon,
    this.contentBuilder,
    this.onTap,
    this.valueBuilder,
    this.toggle,
    this.onToggle,
    this.featured = false,
    this.group,
  }) : assert(
         (contentBuilder != null ? 1 : 0) +
                 (onTap != null ? 1 : 0) +
                 (toggle != null ? 1 : 0) ==
             1,
         'Provide one of contentBuilder, onTap or toggle',
       ),
       assert(toggle == null || onToggle != null, 'A toggle needs onToggle');
}

/// The icon of a settings row, on a small tile of its own so the column of
/// icons reads as a column, as the app's lists do with thumbnails.
class _EntryIcon extends StatelessWidget {
  const _EntryIcon(this.icon, {this.accent = false});

  final IconData icon;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final extent = tokens.scaled(36);
    return Container(
      width: extent,
      height: extent,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent ? c.accent.withValues(alpha: Alphas.accentTint) : c.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Icon(
        icon,
        size: tokens.scaled(20),
        color: accent ? c.accentInk : c.fg,
      ),
    );
  }
}

/// A featured entry: a tile with its icon, its name and, largest, its value,
/// the thing one opens the settings to read or change.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.entry, required this.onTap});

  final SettingsEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    return Material(
      color: c.ink2,
      borderRadius: BorderRadius.circular(ShioriShape.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(ShioriSpace.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ShioriSpace.s8,
            children: [
              _EntryIcon(entry.icon, accent: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.caption,
                  ),
                  if (entry.valueBuilder != null)
                    DefaultTextStyle.merge(
                      style: tokens.text.row.copyWith(
                        color: c.fg,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: entry.valueBuilder!(context),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHomeRow extends StatelessWidget {
  final SettingsEntry entry;
  final VoidCallback onTap;
  const _SettingsHomeRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final toggle = entry.toggle;
    // Two lines before it is cut: "Autoplay next episode" runs long in
    // French and German beside a switch.
    final label = Text(
      entry.label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: tokens.text.row.copyWith(color: c.fg),
    );
    final row = Container(
      constraints: BoxConstraints(minHeight: tokens.density.rowHeight),
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
      child: Row(
        spacing: ShioriSpace.s12,
        children: [
          _EntryIcon(entry.icon),
          Expanded(child: label),
          if (entry.valueBuilder != null)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.sizeOf(context).width * 0.3).clamp(
                  80.0,
                  160.0,
                ),
              ),
              child: DefaultTextStyle.merge(
                style: tokens.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                child: entry.valueBuilder!(context),
              ),
            ),
          if (toggle != null)
            ValueListenableBuilder<bool>(
              valueListenable: toggle,
              builder: (context, on, _) =>
                  Switch(value: on, onChanged: entry.onToggle),
            )
          else if (entry.contentBuilder != null)
            Icon(
              Symbols.chevron_right_rounded,
              size: tokens.scaled(20),
              color: c.fgMuted,
            ),
        ],
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: toggle != null ? () => entry.onToggle!(!toggle.value) : onTap,
        child: row,
      ),
    );
  }
}

/// The settings home: the featured entries as tiles, two or four across,
/// then the others in their groups.
class _SettingsHome extends StatelessWidget {
  const _SettingsHome({required this.entries, required this.onOpen});

  final List<SettingsEntry> entries;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final featured = [
      for (var i = 0; i < entries.length; i++)
        if (entries[i].featured) i,
    ];
    final groups = <String?, List<int>>{};
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].featured) continue;
      groups.putIfAbsent(entries[i].group, () => []).add(i);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (featured.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s12,
              ShioriSpace.s16,
              ShioriSpace.s4,
            ),
            // Two across in rows of Expanded, not a LayoutBuilder: the
            // desktop popup measures its content's intrinsic width, which a
            // LayoutBuilder cannot answer.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: ShioriSpace.s8,
              children: [
                for (var r = 0; r < featured.length; r += 2)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: ShioriSpace.s8,
                      children: [
                        for (final i in featured.skip(r).take(2))
                          Expanded(
                            child: _SettingsTile(
                              entry: entries[i],
                              onTap: () => onOpen(i),
                            ),
                          ),
                        if (r + 1 >= featured.length) const Spacer(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        for (final MapEntry(key: group, value: indices) in groups.entries) ...[
          if (group != null) SettingsSectionLabel(group),
          for (final i in indices)
            _SettingsHomeRow(entry: entries[i], onTap: () => onOpen(i)),
        ],
        const SizedBox(height: ShioriSpace.s4),
      ],
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

  /// The most the body may take before it scrolls; most of the screen's
  /// height when null.
  final double? maxBodyHeight;

  const SettingsDrilldown({
    super.key,
    required this.title,
    required this.entries,
    required this.onClose,
    this.initialIndex = -1,
    this.maxBodyHeight,
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
    final maxBodyHeight = widget.maxBodyHeight ?? screenHeight * 0.72;

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
                        ? _SettingsHome(
                            entries: widget.entries,
                            onOpen: (i) {
                              final entry = widget.entries[i];
                              if (entry.onTap != null) {
                                entry.onTap!(context);
                              } else if (entry.contentBuilder != null) {
                                _open(i);
                              }
                            },
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

/// Whether the player's settings open beside the video rather than over
/// it: on a screen wider than tall, as the episode list does, so what they
/// change (a subtitle's size, the fit) can be seen while it is changed.
bool playerSettingsOpenBeside(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width > size.height && size.width >= 600;
}

/// Opens the mobile settings: a panel from the side in landscape, a sheet
/// from the bottom in portrait.
Future<T?> showUnifiedPlayerSettings<T>(
  BuildContext context, {
  required String title,
  required List<SettingsEntry> entries,
  int initialIndex = -1,
}) {
  if (playerSettingsOpenBeside(context)) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width * 0.42).clamp(340.0, 440.0);
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: ShioriMotion.of(context, ShioriMotion.enter),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: ShioriMotion.enterCurve),
        ),
        child: child,
      ),
      pageBuilder: (dialogContext, _, _) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Material(
            color: dialogContext.shiori.color.ink1.withValues(
              alpha: Alphas.chrome,
            ),
            borderRadius: const BorderRadiusDirectional.horizontal(
              start: Radius.circular(ShioriShape.sheet),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              left: false,
              child: SettingsDrilldown(
                title: title,
                entries: entries,
                initialIndex: initialIndex,
                // The header's height off the panel's.
                maxBodyHeight:
                    MediaQuery.sizeOf(dialogContext).height -
                    MediaQuery.paddingOf(dialogContext).vertical -
                    ShioriSpace.s48 -
                    ShioriSpace.s16,
                onClose: () => Navigator.pop(dialogContext),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
