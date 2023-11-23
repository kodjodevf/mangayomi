class FilterList {
  List<dynamic> filters;
  FilterList(this.filters);
}

class SelectFilter {
  String? type;
  String name;
  int state;
  List<dynamic> values;

  SelectFilter(this.type, this.name, this.state, this.values);
}

class SelectFilterOption {
  String name;
  String value;

  SelectFilterOption(this.name, this.value);
}

class SeparatorFilter {
  String? type;
  SeparatorFilter({this.type = ''});
}

class HeaderFilter {
  String? type;
  String name;
  HeaderFilter(this.name, {this.type = ''});
}

class TextFilter {
  String? type;
  String name;
  String state;

  TextFilter(this.type, this.name, {this.state = ""});
}

class SortFilter {
  String? type;
  String name;
  SortState state;
  List<dynamic> values;

  SortFilter(this.type, this.name, this.state, this.values);
}

class SortState {
  int index;
  bool ascending;

  SortState(this.index, this.ascending);
}

class TriStateFilter {
  String? type;
  String name;
  String value;
  int state;

  factory TriStateFilter.fromJson(Map<String, dynamic> json) {
    return TriStateFilter(json['type'], json['name'], json['value']);
  }
  TriStateFilter(this.type, this.name, this.value, {this.state = 0});
}

extension TriStateFilterExtension on TriStateFilter {
  bool get ignored => state == 0;
  bool get included => state == 1;
  bool get excluded => state == 2;
}

class GroupFilter {
  String? type;
  String name;
  List<dynamic> state;

  GroupFilter(this.type, this.name, this.state);
}

class CheckBoxFilter {
  String? type;
  String name;
  String value;
  bool state;
  factory CheckBoxFilter.fromJson(Map<String, dynamic> json) {
    return CheckBoxFilter(json['type'], json['name'], json['value']);
  }
  CheckBoxFilter(this.type, this.name, this.value, {this.state = false});
}
