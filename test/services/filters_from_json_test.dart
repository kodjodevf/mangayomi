import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

void main() {
  test('malformed select options are skipped instead of throwing', () {
    final filters = filtersFromJson([
      {
        'name': 'Genre',
        'state': 0,
        'values': [
          {'value': 'a'},
          {'other': 'b'},
          null,
          'c',
          3,
        ],
      },
    ]);
    final select = filters.single as SelectFilter;
    expect(select.values.map((o) => o.value), ['a', 'c', '3']);
  });

  test('malformed vals and sort values do not drop the whole list', () {
    final filters = filtersFromJson([
      {
        'name': 'Type',
        'state': 0,
        'vals': [
          {'first': 'x', 'second': 'y'},
          {'first': null, 'second': 'z'},
          null,
        ],
      },
      {
        'name': 'Sort',
        'state': {'index': null, 'ascending': null},
        'values': ['one', null],
      },
    ]);
    expect(filters.length, 2);
    expect((filters[0] as SelectFilter).values.single.value, 'y');
    final sort = filters[1] as SortFilter;
    expect(sort.values.length, 1);
    expect(sort.state.index, 0);
  });
}
