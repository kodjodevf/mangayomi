import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/filter.dart';

CheckBoxFilter _checkBox(String name) => CheckBoxFilter(null, name, name, null);
TriStateFilter _triState(String name) => TriStateFilter(null, name, name, null);
SelectFilterOption _option(String name) => SelectFilterOption(name, name, null);

void main() {
  group('selectGenreFilter', () {
    test('ticks a checkbox in a group, whatever its case', () {
      final action = _checkBox('Action');
      final drama = _checkBox('Drama');
      final filters = [
        GroupFilter(null, 'Genres', [drama, action], null),
      ];

      expect(selectGenreFilter(filters, ' action '), isTrue);
      expect(action.state, isTrue);
      expect(drama.state, isFalse);
    });

    test('includes a tri-state in a group', () {
      final action = _triState('Action');
      final filters = [
        GroupFilter(null, 'Genres', [action], null),
      ];

      expect(selectGenreFilter(filters, 'Action'), isTrue);
      expect(action.state, 1);
    });

    test('picks the option of a list', () {
      final list = SelectFilter(null, 'Genre', 0, [
        _option('All'),
        _option('Action'),
      ], null);

      expect(selectGenreFilter([list], 'Action'), isTrue);
      expect(list.state, 1);
    });

    test('stops at the first filter with that name', () {
      final first = _checkBox('Action');
      final second = _checkBox('Action');
      final filters = [
        GroupFilter(null, 'Include', [first], null),
        GroupFilter(null, 'Also', [second], null),
      ];

      expect(selectGenreFilter(filters, 'Action'), isTrue);
      expect(first.state, isTrue);
      expect(second.state, isFalse);
    });

    test('changes nothing when no filter has that name', () {
      final drama = _checkBox('Drama');
      final list = SelectFilter(null, 'Genre', 0, [_option('All')], null);
      final filters = [
        GroupFilter(null, 'Genres', [drama], null),
        list,
      ];

      expect(selectGenreFilter(filters, 'Action'), isFalse);
      expect(drama.state, isFalse);
      expect(list.state, 0);
    });

    test('a checkbox outside a group is not a genre', () {
      final adult = _checkBox('Adult');
      expect(selectGenreFilter([adult], 'Adult'), isFalse);
      expect(adult.state, isFalse);
    });

    test('a source with no filters and a blank genre match nothing', () {
      expect(selectGenreFilter([], 'Action'), isFalse);
      expect(
        selectGenreFilter([
          GroupFilter(null, 'Genres', [_checkBox('')], null),
        ], '  '),
        isFalse,
      );
    });
  });
}
