import 'dart:developer';

import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'library_state_provider.g.dart';

@riverpod
class LibraryReverseListState extends _$LibraryReverseListState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettings)
        .get('libraryReverseList', defaultValue: false)!;
  }

  void setLibraryReverseList(bool value) {
    state = value;
    ref.watch(hiveBoxSettings).put('libraryReverseList', value);
  }
}

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  String build() {
    return ref
        .watch(hiveBoxSettings)
        .get('displayType', defaultValue: DisplayType.coverOnlyGrid.name)!;
  }

  DisplayType getLibraryDisplayTypeValue(String value) {
    return value == DisplayType.compactGrid.name
        ? DisplayType.compactGrid
        : value == DisplayType.list.name
            ? DisplayType.list
            : DisplayType.coverOnlyGrid;
  }

  String getLibraryDisplayTypeName(String displayType) {
    return displayType == DisplayType.compactGrid.name
        ? 'Compact drid'
        : displayType == DisplayType.list.name
            ? 'List'
            : 'Cover Only Grid';
  }

  void setLibraryDisplayType(DisplayType displayType) {
    log(displayType.name);
    state = displayType.name;
    ref.watch(hiveBoxSettings).put('displayType', displayType.name);
  }
}

enum DisplayType {
  compactGrid,
  list,
  coverOnlyGrid,
}
