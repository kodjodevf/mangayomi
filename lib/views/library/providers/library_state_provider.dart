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
            : value == DisplayType.comfortableGrid.name
                ? DisplayType.comfortableGrid
                : DisplayType.coverOnlyGrid;
  }

  String getLibraryDisplayTypeName(String displayType) {
    return displayType == DisplayType.compactGrid.name
        ? 'Compact grid'
        : displayType == DisplayType.list.name
            ? 'List'
            : displayType == DisplayType.comfortableGrid.name
                ? 'Comfortable grid'
                : 'Cover-only grid';
  }

  void setLibraryDisplayType(DisplayType displayType) {
    state = displayType.name;
    ref.watch(hiveBoxSettings).put('displayType', displayType.name);
  }
}

enum DisplayType {
  compactGrid,
  comfortableGrid,
  coverOnlyGrid,
  list,
}
