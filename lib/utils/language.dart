import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

/// Explicit language -> country overrides for codes where the "primary
/// subtag" lookup below would pick the wrong flag (e.g. pt-br should show
/// Brazil, not Portugal).
const _languageCountryOverrides = {
  'pt-br': 'BR',
  'zh-hk': 'HK',
  'zh-tw': 'TW',
  'en-us': 'US',
  'en-gb': 'GB',
  'es-419': 'MX',
  'es-la': 'MX',
  'pt-pt': 'PT',
  'nb-no': 'NO',
};

/// A small flag icon for a source/extension language code, or null when no
/// flag makes sense (e.g. "all") or the package has no match for it.
Widget? languageFlag(String lang, {double width = 18, double height = 12}) {
  final normalized = lang.trim().toLowerCase();
  if (normalized.isEmpty || normalized == 'all') return null;

  final theme = ImageTheme(
    width: width,
    height: height,
    shape: const RoundedRectangle(2),
  );

  final countryOverride = _languageCountryOverrides[normalized];
  if (countryOverride != null) {
    return CountryFlag.fromCountryCode(countryOverride, theme: theme);
  }

  // Fall back to the primary subtag (e.g. "es" out of "es-419") so regional
  // variants without an explicit override above still get a flag.
  final primarySubtag = normalized.split('-').first;
  if (FlagCode.fromLanguageCode(primarySubtag) == null) return null;
  return CountryFlag.fromLanguageCode(primarySubtag, theme: theme);
}

String completeLanguageName(String lang) {
  lang = lang.toLowerCase();
  for (var element in languagesMap.entries) {
    if (element.value.toLowerCase() == lang) {
      return element.key;
    }
  }
  return lang.trim().toUpperCase();
}

final languagesMap = {
  'All': 'all',
  'Français': 'fr',
  'Català': 'ca',
  'English': 'en',
  'Tiếng Việt': 'vi',
  'ไทย': 'th',
  'Bulgaria': 'bg',
  'العربية': 'ar',
  'Português': 'pt',
  '한국어': 'ko',
  'Português (Brasil)': 'pt-br',
  'Italiano': 'it',
  'Pусский язык': 'ru',
  'Español': 'es',
  'Español (Latinoamérica)': 'es-419',
  'Español (Latinoamérica) ': 'es-la',
  'Indonesia': 'id',
  'हिन्दी, हिंदी': 'hi',
  '日本語': 'ja',
  'Polski': 'pl',
  'Türkçe': 'tr',
  'Deutsch': 'de',
  '中文(Zhōngwén)': 'zh',
  '繁體中文(Hong Kong)': 'zh-hk',
  "Filipino": "fil",
  "Ελληνικά": "el",
  "dansk": "da",
  "বাংলা": "bn",
  "Afrikaans": "af",
  "አማርኛ": "am",
  "Azərbaycan": "az",
  "беларуская": "be",
  "bosanski": "bs",
  "svenska": "sv",
  "suomi": "fi",
  "فارسی": "fa",
  "euskara": "eu",
  "Norwegian Bokmål (Norway)": "nb-no",
  "lietuvių kalba": "lt",
  "srpskohrvatski": "sh",
  "Norsk": "no",
  "עברית": "he",
  "Монгол": "mn",
  "മലയാളം": "ml",
  "Українська": "uk",
  "isiZulu": "zu",
  "isiXhosa": "xh",
  "Nederlands": "nl",
  "ဗမာစာ": "my",
  "Malaysia": "ms",
  "Hrvatski": "hr",
  "Română": "ro",
  "български": "bg",
  "čeština": "cs",
  "Kurdî": "ku",
  "Magyar": "hu",
  "Cebuano": "ceb",
  "English (United States)": "en-us",
  "Esperanto": "eo",
  "Estonian": "et",
  "Faroese": "fo",
  "Irish": "ga",
  "Guarani": "gn",
  "Gujarati": "gu",
  "Hausa": "ha",
  "Haitian Creole": "ht",
  "Armenian": "hy",
  "Igbo": "ig",
  "Icelandic": "is",
  "Georgian": "ka",
  "Javanese": "jv",
  "Kazakh": "kk",
  "Cambodian": "km",
  "Kannada": "kn",
  "Kyrgyz": "ky",
  "Luxembourgish": "lb",
  "Laothian": "lo",
  "Latvian": "lv",
  "Malagasy": "mg",
  "Maori": "mi",
  "Macedonian": "mk",
  "Marathi": "mr",
  "Maltese": "mt",
  "Nepali": "ne",
  "Nyanja": "ny",
  "Pashto": "ps",
  "Portuguese (Portugal)": "pt-pt",
  "Romansh": "rm",
  "Sindhi": "sd",
  "Sinhalese": "si",
  "Slovak": "sk",
  "Slovenian": "sl",
  "Samoan": "sm",
  "Shona": "sn",
  "Somali": "so",
  "Albanian": "sq",
  "Serbian": "sr",
  "Sesotho": "st",
  "Swahili": "sw",
  "Tamil": "ta",
  "Tajik": "tg",
  "Tigrinya": "ti",
  "Turkmen": "tk",
  "Tonga": "to",
  "Urdu": "ur",
  "Yoruba": "yo",
  "Chinese (Traditional)": "zh-tw",
  "Latin": "la",
  "Uzbek": "uz",
  "Tagalog": "tl",
  'অসমীয়া': 'as',
  'Brezhoneg': 'br',
  'Corsu': 'co',
  'Чӑвашла': 'cv',
  'Lombard': 'lmo',
  'Moldavian': 'mo',
  'ਪੰਜਾਬੀ': 'pa',
  'తెలుగు': 'te',
  'Vèneto': 'vec',
};

