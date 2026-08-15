// ignore_for_file: implementation_imports


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
  List<T> _sortedElements = [];
  List<E> _groupKeys = [];
  bool _needsPrepare = true;

  @override
  void didUpdateWidget(covariant CustomSliverGroupedListView<T, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.elements, widget.elements) ||
        oldWidget.sort != widget.sort ||
        oldWidget.order != widget.order) {
      _needsPrepare = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prepared lazily here (not in initState) because groupBy closures may
    // look up inherited widgets, and memoized so a rebuild without a new
    // elements list never re-sorts.
    if (_needsPrepare) {
      _needsPrepare = false;
      _prepareElements();
    }
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

          if (index == 0) {
            return _buildGroupSeparator(actualIndex);
          }
          if (isSeparator(index)) {
            if (_groupKeys[actualIndex] != _groupKeys[actualIndex - 1]) {
              return _buildGroupSeparator(actualIndex);
            }
            return widget.separator;
          }
          return widget.indexedItemBuilder == null
              ? widget.itemBuilder!(context, _sortedElements[actualIndex])
              : widget.indexedItemBuilder!(
                  context,
                  _sortedElements[actualIndex],
                  actualIndex,
                );
        },
      ),
    );
  }

  /// Computes the group key once per element (groupBy may be expensive, e.g.
  /// date formatting), then sorts on the cached keys.
  void _prepareElements() {
    var decorated = [
      for (final element in widget.elements) (element, widget.groupBy(element)),
    ];
    if (widget.sort && decorated.isNotEmpty) {
      decorated.sort((a, b) {
        int? compareResult;
        // compare groups
        if (widget.groupComparator != null) {
          compareResult = widget.groupComparator!(a.$2, b.$2);
        } else if (a.$2 is Comparable) {
          compareResult = (a.$2 as Comparable).compareTo(b.$2 as Comparable);
        }
        // compare elements inside group
        if (compareResult == null || compareResult == 0) {
          if (widget.itemComparator != null) {
            compareResult = widget.itemComparator!(a.$1, b.$1);
          } else if (a.$1 is Comparable) {
            compareResult = (a.$1 as Comparable).compareTo(b.$1);
          }
        }
        return compareResult!;
      });
      if (widget.order == GroupedListOrder.DESC) {
        decorated = decorated.reversed.toList();
      }
    }
    _sortedElements = [for (final d in decorated) d.$1];
    _groupKeys = [for (final d in decorated) d.$2];
  }

  Widget _buildGroupSeparator(int actualIndex) {
    if (widget.groupHeaderBuilder == null) {
      return widget.groupSeparatorBuilder!(_groupKeys[actualIndex]);
    }
    return widget.groupHeaderBuilder!(_sortedElements[actualIndex]);
  }
}
