class SortDefault {
  SortDefault({required this.index, this.ascending = false});
  final int index;
  final bool ascending;
}

class SelectFilter {
  SelectFilter({
    this.isGenre = false,
    bool? usesTagStyle,
    required this.options,
    this.ids,
    this.defaultValue,
  }) : usesTagStyle = usesTagStyle ?? isGenre;

  final bool isGenre;
  final bool usesTagStyle;
  final List<String> options;
  final List<String>? ids;
  final String? defaultValue;
}

class MultiSelectFilter {
  MultiSelectFilter({
    this.isGenre = false,
    this.canExclude = false,
    bool? usesTagStyle,
    required this.options,
    this.ids,
    this.defaultIncluded,
    this.defaultExcluded,
  }) : usesTagStyle = usesTagStyle ?? isGenre;

  final bool isGenre;
  final bool canExclude;
  final bool usesTagStyle;
  final List<String> options;
  final List<String>? ids;
  final List<String>? defaultIncluded;
  final List<String>? defaultExcluded;
}

sealed class FilterTypeConfig {
  const FilterTypeConfig();
}

class FilterTypeText extends FilterTypeConfig {
  const FilterTypeText({this.placeholder});
  final String? placeholder;
}

class FilterTypeSort extends FilterTypeConfig {
  const FilterTypeSort({
    this.canAscend = true,
    required this.options,
    this.defaultValue,
  });
  final bool canAscend;
  final List<String> options;
  final SortDefault? defaultValue;
}

class FilterTypeCheck extends FilterTypeConfig {
  const FilterTypeCheck({
    this.name,
    this.canExclude = false,
    this.defaultValue,
  });
  final String? name;
  final bool canExclude;
  final bool? defaultValue;
}

class FilterTypeSelect extends FilterTypeConfig {
  const FilterTypeSelect(this.filter);
  final SelectFilter filter;
}

class FilterTypeMultiSelect extends FilterTypeConfig {
  const FilterTypeMultiSelect(this.filter);
  final MultiSelectFilter filter;
}

class FilterTypeNote extends FilterTypeConfig {
  const FilterTypeNote(this.text);
  final String text;
}

class FilterTypeRange extends FilterTypeConfig {
  const FilterTypeRange({this.min, this.max, this.decimal = false});
  final double? min;
  final double? max;
  final bool decimal;
}

class Filter {
  Filter({
    required this.id,
    this.title,
    this.hideFromHeader,
    required this.config,
  });

  String id;
  String? title;
  bool? hideFromHeader;
  FilterTypeConfig config;

  factory Filter.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'text';
    final id = json['id'] as String?;
    final title = json['title'] as String?;
    final hideFromHeader = json['hideFromHeader'] as bool?;

    final FilterTypeConfig cfg;
    switch (type) {
      case 'text':
        final placeholder = json['placeholder'] as String?;
        cfg = FilterTypeText(placeholder: placeholder);
        break;
      case 'sort':
        final canAscend = (json['canAscend'] as bool?) ?? true;
        final options =
            (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        SortDefault? def;
        if (json['default'] is Map) {
          final defMap = json['default'] as Map<String, dynamic>;
          def = SortDefault(
            index: (defMap['index'] as num?)?.toInt() ?? 0,
            ascending: (defMap['ascending'] as bool?) ?? false,
          );
        }
        cfg = FilterTypeSort(
          canAscend: canAscend,
          options: options,
          defaultValue: def,
        );
        break;
      case 'check':
        final name = json['name'] as String?;
        final canExclude = (json['canExclude'] as bool?) ?? false;
        final defVal = json['default'] as bool?;
        cfg = FilterTypeCheck(
          name: name,
          canExclude: canExclude,
          defaultValue: defVal,
        );
        break;
      case 'select':
        final isGenre = (json['isGenre'] as bool?) ?? false;
        final usesTagStyle = json['usesTagStyle'] as bool?;
        final options =
            (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final ids = (json['ids'] as List?)?.map((e) => e.toString()).toList();
        final defVal = json['default']?.toString();
        cfg = FilterTypeSelect(
          SelectFilter(
            isGenre: isGenre,
            usesTagStyle: usesTagStyle,
            options: options,
            ids: ids,
            defaultValue: defVal,
          ),
        );
        break;
      case 'multi-select':
        final isGenre = (json['isGenre'] as bool?) ?? false;
        final canExclude = (json['canExclude'] as bool?) ?? false;
        final usesTagStyle = json['usesTagStyle'] as bool?;
        final options =
            (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final ids = (json['ids'] as List?)?.map((e) => e.toString()).toList();
        final rawDef = json['default'];
        final defaultIncluded = rawDef is List
            ? rawDef.map((e) => e.toString()).toList()
            : null;
        cfg = FilterTypeMultiSelect(
          MultiSelectFilter(
            isGenre: isGenre,
            canExclude: canExclude,
            usesTagStyle: usesTagStyle,
            options: options,
            ids: ids,
            defaultIncluded: defaultIncluded,
          ),
        );
        break;
      case 'note':
        final text = (json['text'] as String?) ?? '';
        cfg = FilterTypeNote(text);
        break;
      case 'range':
        final min = (json['min'] as num?)?.toDouble();
        final max = (json['max'] as num?)?.toDouble();
        final decimal = (json['decimal'] as bool?) ?? false;
        cfg = FilterTypeRange(min: min, max: max, decimal: decimal);
        break;
      default:
        cfg = const FilterTypeText();
    }

    return Filter(
      id: id ?? title ?? type,
      title: title,
      hideFromHeader: hideFromHeader,
      config: cfg,
    );
  }
}
