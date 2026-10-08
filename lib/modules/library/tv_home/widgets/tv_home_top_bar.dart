import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/library/tv_home/tv_home_layout.dart';

/// Search field + card-density control. Sits above the rows; Up from the hero
/// reaches it.
class TvHomeTopBar extends StatelessWidget {
  const TvHomeTopBar({
    super.key,
    required this.controller,
    required this.settings,
    required this.entries,
    required this.onChanged,
  });
  final TextEditingController controller;
  final Settings settings;
  final List<Manga> entries;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 6),
      child: Row(
        children: [
          Expanded(
            // The text field owns Left/Right for the cursor; let Right escape to
            // the size button once the cursor is at the end of the text.
            child: Focus(
              canRequestFocus: false,
              skipTraversal: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  final sel = controller.selection;
                  final atEnd =
                      !sel.isValid || sel.baseOffset >= controller.text.length;
                  if (atEnd) {
                    FocusScope.of(context)
                        .focusInDirection(TraversalDirection.right);
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) =>
                    FocusScope.of(context)
                        .focusInDirection(TraversalDirection.down),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  hintText: context.l10n.search_your_anime,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide(color: accent, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _LibrarySettingsButton(settings: settings, entries: entries),
        ],
      ),
    );
  }
}

/// Opens the library's own filter/sort/display sheet — the same one the phone
/// app uses, already d-pad traversable. Its grid-size slider is where card
/// density now lives.
class _LibrarySettingsButton extends ConsumerStatefulWidget {
  const _LibrarySettingsButton({required this.settings, required this.entries});

  final Settings settings;
  final List<Manga> entries;

  @override
  ConsumerState<_LibrarySettingsButton> createState() =>
      _LibrarySettingsButtonState();
}

class _LibrarySettingsButtonState extends ConsumerState<_LibrarySettingsButton>
    with SingleTickerProviderStateMixin {
  bool _focused = false;

  void _open() => showLibrarySettingsSheet(
    context: context,
    vsync: this,
    settings: widget.settings,
    itemType: ItemType.anime,
    entries: widget.entries,
  );

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        // Opens on release: the sheet must not inherit the repeats of the press
        // that opened it (SingleActivator activates on repeats).
        if (event is KeyUpEvent && isTvSelectKey(event.logicalKey)) {
          _open();
          return KeyEventResult.handled;
        }
        if (isTvSelectKey(event.logicalKey)) return KeyEventResult.handled;
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused ? accent : accent.withValues(alpha: 0.12),
          ),
          child: Icon(
            Icons.filter_list_sharp,
            size: 22,
            color: _focused ? Colors.white : accent,
          ),
        ),
      ),
    );
  }
}
