import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

class SortDefault {
  SortDefault({required this.index, this.ascending = false});
  final int index;
  final bool ascending;

  factory SortDefault.fromPostcard(PostcardReader reader) {
    final index = reader.readI64();
    final ascending = reader.readOption((r) => r.readBool()) ?? false;
    return SortDefault(index: index, ascending: ascending);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeI64(index);
    writer.writeOption(ascending, (w, b) => w.writeBool(b));
  }
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

  factory SelectFilter.fromPostcard(PostcardReader reader) {
    final isGenre = reader.readOption((r) => r.readBool()) ?? false;
    final usesTagStyle = reader.readOption((r) => r.readBool()) ?? isGenre;
    final options = reader.readList((r) => r.readString());
    final ids = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final defaultValue = reader.readOption((r) => r.readString());

    return SelectFilter(
      isGenre: isGenre,
      usesTagStyle: usesTagStyle,
      options: options,
      ids: ids,
      defaultValue: defaultValue,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(isGenre, (w, b) => w.writeBool(b));
    writer.writeOption(usesTagStyle, (w, b) => w.writeBool(b));
    writer.writeList(options, (w, s) => w.writeString(s));
    writer.writeOption(ids, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(defaultValue, (w, s) => w.writeString(s));
  }
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

  factory MultiSelectFilter.fromPostcard(PostcardReader reader) {
    final isGenre = reader.readOption((r) => r.readBool()) ?? false;
    final canExclude = reader.readOption((r) => r.readBool()) ?? false;
    final usesTagStyle = reader.readOption((r) => r.readBool()) ?? isGenre;
    final options = reader.readList((r) => r.readString());
    final ids = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final defaultIncluded = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final defaultExcluded = reader.readOption((r) => r.readList((r2) => r2.readString()));

    return MultiSelectFilter(
      isGenre: isGenre,
      canExclude: canExclude,
      usesTagStyle: usesTagStyle,
      options: options,
      ids: ids,
      defaultIncluded: defaultIncluded,
      defaultExcluded: defaultExcluded,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(isGenre, (w, b) => w.writeBool(b));
    writer.writeOption(canExclude, (w, b) => w.writeBool(b));
    writer.writeOption(usesTagStyle, (w, b) => w.writeBool(b));
    writer.writeList(options, (w, s) => w.writeString(s));
    writer.writeOption(ids, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(defaultIncluded, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(defaultExcluded, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
  }
}

sealed class FilterTypeConfig {
  const FilterTypeConfig();
  void toPostcard(PostcardWriter writer);
}

class FilterTypeText extends FilterTypeConfig {
  const FilterTypeText({this.placeholder});
  final String? placeholder;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("text");
    writer.writeOption(placeholder, (w, s) => w.writeString(s));
  }
}

class FilterTypeSort extends FilterTypeConfig {
  const FilterTypeSort({this.canAscend = true, required this.options, this.defaultValue});
  final bool canAscend;
  final List<String> options;
  final SortDefault? defaultValue;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("sort");
    writer.writeOption(canAscend, (w, b) => w.writeBool(b));
    writer.writeList(options, (w, s) => w.writeString(s));
    writer.writeOption(defaultValue, (w, v) => v.toPostcard(w));
  }
}

class FilterTypeCheck extends FilterTypeConfig {
  const FilterTypeCheck({this.name, this.canExclude = false, this.defaultValue});
  final String? name;
  final bool canExclude;
  final bool? defaultValue;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("check");
    writer.writeOption(name, (w, s) => w.writeString(s));
    writer.writeOption(canExclude, (w, b) => w.writeBool(b));
    writer.writeOption(defaultValue, (w, b) => w.writeBool(b));
  }
}

class FilterTypeSelect extends FilterTypeConfig {
  const FilterTypeSelect(this.filter);
  final SelectFilter filter;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("select");
    filter.toPostcard(writer);
  }
}

class FilterTypeMultiSelect extends FilterTypeConfig {
  const FilterTypeMultiSelect(this.filter);
  final MultiSelectFilter filter;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("multi-select");
    filter.toPostcard(writer);
  }
}

class FilterTypeNote extends FilterTypeConfig {
  const FilterTypeNote(this.text);
  final String text;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("note");
    writer.writeString(text);
  }
}

