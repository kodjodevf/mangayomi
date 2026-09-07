import 'package:mangayomi/utils/language.dart';
import 'package:media_kit/media_kit.dart';

const _iso6393LanguageNames = {
  'ara': 'Arabic',
  'ces': 'Czech',
  'chi': 'Chinese',
  'dan': 'Danish',
  'deu': 'German',
  'ell': 'Greek',
  'eng': 'English',
  'fas': 'Persian',
  'fin': 'Finnish',
  'fra': 'French',
  'fre': 'French',
  'ger': 'German',
  'gre': 'Greek',
  'heb': 'Hebrew',
  'hin': 'Hindi',
  'hrv': 'Croatian',
  'hun': 'Hungarian',
  'ind': 'Indonesian',
  'ita': 'Italian',
  'jpn': 'Japanese',
  'kor': 'Korean',
  'nld': 'Dutch',
  'nor': 'Norwegian',
  'pol': 'Polish',
  'por': 'Portuguese',
  'ron': 'Romanian',
  'rum': 'Romanian',
  'rus': 'Russian',
  'slk': 'Slovak',
  'slo': 'Slovak',
  'slv': 'Slovenian',
  'spa': 'Spanish; Castilian',
  'srp': 'Serbian',
  'swe': 'Swedish',
  'tha': 'Thai',
  'tur': 'Turkish',
  'ukr': 'Ukrainian',
  'vie': 'Vietnamese',
  'zho': 'Chinese',
};

String audioTrackLabel(AudioTrack? track) {
  if (track == null || track.id == 'no') return 'None';
  if (track.id == 'auto') return '';

  final language = _languageName(track.language);
  final title = track.title?.trim() ?? '';
  final details = <String>[];
  final codec = track.codec?.trim() ?? '';
  if (codec.isNotEmpty) details.add(codec);

  final channels = track.channelscount;
  if (channels != null && channels > 0) {
    details.add('${channels}ch');
  } else {
    final channelLayout = track.channels?.trim() ?? '';
    if (channelLayout.isNotEmpty) details.add('${channelLayout}ch');
  }

  final sampleRate = track.samplerate;
  if (sampleRate != null && sampleRate > 0) {
    final kilohertz = sampleRate / 1000;
    final rate = kilohertz == kilohertz.roundToDouble()
        ? kilohertz.toInt().toString()
        : kilohertz.toStringAsFixed(1);
    details.add('${rate}kHz');
  }

  final parts = <String>[];
  if (language.isNotEmpty) parts.add('[$language]');
  if (title.isNotEmpty && title.toLowerCase() != language.toLowerCase()) {
    parts.add(title);
  }

  final base = parts.join(' ');
  if (details.isEmpty) return base.isNotEmpty ? base : track.id;
  return base.isEmpty ? details.join(', ') : '$base ${details.join(', ')}';
}

bool audioTrackLanguagesMatch(String? first, String? second) {
  final firstFamily = _languageFamily(first);
  final secondFamily = _languageFamily(second);
  return firstFamily.isNotEmpty && firstFamily == secondFamily;
}

String _languageFamily(String? value) {
  final name = _languageName(value).toLowerCase().trim();
  if (name.isEmpty) return '';
  return name.split(RegExp(r'\s*[(;\-]'))[0].trim();
}

String _languageName(String? value) {
  final language = value?.trim() ?? '';
  if (language.isEmpty) return '';

  final normalized = language.toLowerCase();
  final iso6393Name = _iso6393LanguageNames[normalized];
  if (iso6393Name != null) return iso6393Name;

  for (final entry in languagesMapEnglish.entries) {
    if (entry.key.toLowerCase() == normalized) return entry.key;
  }

  final completeName = completeLanguageNameEnglish(language);
  return completeName == language.toUpperCase() ? language : completeName;
}
