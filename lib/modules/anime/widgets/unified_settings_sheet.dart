import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_theme.dart';

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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? PlayerTheme.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? PlayerTheme.accent : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? PlayerTheme.accent
                        : Colors.white.withValues(alpha: 0.28),
                    width: 1.4,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: PlayerTheme.accentInk,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.85),
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
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white.withValues(alpha: 0.4),
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 17, color: Colors.white.withValues(alpha: 0.75)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.white.withValues(alpha: 0.35),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10.5,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

/// A "-"/"+" stepper row (subtitle delay, subtitle speed...).
class SettingsStepperRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const SettingsStepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 64,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFeatures: [FontFeature.tabularFigures()],
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
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
    );
  }
}

/// A small persistent pill for the bottom rail (current speed, current fit
/// mode...) so the value stays glanceable without opening a menu — replacing
/// icons that either cycled silently or only surfaced their value in a toast.
class PlayerPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? tooltip;

  const PlayerPillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: PlayerTheme.chipBackdrop,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Icon(
                entry.icon,
                size: 18,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  entry.label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (entry.valueBuilder != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    child: entry.valueBuilder!(context),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrilldownHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const _DrilldownHeader({
    required this.title,
    required this.showBack,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 8, 4),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            )
          else
            const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: showBack ? 0 : 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
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

  int? _clampActive(int index) =>
      index >= 0 && index < widget.entries.length ? index : null;

  @override
  void didUpdateWidget(SettingsDrilldown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Not a route on desktop (it's the same popup staying open), so jumping
    // to a different section (the speed pill, the chapter label...) while
    // already open has to move the selection itself.
    if (widget.initialIndex != oldWidget.initialIndex) {
      _active = _clampActive(widget.initialIndex);
    }
  }

  void _goHome() => setState(() => _active = null);
  void _open(int index) => setState(() => _active = index);

  @override
  Widget build(BuildContext context) {
    final active = _active;
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DrilldownHeader(
              title: active == null
                  ? widget.title
                  : widget.entries[active].label,
              showBack: active != null,
              onBack: _goHome,
              onClose: widget.onClose,
            ),
            const Divider(height: 1, color: Color(0x14FFFFFF)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final isHome = child.key == const ValueKey('home');
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(isHome ? -1 : 1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: active == null
                  ? Column(
                      key: const ValueKey('home'),
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
                      key: ValueKey('section-$active'),
                      padding: const EdgeInsets.only(bottom: 6),
                      child: widget.entries[active].contentBuilder(context),
                    ),
            ),
          ],
        ),
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF171310),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 9),
                Container(
                  width: 34,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: SettingsDrilldown(
                      title: title,
                      entries: entries,
                      initialIndex: initialIndex,
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
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
  final overlay =
      Navigator.of(anchor).overlay!.context.findRenderObject() as RenderBox;
  final button = anchor.findRenderObject() as RenderBox;
  // Anchored to the button's own rect — showMenu grows the popup from it,
  // flipping above when (as here, a bottom control bar) there's no room
  // below, exactly like YouTube's gear menu growing upward from the bar.
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
  return showMenu<void>(
    context: anchor,
    position: position,
    color: const Color(0xFF171310),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    menuPadding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 320),
    items: [
      PopupMenuItem<void>(
        enabled: false,
        padding: EdgeInsets.zero,
        child: SettingsDrilldown(
          title: title,
          entries: entries,
          initialIndex: initialIndex,
          onClose: () => Navigator.of(anchor).pop(),
        ),
      ),
    ],
  );
}
