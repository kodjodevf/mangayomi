import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'category.g.dart';

@collection
@Name("Category")
class Category {
  Id? id;
  String? name;
  bool? forManga;
  int? pos;
  bool? hide;
  bool? shouldUpdate;
  @enumerated
  late ItemType forItemType;
  int? updatedAt;

  Category({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.forItemType,
    this.pos,
    this.hide,
    this.shouldUpdate,
    this.updatedAt = 0,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    forItemType = ItemType.values[json['forItemType'] ?? 0];
    pos = json['pos'];
    hide = json['hide'];
    shouldUpdate = json['shouldUpdate'];
    updatedAt = json['updatedAt'];
  }

  Category.fromJsonV1(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    forItemType = json['forManga'] is bool
        ? json['forManga'] == true
              ? ItemType.manga
              : ItemType.anime
        : ItemType.manga;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'forItemType': forItemType.index,
    'pos': pos,
    'hide': hide,
    'shouldUpdate': shouldUpdate,
    'updatedAt': updatedAt ?? 0,
  };
}
