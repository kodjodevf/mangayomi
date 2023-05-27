import 'package:mangayomi/models/manga.dart';

Status mmrcmsStatusParser(String status) {
  return completedStatusList.contains(status)
      ? Status.completed
      : ongoingStatusList.contains(status)
          ? Status.ongoing
          : Status.unknown;
}

List<String> completedStatusList = [
  "complete",
  "مكتملة",
  "complet",
  "completo",
  "zakończone",
  "concluído"
];
List<String> ongoingStatusList = [
  "ongoing",
  "مستمرة",
  "en cours",
  "em lançamento",
  "prace w toku",
  "ativo",
  "em andamento"
];
