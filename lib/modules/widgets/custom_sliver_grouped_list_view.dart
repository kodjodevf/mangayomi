// ignore_for_file: implementation_imports

import 'dart:collection';
import 'package:flutter/widgets.dart';

import 'package:grouped_list/src/grouped_list_order.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

export 'package:grouped_list/src/grouped_list_order.dart';

@immutable
class CustomSliverGroupedListView<T, E> extends StatefulWidget {
  /// Items of which [itemBuilder] or [indexedItemBuilder] produce the list.
  final List<T> elements;

  /// Defines which elements are grouped together.
  ///
  /// Function is called for each element in the list, when equal for two
  /// elements, those two belong to the same group.
  final E Function(T element) groupBy;

  /// Can be used to define a custom sorting for the groups.
  ///
  /// If not set groups will be sorted with their natural sorting order or their
  /// specific [Comparable] implementation.
  final int Function(E value1, E value2)? groupComparator;

  /// Can be used to define a custom sorting for the elements inside each group.
  ///
  /// If not set elements will be sorted with their natural sorting order or
  /// their specific [Comparable] implementation.
  final int Function(T element1, T element2)? itemComparator;

  /// Called to build group separators for each group.
  /// Value is always the groupBy result from the first element of the group.
  ///
  /// Will be ignored if [groupHeaderBuilder] is used.
  final Widget Function(E value)? groupSeparatorBuilder;

  /// Same as [groupSeparatorBuilder], will be called to build group separators
  /// for each group.
  /// The passed element is always the first element of the group.
  ///
  /// If defined [groupSeparatorBuilder] wont be used.
  final Widget Function(T element)? groupHeaderBuilder;

  /// Called to build children for the list with
  /// 0 <= element < elements.length.
  final Widget Function(BuildContext context, T element)? itemBuilder;

  /// Called to build children for the list with
  /// 0 <= element, index < elements.length
  final Widget Function(BuildContext context, T element, int index)?
  indexedItemBuilder;

  /// Whether the order of the list is ascending or descending.
  ///
  /// Defaults to ASC.
  final GroupedListOrder order;

  /// Whether the elements will be sorted or not. If not it must be done
  ///  manually.
  ///
  /// Defauts to true.
  final bool sort;

  /// Called to build separators for between each item in the list.
  final Widget separator;

  /// Widget at the end of the list
  final Widget? footer;

  /// Creates a [CustomSliverGroupedListView]
  const CustomSliverGroupedListView({
    super.key,
    required this.elements,
    required this.groupBy,
    this.groupComparator,
    this.groupSeparatorBuilder,
    this.groupHeaderBuilder,
    this.itemBuilder,
    this.indexedItemBuilder,
    this.itemComparator,
    this.order = GroupedListOrder.ASC,
    this.sort = true,
    this.separator = const SizedBox.shrink(),
    this.footer,
  }) : assert(itemBuilder != null || indexedItemBuilder != null),
       assert(groupSeparatorBuilder != null || groupHeaderBuilder != null);

  @override
  State<StatefulWidget> createState() =>
      _CustomSliverGroupedListViewState<T, E>();
}

class _CustomSliverGroupedListViewState<T, E>
    extends State<CustomSliverGroupedListView<T, E>> {
  final LinkedHashMap<String, GlobalKey> _keys = LinkedHashMap();
  List<T> _sortedElements = [];

  @override
  Widget build(BuildContext context) {
    _sortedElements = _sortElements();
    var hiddenIndex = 0;
    isSeparator(int i) => i.isEven;

    return SuperSliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.footer == null
            ? _sortedElements.length * 2
            : (_sortedElements.length * 2) + 1,
        (context, index) {
          var actualIndex = index ~/ 2;

          if (widget.footer != null && index == _sortedElements.length * 2) {
            return widget.footer!;
          }

          if (index == hiddenIndex) {
            return Opacity(
              opacity: 1,
              child: _buildGroupSeparator(_sortedElements[actualIndex]),
            );
          }
          if (isSeparator(index)) {
            var curr = widget.groupBy(_sortedElements[actualIndex]);
            var prev = widget.groupBy(_sortedElements[actualIndex - 1]);
            if (prev != curr) {
              return _buildGroupSeparator(_sortedElements[actualIndex]);
            }
            return widget.separator;
          }
          return _buildItem(context, actualIndex);
        },
      ),
    );
  }

  Container _buildItem(BuildContext context, int actualIndex) {
    var key = GlobalKey();
    _keys['$actualIndex'] = key;
    return Container(
      key: key,
      child: widget.indexedItemBuilder == null
          ? widget.itemBuilder!(context, _sortedElements[actualIndex])
          : widget.indexedItemBuilder!(
              context,
              _sortedElements[actualIndex],
              actualIndex,
            ),
    );
  }

  List<T> _sortElements() {
    var elements = [...widget.elements];
    if (widget.sort && elements.isNotEmpty) {
      elements.sort((e1, e2) {
        int? compareResult;
        // compare groups
        if (widget.groupComparator != null) {
          compareResult = widget.groupComparator!(
            widget.groupBy(e1),
            widget.groupBy(e2),
          );
        } else if (widget.groupBy(e1) is Comparable) {
          compareResult = (widget.groupBy(e1) as Comparable).compareTo(
            widget.groupBy(e2) as Comparable,
          );
        }
        // compare elements inside group
        if (compareResult == null || compareResult == 0) {
          if (widget.itemComparator != null) {
            compareResult = widget.itemComparator!(e1, e2);
          } else if (e1 is Comparable) {
            compareResult = e1.compareTo(e2);
          }
        }
        return compareResult!;
      });
      if (widget.order == GroupedListOrder.DESC) {
        elements = elements.reversed.toList();
      }
    }
    return elements;
  }

  Widget _buildGroupSeparator(T element) {
    if (widget.groupHeaderBuilder == null) {
      return widget.groupSeparatorBuilder!(widget.groupBy(element));
    }
    return widget.groupHeaderBuilder!(element);
  }
}
