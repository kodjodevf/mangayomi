lang(String lang) {
  if (lang == 'Français') {
    return 'fr';
  } else if (lang == 'English') {
    return 'en';
  } else if (lang == 'العربية') {
    return 'ar';
  } else if (lang == 'Português') {
    return 'pt';
  } else if (lang == 'Português do brasil') {
    return 'pt-br';
  } else if (lang == 'Italiano') {
    return 'it';
  } else if (lang == 'Pусский язык') {
    return 'ru';
  } else if (lang == 'Español') {
    return 'es';
  } else if (lang == 'Español latinoamericano') {
    return 'es-419';
  } else if (lang == 'Bahasa Indonesia') {
    return 'id';
  } else if (lang == 'हिन्दी, हिंदी') {
    return 'hi';
  } else if (lang == 'Deutsch') {
    return 'de';
  } else if (lang == '日本語') {
    return 'ja';
  } else if (lang == 'Türkçe') {
    return 'tr';
  } else if (lang == 'Polski') {
    return 'pl';
  } else if (lang == '中文(Zhōngwén)') {
    return 'zh';
  } else if (lang == '繁體中文(Hong Kong)') {
    return 'zh-hk';
  }
}

completeLang(String lang) {
  if (lang == 'fr') {
    return 'Français';
  } else if (lang == 'en') {
    return 'English';
  } else if (lang == 'ar') {
    return 'العربية';
  } else if (lang == 'pt') {
    return 'Português';
  } else if (lang == 'pt-br') {
    return 'Português do brasil';
  } else if (lang == 'it') {
    return 'Italiano';
  } else if (lang == 'ru') {
    return 'Pусский язык';
  } else if (lang == 'es') {
    return 'Español';
  } else if (lang == 'es-419') {
    return 'Español latinoamericano';
  } else if (lang == 'id') {
    return 'Bahasa Indonesia';
  } else if (lang == 'hi') {
    return 'हिन्दी, हिंदी';
  } else if (lang == 'de') {
    return 'Deutsch';
  } else if (lang == 'ja') {
    return '日本語';
  } else if (lang == 'tr') {
    return 'Türkçe';
  } else if (lang == 'pl') {
    return 'Polski';
  } else if (lang == 'zh') {
    return '中文(Zhōngwén)';
  } else if (lang == 'zh-hk') {
    return '繁體中文(Hong Kong)';
  }
}

final List<String> language = [
  "Français",
  "English",
  "العربية",
  'Português',
  'Português do brasil',
  'Italiano',
  'Pусский язык',
  'Español',
  'Español latinoamericano',
  'Bahasa Indonesia',
  'हिन्दी, हिंदी',
  '日本語',
  'Polski',
  'Türkçe',
  'Deutsch',
  '中文(Zhōngwén)',
  '繁體中文(Hong Kong)'
];
