import 'package:mangayomi/models/source.dart';

Source get japscanSource => _japscanSource;

Source _japscanSource = Source(
    sourceName: "Japscan",
    baseUrl: "https://japscan.lol",
    lang: "fr",
    typeSource: TypeSource.single,
    logoUrl: '',
    isCloudflare: true,
    dateFormat: "d MMM yyyy",
    dateFormatLocale: "en_US");
