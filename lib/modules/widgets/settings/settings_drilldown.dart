import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

import 'settings_rows.dart';

typedef SettingsSectionBuilder = Widget Function(BuildContext context);

/// One entry in the settings home: an icon, a label, its current value
/// (e.g. "1×"), and what a tap does: open a section ([contentBuilder]), run
/// an action ([onTap]), or flip a switch ([toggle] and [onToggle]).
///
/// [featured] entries, the ones changed while watching/reading, open the home as
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

/// Fast exit curve: old page fades out cleanly between t = 1.0 and 0.45.
class _FastExitFadeCurve extends Curve {
  const _FastExitFadeCurve();

  @override
  double transformInternal(double t) {
    if (t <= 0.45) return 0.0;
    final p = (t - 0.45) / 0.55;
    return Curves.easeInQuad.transform(p);
  }
}

/// Smooth entrance curve: new page begins fading in at t = 0.15 with easeOutCubic.
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
            SizedBox(width: showBack ? ShioriSpace.s4 : ShioriSpace.s12),
            Expanded(
              child: AnimatedSwitcher(
                duration: ShioriMotion.standard,
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
/// fit, video track) to navigate back to the settings home list.
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

/// Settings as a single browsable list with animated drilldown navigation.
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
              duration: ShioriMotion.standard,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: ShioriMotion.standard,
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
