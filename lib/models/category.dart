import 'package:isar/isar.dart';
part 'category.g.dart';

@collection
@Name("Category")
class Category {
  Id? id;
  String? name;
  Category({
    this.id = Isar.autoIncrement,
    required this.name,
  });
}
