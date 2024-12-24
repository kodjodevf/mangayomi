import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'category.g.dart';

@collection
@Name("Category")
class Category {
  Id? id;
  String? name;
  bool? forManga;
  @enumerated
  late ItemType forItemType;
  Category(
      {this.id = Isar.autoIncrement,
      required this.name,
      this.forManga = true,
      required this.forItemType});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    forItemType = ItemType.values[json['forItemType'] ?? 0];
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

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'forItemType': forItemType.index};
}