/// this might not always work depending on how every extension provides its subtitles
String completeLanguageNameEnglish(String lang) {
  lang = lang.toLowerCase();
  for (var element in languagesMapEnglish.entries) {
    if (element.value.toLowerCase() == lang) {
      return element.key;
    }
  }
  return lang.trim().toUpperCase();
}

final languagesMapEnglish = {
  'All': 'all',
  'French': 'fr',
  'English': 'en',
  'Vietnamese': 'vi',
  'Thai': 'th',
  'Bulgaria': 'bg',
  'Arabian': 'ar',
  'Portuguese': 'pt',
  'Korean': 'ko',
  'Portuguese - Portuguese(Brazil)': 'pt-br',
  'Italian': 'it',
  'Russian': 'ru',
  'Spanish': 'es',
  'Spanish - Spanish(Latin_America)': 'es-la',
  'Indonesia': 'id',
  'Japanese': 'ja',
  'Polish': 'pl',
  'Turkish': 'tr',
  'German': 'de',
  'Chinese': 'zh',
  "Filipino": "fil",
  "dansk": "da",
  "Afrikaans": "af",
  "Azərbaycan": "az",
  "bosanski": "bs",
  "svenska": "sv",
  "suomi": "fi",
  "Norwegian Bokmål (Norway)": "nb-no",
  "Norsk": "no",
  "Nederlands": "nl",
  "Malaysia": "ms",
  "Hrvatski": "hr",
  "Kurdî": "ku",
  "Magyar": "hu",
  "Cebuano": "ceb",
  "English (United States)": "en-us",
  "Esperanto": "eo",
  "Estonian": "et",
  "Faroese": "fo",
  "Irish": "ga",
  "Guarani": "gn",
  "Gujarati": "gu",
  "Hausa": "ha",
  "Haitian Creole": "ht",
  "Armenian": "hy",
  "Igbo": "ig",
  "Icelandic": "is",
  "Georgian": "ka",
  "Javanese": "jv",
  "Kazakh": "kk",
  "Cambodian": "km",
  "Kannada": "kn",
  "Kyrgyz": "ky",
  "Luxembourgish": "lb",
  "Laothian": "lo",
  "Latvian": "lv",
  "Malagasy": "mg",
  "Maori": "mi",
  "Macedonian": "mk",
  "Marathi": "mr",
  "Maltese": "mt",
  "Nepali": "ne",
  "Nyanja": "ny",
  "Pashto": "ps",
  "Portuguese (Portugal)": "pt-pt",
  "Romansh": "rm",
  "Sindhi": "sd",
  "Sinhalese": "si",
  "Slovak": "sk",
  "Slovenian": "sl",
  "Samoan": "sm",
  "Shona": "sn",
  "Somali": "so",
  "Albanian": "sq",
  "Serbian": "sr",
  "Sesotho": "st",
  "Swahili": "sw",
  "Tamil": "ta",
  "Tajik": "tg",
  "Tigrinya": "ti",
  "Turkmen": "tk",
  "Tonga": "to",
  "Urdu": "ur",
  "Yoruba": "yo",
  "Chinese (Traditional)": "zh-tw",
  "Latin": "la",
  "Uzbek": "uz",
  "Tagalog": "tl",
  "Assamese": "as",
  "Breton": "br",
  "Corsican": "co",
  "Chuvash": "cv",
  "Lombard": "lmo",
  "Moldavian": "mo",
  "Punjabi": "pa",
  "Telugu": "te",
  "Venetian": "vec",
};
