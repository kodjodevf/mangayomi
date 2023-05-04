import 'package:isar/isar.dart';
part 'categories.g.dart';

@collection
@Name("Category")
class CategoriesModel {
  Id? id;
  String? name;
  CategoriesModel({
    this.id = Isar.autoIncrement,
    required this.name,
  });
}
