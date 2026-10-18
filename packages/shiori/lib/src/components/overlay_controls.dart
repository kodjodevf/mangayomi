import 'package:flutter/material.dart';

import '../alphas.dart';
import '../tokens.dart';

// Controls drawn over a picture, the video player's above all. They sit on
// ShioriScrim with white on it rather than on a theme surface, so they read
// on a black frame and a white one alike, in either theme. The accent marks
// the one thing to press: play, the next episode.

/// A small pill over the picture that shows a value and opens its choice:
/// the quality, the subtitles, the speed. A setting kept in sight, rather
/// than an icon that cycles silently.
///
/// [emphasized] fills it with the accent, for the one action of its row.
/// The pill stays small but takes a tap anywhere in a target of the
/// density's size around it; focused from a keyboard or a remote, it is
/// ringed in the accent.
class ShioriOverlayPill extends StatefulWidget {
  const ShioriOverlayPill({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.icon,
    this.label,
    this.tooltip,
    this.emphasized = false,
    this.compact = false,
    this.trailingIcon,
    this.focusNode,
    this.semanticsValue,
  }) : assert(icon != null || label != null, 'An icon or a label is needed.');

  final VoidCallback onTap;
  final GestureLongPressCallback? onLongPress;
  final IconData? icon;
  final String? label;

  /// Named for a screen reader and on hover; the label alone when null.
  final String? tooltip;
  final bool emphasized;

  /// Tighter, for a row that has to hold many.
  final bool compact;

  /// After the label, such as the arrow of "Next".
  final IconData? trailingIcon;
  final FocusNode? focusNode;

  /// The value read out when the pill shows only its icon, such as the
  /// speed on a narrow row.
  final String? semanticsValue;

  @override
  State<ShioriOverlayPill> createState() => _ShioriOverlayPillState();
}

class _ShioriOverlayPillState extends State<ShioriOverlayPill> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final background = widget.emphasized ? c.accent : ShioriScrim.underText;
    final foreground = widget.emphasized ? c.onAccent : Colors.white;
    final iconSize = tokens.scaled(widget.compact ? 16 : 18);
    final pill = AnimatedContainer(
      duration: ShioriMotion.of(context, ShioriMotion.fast),
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? ShioriSpace.s8 : ShioriSpace.s12,
        vertical: widget.compact ? ShioriSpace.s4 : ShioriSpace.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(ShioriShape.pill),
        border: Border.all(
          color: _focused ? c.accent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s4,
        children: [
          if (widget.icon != null)
            Icon(widget.icon, size: iconSize, color: foreground),
          // A value is a glance, not a sentence: a long one (a mirror's full
          // name) is cut, and read whole where it is chosen.
          if (widget.label != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tokens.scaled(160)),
              child: Text(
                widget.label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.meta.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          if (widget.trailingIcon != null)
            Icon(widget.trailingIcon, size: iconSize, color: foreground),
        ],
      ),
    );
    // One node: what it is and its value, with the ink's tap and focus.
    final target = MergeSemantics(
      child: Semantics(
        button: true,
        label: widget.tooltip ?? widget.label,
        value:
            widget.semanticsValue ??
            (widget.tooltip != null ? widget.label : null),
        child: InkWell(
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onFocusChange: (f) => setState(() => _focused = f),
          customBorder: const StadiumBorder(),
          focusColor: Colors.transparent,
          child: ExcludeSemantics(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: tokens.density.minTarget),
              child: Center(widthFactor: 1, heightFactor: 1, child: pill),
            ),
          ),
        ),
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: widget.tooltip == null
          ? target
          : Tooltip(
              message: widget.tooltip!,
              excludeFromSemantics: true,
              child: target,
            ),
    );
  }
}

