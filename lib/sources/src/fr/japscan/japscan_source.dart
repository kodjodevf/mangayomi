import 'package:mangayomi/models/source_model.dart';

SourceModel get japscanSource => _japscanSource;

SourceModel _japscanSource = SourceModel(
    sourceName: "Japscan",
    baseUrl: "https://japscan.lol",
    lang: "fr",
    typeSource: TypeSource.single,
    logoUrl: '',
    isCloudflare: true,
    dateFormat: "d MMM yyyy",
    dateFormatLocale: "en_US");
