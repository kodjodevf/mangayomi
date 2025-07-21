import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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
    return SuperListView.builder(
      padding: const EdgeInsets.all(0),
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
          widget = ListTile(dense: true, title: Text(filterState.name));
        } else if (filterState is SeparatorFilter) {
          widget = const Divider();
        } else if (filterState is TriStateFilter) {
          final state = filterState.state;
          widget = CheckboxListTile(
            dense: true,
            value: switch (state) {
              0 => false,
              1 => true,
              _ => null,
            },
            onChanged: (value) {
              filterList[idx] = filterState
                ..state = switch (value) {
                  null => 2,
                  true => 1,
                  _ => 0,
                };
              onChanged(filterList);
            },
            title: Text(filterState.name),
            controlAffinity: ListTileControlAffinity.leading,
            tristate: true,
          );
        } else if (filterState is CheckBoxFilter) {
          widget = CheckboxListTile(
            dense: true,
            value: filterState.state,
            onChanged: (value) {
              filterList[idx] = filterState..state = value!;
              onChanged(filterList);
            },
            title: Text(filterState.name),
            controlAffinity: ListTileControlAffinity.leading,
          );
        } else if (filterState is GroupFilter) {
          widget = ExpansionTile(
            title: Text(filterState.name, style: const TextStyle(fontSize: 13)),
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
            title: Text(filterState.name, style: const TextStyle(fontSize: 13)),
            children: filterState.values.map((e) {
              final selected = filterState.values[filterState.state.index] == e;
              return ListTile(
                dense: true,
                leading: Icon(
                  ascending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: selected ? null : Colors.transparent,
                ),
                title: Text(e.name),
                onTap: () {
                  if (selected) {
                    filterState.state.ascending = !ascending;
                  } else {
                    filterState.state.index = filterState.values.indexWhere(
                      (element) => element == e,
                    );
                  }
                  filterList[idx] = filterState;
                  onChanged(filterList);
                },
              );
            }).toList(),
          );
        } else if (filterState is SelectFilter) {
          widget = SizedBox(
            width: context.width(1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListTile(dense: true, title: Text(filterState.name)),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 25,
                      ),
                      child: DropdownButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        value: filterState.values[filterState.state],
                        hint: Text(
                          filterState.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                        items: filterState.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          filterState.state = filterState.values.indexWhere(
                            (element) => element == value,
                          );
                          onChanged(filterList);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.primaryColor),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide()),
          labelText: widget.labelText,
        ),
      ),
    );
  }
}
