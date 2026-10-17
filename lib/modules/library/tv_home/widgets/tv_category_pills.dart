import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/widgets/custom_textfield.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The category filter bar under the search row: [All] + a pill per category +
/// [+ Category]. Selecting sets the filter but keeps focus on the pill.
class TvCategoryPills extends StatefulWidget {
  const TvCategoryPills({
    super.key,
    required this.selected,
    required this.categories,
    required this.hidden,
    required this.onSelect,
  });
  final int? selected;
  final List<Category> categories;
  final List<Category> hidden;
  final ValueChanged<int?> onSelect;

  @override
  State<TvCategoryPills> createState() => _CategoryPillsState();
}

class _CategoryPillsState extends State<TvCategoryPills> {
  /// "All" is the one pill that always exists, so it's where focus lands when
  /// the pill that had it leaves the tree — hiding it, or unhiding the last
  /// hidden category and losing the Hidden pill with it.
  final _allNode = FocusNode(debugLabel: 'tvPillAll');

  @override
  void dispose() {
    _allNode.dispose();
    super.dispose();
  }

  void _focusAll() {
    Future<void>.microtask(() {
      if (mounted) _allNode.requestFocus();
    });
  }

  /// Hold OK on a category pill to hide it: the pill goes away and so do its
  /// titles, matching what hiding does in the library. Unconfirmed, because the
  /// toast that names the way back doubles as the undo prompt.
  void _hide(Category category) {
    categoryRepository.setHidden(category, true);
    if (widget.selected == category.id) widget.onSelect(null);
    _focusAll();
    botToast('Hid “${category.name}” · hold OK on “All” to unhide');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            // minWidth = viewport, so the Row centers its pills when they fit
            // and simply grows/scrolls when there are many categories.
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: FocusTraversalGroup(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TvPill(
                    label: 'All',
                    focusNode: _allNode,
                    selected: widget.selected == null,
                    autofocus: true,
                    onTap: () => widget.onSelect(null),
                    onLongPress: () =>
                        _showHiddenCategoriesDialog(context, widget.hidden),
                    onMenu: () =>
                        _showHiddenCategoriesDialog(context, widget.hidden),
                  ),
                  for (final c in widget.categories)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TvPill(
                        label: c.name ?? '',
                        selected: widget.selected == c.id,
                        onTap: () => widget.onSelect(c.id),
                        onLongPress: () => _hide(c),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TvPill(
                      label: context.l10n.category,
                      icon: Symbols.add_rounded,
                      onTap: () =>
                          _showAddCategoryDialog(context, widget.categories),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// The filter pill moved to the shared `TvPill` widget
// (lib/modules/widgets/tv_pill.dart), reused by the Browse tab switcher.

/// Reuses the categories screen's add-category flow to create an anime category
/// inline from the home.
/// Has no chip, no icon, nothing on screen: a visible "Hidden" affordance would
/// advertise the categories the user hid, which is most of what hiding is for.
/// Reached from the "All" pill — hold OK on it, or press Menu while it's
/// focused. Hiding leaves focus there, so the toast can name the way back.
Future<void> _showHiddenCategoriesDialog(
  BuildContext context,
  List<Category> hidden,
) async {
  if (hidden.isEmpty) {
    botToast('No hidden categories');
    return;
  }
  // Picking one shows it again.
  final category = await showShioriChoice<Category>(
    context,
    title: context.l10n.hidden_categories,
    options: [
      for (final c in hidden)
        ShioriChoice(c, c.name ?? '', icon: Symbols.visibility_rounded),
    ],
  );
  if (category != null) categoryRepository.setHidden(category, false);
}

Future<void> _showAddCategoryDialog(
  BuildContext context,
  List<Category> existing,
) async {
  final name = await promptCategoryName(
    context,
    title: context.l10n.new_category,
    confirmLabel: context.l10n.add,
    existing: existing,
  );
  if (name == null) return;
  categoryRepository.create(
    Category(
      forItemType: ItemType.anime,
      name: name,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
  );
}
