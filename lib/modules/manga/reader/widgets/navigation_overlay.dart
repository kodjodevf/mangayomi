import 'package:flutter/material.dart';

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

  Color get _menuColor => const Color(0xCC95818D);
  Color get _prevColor => const Color(0xCCFF7733);
  Color get _nextColor => const Color(0xCC84E296);

  String get _menuText => "MENU";
  String get _prevText => "PREV";
  String get _nextText => "NEXT";

  Widget _zone(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black26, width: 0.5),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black54,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClose,
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.transparent,
          child: switch (navigationLayout) {
            1 => _buildLShaped(),
            2 => _buildKindle(),
            3 => _buildEdge(),
            4 => _buildRightAndLeft(),
            5 => _buildDisabled(),
            _ => _buildDefault(),
          },
        ),
      ),
    );
  }

  // Helper values for LTR vs RTL
  (Color, String) get _hLeft =>
      isRTL ? (_nextColor, _nextText) : (_prevColor, _prevText);
  (Color, String) get _hRight =>
      isRTL ? (_prevColor, _prevText) : (_nextColor, _nextText);

  (Color, String) get _leftZone => _shouldInvertHorizontal ? _hRight : _hLeft;
  (Color, String) get _rightZone => _shouldInvertHorizontal ? _hLeft : _hRight;

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
