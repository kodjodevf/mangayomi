import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/library/tv_home/tv_home_layout.dart';

/// Shown when the anime library is empty — carries a *focusable* action so the
/// content always has a focus target (otherwise the empty home traps the d-pad
/// with nothing to move Left from to reach the rail).
class TvEmptyHome extends StatefulWidget {
  const TvEmptyHome({super.key});

  @override
  State<TvEmptyHome> createState() => _EmptyHomeState();
}

class _EmptyHomeState extends State<TvEmptyHome> {
  bool _focused = false;

  void _browse() => context.go('/browse');

  @override
  Widget build(BuildContext context) {
    final accent = context.shiori.color.accentInk;
    final hint = context.shiori.color.fgMuted;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.video_library_rounded, size: 56, color: accent),
          const SizedBox(height: 16),
          Text(
            context.l10n.tv_empty_anime_library,
            style: TextStyle(
              fontSize: ShioriType.reference.section.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.tv_empty_anime_library_hint,
            style: TextStyle(color: hint),
          ),
          const SizedBox(height: 22),
          Focus(
            autofocus: true,
            onFocusChange: (f) => setState(() => _focused = f),
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && isTvSelectKey(event.logicalKey)) {
                _browse();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              onTap: _browse,
              child: AnimatedContainer(
                duration: ShioriMotion.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ShioriShape.sheet),
                  color: _focused
                      ? accent
                      : accent.withValues(alpha: Alphas.focus),
                  border: Border.all(
                    color: _focused ? accent : accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.explore_rounded,
                      color: _focused ? ShioriColors.onFill(accent) : accent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.browse_anime,
                      style: TextStyle(
                        color: _focused ? ShioriColors.onFill(accent) : accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
