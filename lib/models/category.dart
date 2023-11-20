import 'package:isar/isar.dart';
part 'category.g.dart';

@collection
@Name("Category")
class Category {
  Id? id;
  String? name;
  bool? forManga;
  Category(
      {this.id = Isar.autoIncrement,
      required this.name,
      required this.forManga});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    forManga = json['forManga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['forManga'] = forManga;

    return data;
  }
}
