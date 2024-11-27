import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'category.g.dart';

@collection
@Name("Category")
class Category {
  Id? id;
  String? name;
  @enumerated
  late ItemType forItemType;
  Category(
      {this.id = Isar.autoIncrement,
      required this.name,
      required this.forItemType});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    forItemType = json['forItemType'];
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'forItemType': forItemType};
}
