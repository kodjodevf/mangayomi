import 'package:isar/isar.dart';
part 'custom_button.g.dart';

@collection
@Name("CustomButton")
class CustomButton {
  Id? id;

  String? title;

  String? codePress;

  String? codeLongPress;

  String? codeStartup;

  bool? isFavourite;

  int? pos;

  int? updatedAt;

  CustomButton({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.codePress,
    this.codeLongPress = "",
    this.codeStartup = "",
    this.isFavourite = false,
    required this.pos,
    this.updatedAt = 0,
  });

  CustomButton.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    codePress = json['codePress'];
    codeLongPress = json['codeLongPress'];
    codeStartup = json['codeStartup'];
    isFavourite = json['isFavourite'];
    pos = json['pos'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'codePress': codePress,
    'codeLongPress': codeLongPress,
    'codeStartup': codeStartup,
    'isFavourite': isFavourite,
    'pos': pos,
    'updatedAt': updatedAt ?? 0,
  };
}
