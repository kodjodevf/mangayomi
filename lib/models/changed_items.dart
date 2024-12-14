import 'package:isar/isar.dart';
part 'changed_items.g.dart';

@collection
@Name("Changed Items")
class ChangedItems {
  Id? id;
  List<DeletedManga>? deletedMangas;
  List<UpdatedChapter>? updatedChapters;
  List<DeletedCategory>? deletedCategories;
  ChangedItems(
      {this.id = Isar.autoIncrement,
      this.deletedMangas = const [],
      this.updatedChapters = const [],
      this.deletedCategories = const []});

  ChangedItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deletedMangas = json['deletedMangas'];
    updatedChapters = json['updatedChapters'];
    deletedCategories = json['deletedCategories'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deletedMangas': deletedMangas,
        'updatedChapters': updatedChapters,
        'deletedCategories': deletedCategories
      };
}

@embedded
class DeletedManga {
  int? mangaId;
  DeletedManga({this.mangaId});
  DeletedManga.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
  }

  Map<String, dynamic> toJson() => {'mangaId': mangaId};
}

@embedded
class UpdatedChapter {
  int? chapterId;
  int? mangaId;
  bool? isBookmarked;
  bool? isRead;
  String? lastPageRead;
  bool? deleted;
  UpdatedChapter({this.chapterId, this.mangaId, this.isBookmarked, this.isRead, this.lastPageRead, this.deleted});
  UpdatedChapter.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    mangaId = json['mangaId'];
    isBookmarked = json['isBookmarked'];
    isRead = json['isRead'];
    lastPageRead = json['lastPageRead'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'mangaId': mangaId,
        'isBookmarked': isBookmarked,
        'isRead': isRead,
        'lastPageRead': lastPageRead,
        'deleted': deleted
      };
}

@embedded
class DeletedCategory {
  int? categoryId;
  DeletedCategory({this.categoryId});
  DeletedCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() => {'categoryId': categoryId};
}
