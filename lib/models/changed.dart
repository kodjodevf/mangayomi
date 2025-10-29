import 'package:isar_community/isar.dart';
part 'changed.g.dart';

@collection
@Name("ChangedPart")
class ChangedPart {
  Id? id;
  @enumerated
  late ActionType actionType;
  int? isarId;
  String data;
  int clientDate;

  ChangedPart({
    this.id = Isar.autoIncrement,
    required this.actionType,
    this.isarId,
    required this.data,
    required this.clientDate,
  });

  Map<String, dynamic> toJson() => {
    'action': actionType.name,
    'isarId': isarId,
    'data': data,
    'clientDate': clientDate,
  };
}

enum ActionType {
  removeItem,
  removeCategory,
  removeChapter,
  removeHistory,
  removeUpdate,
  removeExtension,
  removeTrack,
}
