import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The map of tap zones drawn over the page: where a tap turns back, turns
/// on, or shows the bars. Shown on start (when set to) and for a moment
/// after the reading mode or the layout changes.
///
/// Each zone is tinted in a status colour that keeps them apart at a
/// glance (next in the completed green, previous in the offline orange,
/// the menu neutral), lightly enough to leave the page readable, and named
/// on the reader's own label with an arrow or the menu glyph. It used to
/// say MENU, PREV and NEXT in English over heavy hand-picked colours, and
/// did not say a tap closes it.

class ReaderNavigationOverlay extends StatelessWidget {
  final int navigationLayout;
  final int tappingInversion;
  final bool isRTL;
  final VoidCallback onClose;

  const ReaderNavigationOverlay({
    super.key,
    required this.navigationLayout,
    required this.tappingInversion,
    required this.isRTL,
    required this.onClose,
  });

  bool get _shouldInvertHorizontal =>
      tappingInversion == 1 || tappingInversion == 3;
  bool get _shouldInvertVertical =>
      tappingInversion == 2 || tappingInversion == 3;

  // A zone's tint stands for its action; the label inside names it.
  static const _menuColor = _Tint.menu;
  static const _prevColor = _Tint.previous;
  static const _nextColor = _Tint.next;

  static const _menuText = _Action.menu;
  static const _prevText = _Action.previous;
  static const _nextText = _Action.next;

  Widget _zone(_Tint tint, _Action action) => _Zone(tint: tint, action: action);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClose,
      child: Stack(
        children: [
          Positioned.fill(
            child: switch (navigationLayout) {
              1 => _buildLShaped(),
              2 => _buildKindle(),
              3 => _buildEdge(),
              4 => _buildRightAndLeft(),
              5 => _buildDisabled(),
              _ => _buildDefault(),
            },
          ),
          // How to be rid of it.
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + ShioriSpace.s24,
            child: Center(
              child: ShioriOverlayLabel(context.l10n.tap_to_continue),
            ),
          ),
        ],
      ),
    );
  }

  // Helper values for LTR vs RTL
  (_Tint, _Action) get _hLeft =>
      isRTL ? (_nextColor, _nextText) : (_prevColor, _prevText);
  (_Tint, _Action) get _hRight =>
      isRTL ? (_prevColor, _prevText) : (_nextColor, _nextText);

  (_Tint, _Action) get _leftZone => _shouldInvertHorizontal ? _hRight : _hLeft;
  (_Tint, _Action) get _rightZone => _shouldInvertHorizontal ? _hLeft : _hRight;

  Widget _buildDefault() {
    return Stack(
      children: [_buildDefaultHorizontalZones(), _buildDefaultVerticalZones()],
    );
  }

  Widget _buildDefaultHorizontalZones() {
    final left = _leftZone;
    final right = _rightZone;
    return Row(
      children: [
        Expanded(flex: 2, child: _zone(left.$1, left.$2)),
        Expanded(flex: 2, child: _zone(_menuColor, _menuText)),
        Expanded(flex: 2, child: _zone(right.$1, right.$2)),
      ],
    );
  }

  Widget _buildDefaultVerticalZones() {
    final topText = _shouldInvertVertical ? _nextText : _prevText;
    final topColor = _shouldInvertVertical ? _nextColor : _prevColor;
    final bottomText = _shouldInvertVertical ? _prevText : _nextText;
    final bottomColor = _shouldInvertVertical ? _prevColor : _nextColor;

    return Column(
      children: [
        Expanded(flex: 2, child: _zone(topColor, topText)),
        const Expanded(flex: 5, child: SizedBox.shrink()),
        Expanded(flex: 2, child: _zone(bottomColor, bottomText)),
      ],
    );
  }

  Widget _buildLShaped() {
    final leftAction = (_shouldInvertHorizontal ^ _shouldInvertVertical)
        ? _nextText
        : _prevText;
    final leftColor = (_shouldInvertHorizontal ^ _shouldInvertVertical)
        ? _nextColor
        : _prevColor;

    final rightAction = (_shouldInvertHorizontal ^ _shouldInvertVertical)
        ? _prevText
        : _nextText;
    final rightColor = (_shouldInvertHorizontal ^ _shouldInvertVertical)
        ? _prevColor
        : _nextColor;

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 1, child: _zone(leftColor, leftAction)),
              Expanded(flex: 2, child: _zone(_menuColor, _menuText)),
            ],
          ),
        ),
        Expanded(flex: 2, child: _zone(_menuColor, _menuText)),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 2, child: _zone(_menuColor, _menuText)),
              Expanded(flex: 1, child: _zone(rightColor, rightAction)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKindle() {
    final left = _leftZone;
    final right = _rightZone;
    return Column(
      children: [
        Expanded(flex: 1, child: _zone(_menuColor, _menuText)),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(child: _zone(left.$1, left.$2)),
              Expanded(child: _zone(right.$1, right.$2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEdge() {
    final left = _leftZone;
    final right = _rightZone;
    return Row(
      children: [
        Expanded(flex: 1, child: _zone(left.$1, left.$2)),
        Expanded(flex: 5, child: _zone(_menuColor, _menuText)),
        Expanded(flex: 1, child: _zone(right.$1, right.$2)),
      ],
    );
  }

  Widget _buildRightAndLeft() {
    final left = _leftZone;
    final right = _rightZone;
    return Row(
      children: [
        Expanded(child: _zone(left.$1, left.$2)),
        Expanded(child: _zone(right.$1, right.$2)),
      ],
    );
  }

  Widget _buildDisabled() {
    return SizedBox.expand(child: _zone(_menuColor, _menuText));
  }
}

enum _Tint { menu, previous, next }

enum _Action { menu, previous, next }

class _Zone extends StatelessWidget {
  const _Zone({required this.tint, required this.action});

  final _Tint tint;
  final _Action action;

  @override
  Widget build(BuildContext context) {
    final c = context.shiori.color;
    final l10n = context.l10n;
    final color = switch (tint) {
      _Tint.next => c.completed.foreground,
      _Tint.previous => c.offline.foreground,
      _Tint.menu => c.ink3,
    };
    final (IconData icon, String label) = switch (action) {
      _Action.next => (Symbols.arrow_forward_rounded, l10n.tap_zone_next),
      _Action.previous => (Symbols.arrow_back_rounded, l10n.tap_zone_previous),
      _Action.menu => (Symbols.menu_rounded, l10n.tap_zone_menu),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        border: Border.all(color: c.ink0.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ShioriScrim.underText,
            borderRadius: BorderRadius.circular(ShioriShape.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ShioriSpace.s12,
              vertical: ShioriSpace.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: ShioriSpace.s4,
              children: [
                Icon(
                  icon,
                  size: context.shiori.scaled(18),
                  color: Colors.white,
                ),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.shiori.text.row.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
