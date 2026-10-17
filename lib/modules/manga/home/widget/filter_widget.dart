import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// The inside of a filters sheet: Reset and Filter above the filters.
///
/// As tall as the filters, up to what the sheet allows; it grows smoothly
/// as a group opens. It used to hold three quarters of the screen whatever
/// the source's few filters, to keep from jumping.
class FilterSheetBody extends StatelessWidget {
  const FilterSheetBody({
    super.key,
    required this.filters,
    required this.onChanged,
    required this.onReset,
    required this.onApply,
    required this.resetLabel,
    required this.applyLabel,
  });

  final List<dynamic> filters;
  final Function(List<dynamic>) onChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final String resetLabel;
  final String applyLabel;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: ShioriMotion.of(context, ShioriMotion.standard),
      curve: ShioriMotion.standardCurve,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ShioriSpace.s16,
              vertical: ShioriSpace.s8,
            ),
            child: Row(
              children: [
                ShioriButton.quiet(
                  icon: Symbols.restart_alt_rounded,
                  label: resetLabel,
                  onPressed: onReset,
                ),
                const Spacer(),
                ShioriButton(
                  icon: Symbols.filter_list_rounded,
                  label: applyLabel,
                  onPressed: onApply,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: FilterWidget(filterList: filters, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

/// A source's filters, as the extension declares them: text, a box to tick
/// or to cycle through include and exclude, groups, a sort, one value of a
/// list.
///
/// Built from the same rows as a series' chapter filters, so "excluded" is
/// the same cross on both, and a sort is the same accent label and arrow.
class FilterWidget extends StatelessWidget {
  final List<dynamic> filterList;
  final Function(List<dynamic>) onChanged;
  const FilterWidget({
    super.key,
    required this.onChanged,
    required this.filterList,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return SuperListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filterList.length,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, idx) {
        final filterState = filterList[idx];
        Widget? widget;
        if (filterState is TextFilter) {
          widget = SeachFormTextFieldWidget(
            text: filterState.state,
            onChanged: (val) {
              filterList[idx] = filterState..state = val;
              onChanged(filterList);
            },
            labelText: filterState.name,
          );
        } else if (filterState is HeaderFilter) {
          widget = Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s16,
              ShioriSpace.s16,
              ShioriSpace.s4,
            ),
            child: ShioriGroupLabel(filterState.name, maxLines: 2),
          );
        } else if (filterState is SeparatorFilter) {
          widget = const Divider(height: ShioriSpace.s16);
        } else if (filterState is TriStateFilter) {
          // Off, only these, all but these, and round again.
          widget = ListTileChapterFilter(
            label: filterState.name,
            type: filterState.state,
            onTap: () {
              filterList[idx] = filterState
                ..state = (filterState.state + 1) % 3;
              onChanged(filterList);
            },
          );
        } else if (filterState is CheckBoxFilter) {
          widget = ListTileChapterFilter(
            label: filterState.name,
            type: filterState.state ? 1 : 0,
            onTap: () {
              filterList[idx] = filterState..state = !filterState.state;
              onChanged(filterList);
            },
          );
        } else if (filterState is GroupFilter) {
          widget = ExpansionTile(
            title: Text(
              filterState.name,
              style: tokens.text.row.copyWith(color: tokens.color.fg),
            ),
            children: [
              FilterWidget(
                filterList: filterState.state,
                onChanged: (values) {
                  filterState.state = values;
                  onChanged(filterList);
                },
              ),
            ],
          );
        } else if (filterState is SortFilter) {
          final ascending = filterState.state.ascending;
          widget = ExpansionTile(
            title: Text(
              filterState.name,
              style: tokens.text.row.copyWith(color: tokens.color.fg),
            ),
            children: [
              for (final (i, e) in filterState.values.indexed)
                ListTileChapterSort(
                  label: e.name,
                  // An upward arrow is ascending.
                  reverse: ascending,
                  showLeading: filterState.state.index == i,
                  onTap: () {
                    if (filterState.state.index == i) {
                      filterState.state.ascending = !ascending;
                    } else {
                      filterState.state.index = i;
                    }
                    filterList[idx] = filterState;
                    onChanged(filterList);
                  },
                ),
            ],
          );
        } else if (filterState is SelectFilter) {
          widget = ShioriValueRow<int>(
            title: filterState.name,
            value: filterState.state,
            options: [
              for (final (i, e) in filterState.values.indexed)
                ShioriChoice(i, e.name as String),
            ],
            // A long list (genres, years) gets a search field.
            searchHint: filterState.values.length > 10
                ? MaterialLocalizations.of(context).searchFieldLabel
                : null,
            onChanged: (i) {
              filterState.state = i;
              onChanged(filterList);
            },
          );
        }
        return widget ?? const SizedBox.shrink();
      },
    );
  }
}

class SeachFormTextFieldWidget extends StatefulWidget {
  final String labelText;
  final String text;
  final Function(String) onChanged;
  const SeachFormTextFieldWidget({
    super.key,
    required this.text,
    required this.onChanged,
    required this.labelText,
  });

  @override
  State<SeachFormTextFieldWidget> createState() =>
      _SeachFormTextFieldWidgetState();
}

class _SeachFormTextFieldWidgetState extends State<SeachFormTextFieldWidget> {
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final _controller = TextEditingController(text: widget.text);
  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      _controller.clear();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s8,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(labelText: widget.labelText),
      ),
    );
  }
}
