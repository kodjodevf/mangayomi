completeLang(String lang) {
  lang = lang.toLowerCase();
  for (var element in languagesMap.entries) {
    if (element.value.toString().toLowerCase() == lang) {
      return element.key;
    }
  }
  return lang.toUpperCase();
}

final languagesMap = {
  'Français': 'fr',
  'English': 'en',
  'Bulgaria': 'bg',
  'العربية': 'ar',
  'Português': 'pt',
  'Português do brasil': 'pt-br',
  'Italiano': 'it',
  'Pусский язык': 'ru',
  'Español': 'es',
  'Español latinoamericano': 'es-419',
  'Bahasa Indonesia': 'id',
  'हिन्दी, हिंदी': 'hi',
  '日本語': 'ja',
  'Polski': 'pl',
  'Türkçe': 'tr',
  'Deutsch': 'de',
  '中文(Zhōngwén)': 'zh',
  '繁體中文(Hong Kong)': 'zh-hk'
};
