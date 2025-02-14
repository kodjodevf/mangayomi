import 'package:isar/isar.dart';
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

  ChangedPart(
      {this.id = Isar.autoIncrement,
      required this.actionType,
      this.isarId,
      required this.data,
      required this.clientDate});

  Map<String, dynamic> toJson() => {
        'action': actionType.name,
        'isarId': isarId,
        'data': data,
        'clientDate': clientDate
      };
}

enum ActionType {
  addItem(name: "ADD_ITEM"),
  removeItem(name: "REMOVE_ITEM"),
  updateItem(name: "UPDATE_ITEM"),
  addCategory(name: "ADD_CATEGORY"),
  removeCategory(name: "REMOVE_CATEGORY"),
  renameCategory(name: "RENAME_CATEGORY"),
  addChapter(name: "ADD_CHAPTER"),
  removeChapter(name: "REMOVE_CHAPTER"),
  updateChapter(name: "UPDATE_CHAPTER"),
  clearHistory(name: "CLEAR_HISTORY"),
  addHistory(name: "ADD_HISTORY"),
  removeHistory(name: "REMOVE_HISTORY"),
  updateHistory(name: "UPDATE_HISTORY"),
  clearUpdates(name: "CLEAR_UPDATES"),
  addUpdate(name: "ADD_UPDATE"),
  clearExtension(name: "CLEAR_EXTENSION"),
  addExtension(name: "ADD_EXTENSION"),
  removeExtension(name: "REMOVE_EXTENSION"),
  updateExtension(name: "UPDATE_EXTENSION"),
  addTrack(name: "ADD_TRACK"),
  removeTrack(name: "REMOVE_TRACK"),
  updateTrack(name: "UPDATE_TRACK");

  final String name;

  const ActionType({required this.name});
}
