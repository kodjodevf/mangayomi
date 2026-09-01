import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

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
  SortFilterValue({required this.id, required this.index, required this.ascending});
  final String id;
  final int index;
  final bool ascending;

  @override
  String toString() => 'SortFilterValue(id: $id, index: $index, ascending: $ascending)';
}

/// Sealed class representing a user's selected value for a filter.
sealed class FilterValue {
  const FilterValue();

  String get id;

  factory FilterValue.fromPostcard(PostcardReader reader) {
    final typeVal = reader.readU8();
    final type = FilterValueType.fromValue(typeVal);
    switch (type) {
      case FilterValueType.text:
        final id = reader.readString();
        final val = reader.readString();
        return FilterValueText(id: id, value: val);
      case FilterValueType.sort:
        final id = reader.readString();
        final index = reader.readI32();
        final ascending = reader.readBool();
        return FilterValueSort(SortFilterValue(id: id, index: index, ascending: ascending));
      case FilterValueType.check:
        final id = reader.readString();
        final val = reader.readI64();
        return FilterValueCheck(id: id, value: val);
      case FilterValueType.select:
        final id = reader.readString();
        final val = reader.readString();
        return FilterValueSelect(id: id, value: val);
      case FilterValueType.multiselect:
        final id = reader.readString();
        final included = reader.readList((r) => r.readString());
        final excluded = reader.readList((r) => r.readString());
        return FilterValueMultiSelect(id: id, included: included, excluded: excluded);
      case FilterValueType.range:
        final id = reader.readString();
        final from = reader.readOption((r) => r.readF32());
        final to = reader.readOption((r) => r.readF32());
        return FilterValueRange(id: id, from: from, to: to);
    }
  }

  void toPostcard(PostcardWriter writer);
}

class FilterValueText extends FilterValue {
  const FilterValueText({required this.id, required this.value});
  @override
  final String id;
  final String value;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.text.value);
    writer.writeString(id);
    writer.writeString(value);
  }

  @override
  String toString() => 'FilterValueText(id: $id, value: $value)';
}

class FilterValueSort extends FilterValue {
  const FilterValueSort(this.value);
  final SortFilterValue value;
  @override
  String get id => value.id;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.sort.value);
    writer.writeString(value.id);
    writer.writeI32(value.index);
    writer.writeBool(value.ascending);
  }

  @override
  String toString() => 'FilterValueSort($value)';
}

class FilterValueCheck extends FilterValue {
  const FilterValueCheck({required this.id, required this.value});
  @override
  final String id;
  final int value;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.check.value);
    writer.writeString(id);
    writer.writeI64(value);
  }

  @override
  String toString() => 'FilterValueCheck(id: $id, value: $value)';
}

class FilterValueSelect extends FilterValue {
  const FilterValueSelect({required this.id, required this.value});
  @override
  final String id;
  final String value;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.select.value);
    writer.writeString(id);
    writer.writeString(value);
  }

  @override
  String toString() => 'FilterValueSelect(id: $id, value: $value)';
}

class FilterValueMultiSelect extends FilterValue {
  const FilterValueMultiSelect({
    required this.id,
    required this.included,
    required this.excluded,
  });
  @override
  final String id;
  final List<String> included;
  final List<String> excluded;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.multiselect.value);
    writer.writeString(id);
    writer.writeList(included, (w, s) => w.writeString(s));
    writer.writeList(excluded, (w, s) => w.writeString(s));
  }

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
  void toPostcard(PostcardWriter writer) {
    writer.writeU8(FilterValueType.range.value);
    writer.writeString(id);
    writer.writeOption(from, (w, v) => w.writeF32(v));
    writer.writeOption(to, (w, v) => w.writeF32(v));
  }

  @override
  String toString() => 'FilterValueRange(id: $id, from: $from, to: $to)';
}
