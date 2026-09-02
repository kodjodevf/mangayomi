enum FilterValueType {
  text(0),
  sort(1),
  check(2),
  select(3),
  multiselect(4),
  range(5);

  const FilterValueType(this.value);
  final int value;

  static FilterValueType fromValue(int val) {
    for (final t in values) {
      if (t.value == val) return t;
    }
    return FilterValueType.text;
  }
}

class SortFilterValue {
  SortFilterValue({
    required this.id,
    required this.index,
    required this.ascending,
  });
  final String id;
  final int index;
  final bool ascending;

  @override
  String toString() =>
      'SortFilterValue(id: $id, index: $index, ascending: $ascending)';
}

/// Sealed class representing a user's selected value for a filter.
sealed class FilterValue {
  const FilterValue();

  String get id;
}

class FilterValueText extends FilterValue {
  const FilterValueText({required this.id, required this.value});
  @override
  final String id;
  final String value;

  @override
  String toString() => 'FilterValueText(id: $id, value: $value)';
}

class FilterValueSort extends FilterValue {
  const FilterValueSort(this.value);
  final SortFilterValue value;
  @override
  String get id => value.id;

  @override
  String toString() => 'FilterValueSort(value: $value)';
}

class FilterValueCheck extends FilterValue {
  const FilterValueCheck({required this.id, required this.value});
  @override
  final String id;
  final int value;

  @override
  String toString() => 'FilterValueCheck(id: $id, value: $value)';
}

class FilterValueSelect extends FilterValue {
  const FilterValueSelect({required this.id, required this.value});
  @override
  final String id;
  final String value;

  @override
  String toString() => 'FilterValueSelect(id: $id, value: $value)';
}

class FilterValueMultiSelect extends FilterValue {
  const FilterValueMultiSelect({
    required this.id,
    this.included = const [],
    this.excluded = const [],
  });
  @override
  final String id;
  final List<String> included;
  final List<String> excluded;

  @override
  String toString() =>
      'FilterValueMultiSelect(id: $id, included: $included, excluded: $excluded)';
}

class FilterValueRange extends FilterValue {
  const FilterValueRange({required this.id, this.from, this.to});
  @override
  final String id;
  final double? from;
  final double? to;

  @override
  String toString() => 'FilterValueRange(id: $id, from: $from, to: $to)';
}
