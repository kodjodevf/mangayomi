import 'dart:developer';

Map<String, String> headers(String source) {
  source = source.toLowerCase();
  log(source);
  return source == 'mangakawaii'
      ? {
          'Referer': 'https://www.mangakawaii.io/',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\$userAgentRandomizer1.0.4\$userAgentRandomizer3.1\$userAgentRandomizer2 Safari/537.36',
          'Accept-Language': 'fr'
        }
      : source == 'mangahere'
          ? {"Referer": "https://www.mangahere.cc/", "Cookie": "isAdult=1"}
          : source == 'comick'
              ? {
                  'Referer': 'https://comick.app/',
                  'User-Agent':
                      'Tachiyomi Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\\\$userAgentRandomizer1.0.4\\\$userAgentRandomizer3.1\\\$userAgentRandomizer2 Safari/537.36'
                }
              : {};
}