class FilterTypeRange extends FilterTypeConfig {
  const FilterTypeRange({this.min, this.max, this.decimal = false});
  final double? min;
  final double? max;
  final bool decimal;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString("range");
    writer.writeOption(min, (w, v) => w.writeF32(v));
    writer.writeOption(max, (w, v) => w.writeF32(v));
    writer.writeOption(decimal, (w, b) => w.writeBool(b));
  }
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
    final type = (json['type'] as String?) ?? 'text';
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
        final options = (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final rawDef = json['default'] as Map<String, dynamic>?;
        final defVal = rawDef != null
            ? SortDefault(
                index: (rawDef['index'] as num?)?.toInt() ?? 0,
                ascending: (rawDef['ascending'] as bool?) ?? false,
              )
            : null;
        cfg = FilterTypeSort(canAscend: canAscend, options: options, defaultValue: defVal);
        break;
      case 'check':
        final name = json['name'] as String?;
        final canExclude = (json['canExclude'] as bool?) ?? false;
        final defVal = json['default'] as bool?;
        cfg = FilterTypeCheck(name: name, canExclude: canExclude, defaultValue: defVal);
        break;
      case 'select':
        final isGenre = (json['isGenre'] as bool?) ?? false;
        final usesTagStyle = json['usesTagStyle'] as bool?;
        final options = (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final ids = (json['ids'] as List?)?.map((e) => e.toString()).toList();
        final defVal = json['default']?.toString();
        cfg = FilterTypeSelect(SelectFilter(
          isGenre: isGenre,
          usesTagStyle: usesTagStyle,
          options: options,
          ids: ids,
          defaultValue: defVal,
        ));
        break;
      case 'multi-select':
        final isGenre = (json['isGenre'] as bool?) ?? false;
        final canExclude = (json['canExclude'] as bool?) ?? false;
        final usesTagStyle = json['usesTagStyle'] as bool?;
        final options = (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final ids = (json['ids'] as List?)?.map((e) => e.toString()).toList();
        final rawDef = json['default'];
        final defaultIncluded = rawDef is List ? rawDef.map((e) => e.toString()).toList() : null;
        cfg = FilterTypeMultiSelect(MultiSelectFilter(
          isGenre: isGenre,
          canExclude: canExclude,
          usesTagStyle: usesTagStyle,
          options: options,
          ids: ids,
          defaultIncluded: defaultIncluded,
        ));
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
        cfg = FilterTypeText();
    }

    return Filter(
      id: id ?? title ?? type,
      title: title,
      hideFromHeader: hideFromHeader,
      config: cfg,
    );
  }

  factory Filter.fromPostcard(PostcardReader reader) {
    final id = reader.readOption((r) => r.readString());
    final title = reader.readOption((r) => r.readString());
    final hideFromHeader = reader.readOption((r) => r.readBool());
    final type = reader.readString();

    final FilterTypeConfig cfg;
    switch (type) {
      case 'text':
        final placeholder = reader.readOption((r) => r.readString());
        cfg = FilterTypeText(placeholder: placeholder);
        break;
      case 'sort':
        final canAscend = reader.readOption((r) => r.readBool()) ?? true;
        final options = reader.readList((r) => r.readString());
        final defVal = reader.readOption((r) => SortDefault.fromPostcard(r));
        cfg = FilterTypeSort(canAscend: canAscend, options: options, defaultValue: defVal);
        break;
      case 'check':
        final name = reader.readOption((r) => r.readString());
        final canExclude = reader.readOption((r) => r.readBool()) ?? false;
        final defVal = reader.readOption((r) => r.readBool());
        cfg = FilterTypeCheck(name: name, canExclude: canExclude, defaultValue: defVal);
        break;
      case 'select':
        cfg = FilterTypeSelect(SelectFilter.fromPostcard(reader));
        break;
      case 'multi-select':
        cfg = FilterTypeMultiSelect(MultiSelectFilter.fromPostcard(reader));
        break;
      case 'note':
        final text = reader.readString();
        cfg = FilterTypeNote(text);
        break;
      case 'range':
        final min = reader.readOption((r) => r.readF32());
        final max = reader.readOption((r) => r.readF32());
        final decimal = reader.readOption((r) => r.readBool()) ?? false;
        cfg = FilterTypeRange(min: min, max: max, decimal: decimal);
        break;
      default:
        throw FormatException('Unknown Filter type: $type');
    }

    return Filter(
      id: id ?? title ?? type,
      title: title,
      hideFromHeader: hideFromHeader,
      config: cfg,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(id, (w, s) => w.writeString(s));
    writer.writeOption(title, (w, s) => w.writeString(s));
    writer.writeOption(hideFromHeader, (w, b) => w.writeBool(b));
    config.toPostcard(writer);
  }
}