/// A round control over the picture: play, a jump of ten seconds, the next
/// episode.
///
/// [emphasized] is the screen's one main control, a disc in the accent;
/// the others are white glyphs with no ground, so the eye goes to the disc.
/// [caption] says what a glyph can't, such as "10 s" under a jump.
class ShioriOverlayIconButton extends StatefulWidget {
  const ShioriOverlayIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.onLongPress,
    this.emphasized = false,
    this.size = 28,
    this.caption,
    this.focusNode,
  });

  /// Usually an [Icon]; an animated icon for play and pause.
  final Widget icon;
  final String tooltip;

  /// Disabled when null: drawn faint, and said to be so.
  final VoidCallback? onPressed;
  final GestureLongPressCallback? onLongPress;
  final bool emphasized;

  /// The glyph's size before the density's scale.
  final double size;
  final String? caption;
  final FocusNode? focusNode;

  @override
  State<ShioriOverlayIconButton> createState() =>
      _ShioriOverlayIconButtonState();
}

class _ShioriOverlayIconButtonState extends State<ShioriOverlayIconButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final enabled = widget.onPressed != null;
    final glyph = tokens.scaled(widget.size);
    final foreground = widget.emphasized
        ? c.onAccent
        : Colors.white.withValues(alpha: enabled ? 1 : Alphas.disabled);
    // The disc holds the glyph with room around it; a bare glyph still
    // takes a target of the density's size.
    final extent = widget.emphasized
        ? glyph * 2
        : glyph < tokens.density.minTarget
        ? tokens.density.minTarget
        : glyph + ShioriSpace.s16;
    final button = AnimatedContainer(
      duration: ShioriMotion.of(context, ShioriMotion.fast),
      width: extent,
      height: extent,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.emphasized ? c.accent : Colors.transparent,
        border: Border.all(
          color: _focused ? c.accent : Colors.transparent,
          width: 2.5,
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground, size: glyph),
        child: widget.icon,
      ),
    );
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.tooltip,
        child: Tooltip(
          message: widget.tooltip,
          excludeFromSemantics: true,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              focusNode: widget.focusNode,
              onTap: widget.onPressed,
              onLongPress: widget.onLongPress,
              onFocusChange: (f) => setState(() => _focused = f),
              customBorder: const CircleBorder(),
              focusColor: Colors.transparent,
              child: ExcludeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    button,
                    if (widget.caption != null)
                      Text(
                        widget.caption!,
                        style: tokens.text.badge.copyWith(
                          color: foreground,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A panel of controls floating over the foot of the picture, as the
/// manga reader's bottom panel floats over the page: rounded as a sheet,
/// clear of the edges, on [ShioriScrim.panel].
class ShioriOverlayPanel extends StatelessWidget {
  const ShioriOverlayPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      ShioriSpace.s12,
      ShioriSpace.s8,
      ShioriSpace.s12,
      ShioriSpace.s4,
    ),
    this.maxWidth = 960,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Wider than a page: a video is.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ShioriScrim.panel,
            borderRadius: BorderRadius.circular(ShioriShape.sheet),
          ),
          child: IconTheme.merge(
            data: const IconThemeData(color: Colors.white),
            child: DefaultTextStyle.merge(
              style: tokens.text.meta.copyWith(color: Colors.white),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// A vertical gauge over the picture while a swipe sets a level: the
/// brightness on the left, the volume on the right. A pill that fills from
/// the bottom, the level in figures above it and what it sets below.
class ShioriGestureGauge extends StatelessWidget {
  const ShioriGestureGauge({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
    this.height = 160,
  });

  /// From 0 to 1.
  final double value;
  final IconData icon;

  /// Read by a screen reader: "Volume", "Brightness".
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final level = value.clamp(0.0, 1.0);
    final width = tokens.scaled(40);
    return Semantics(
      label: label,
      value: '${(level * 100).round()} %',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ShioriScrim.panel,
          borderRadius: BorderRadius.circular(ShioriShape.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s8,
            children: [
              SizedBox(
                width: width,
                child: Text(
                  '${(level * 100).round()}',
                  textAlign: TextAlign.center,
                  style: tokens.text.badge.copyWith(
                    color: Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Container(
                width: ShioriSpace.s8,
                height: tokens.scaled(height),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: Alphas.hairline),
                  borderRadius: BorderRadius.circular(ShioriShape.pill),
                ),
                child: FractionallySizedBox(
                  heightFactor: level,
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.color.accent,
                      borderRadius: BorderRadius.circular(ShioriShape.pill),
                    ),
                  ),
                ),
              ),
              Icon(icon, size: tokens.scaled(20), color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
