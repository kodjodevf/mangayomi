import 'package:mangayomi/models/source.dart';

List<Source> get madaraSourcesList => _madaraSourcesList;
List<Source> _madaraSourcesList = [
  Source(
      sourceName: "FR-Scan",
      baseUrl: "https://fr-scan.com",
      lang: "fr",
      typeSource: TypeSource.madara,
      logoUrl: '',
      dateFormat: "MMMM d, yyyy",
      dateFormatLocale: "fr"),
  Source(
      sourceName: "AstralManga",
      baseUrl: "https://astral-manga.fr",
      lang: "fr",
      typeSource: TypeSource.madara,
      logoUrl: '',
      dateFormat: "dd/mm/yyyy",
      dateFormatLocale: "fr"),
  Source(
      sourceName: "arabtoons",
      baseUrl: "https://arabtoons.net",
      lang: "ar",
      typeSource: TypeSource.madara,
      logoUrl: '',
      dateFormat: "MMM d",
      dateFormatLocale: "ar"),
];
