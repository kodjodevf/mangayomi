import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
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
    final accent = context.primaryColor;
    final hint = Theme.of(context).hintColor;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined, size: 56, color: accent),
          const SizedBox(height: 16),
          const Text(
            'Your anime library is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Add anime from Browse to fill your home',
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
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: _focused ? accent : accent.withValues(alpha: 0.12),
                  border: Border.all(
                    color: _focused ? accent : accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      color: _focused ? Colors.white : accent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Browse anime',
                      style: TextStyle(
                        color: _focused ? Colors.white : accent,
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
