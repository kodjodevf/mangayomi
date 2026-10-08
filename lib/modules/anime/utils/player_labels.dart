import 'package:flutter/painting.dart';

/// Shortens a source quality label like "1080p (Sub)" to "1080-sub"/"1080-dub".
String shortQualityLabel(String raw) {
  final lower = raw.toLowerCase();
  final res = RegExp(r'(\d{3,4})\s*p?').firstMatch(lower)?.group(1);
  final tag = lower.contains('sub')
      ? 'sub'
      : lower.contains('dub')
      ? 'dub'
      : null;
  if (res != null && tag != null) return '$res-$tag';
  if (res != null) return '${res}p';
  return raw;
}

/// Shortens a track name to fit a player pill: the bracketed language tag
/// when there is one, otherwise the leading word, at most 6 characters.
String shortTrackLabel(String raw) {
  var trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('[')) {
    final closing = trimmed.indexOf(']');
    if (closing > 1) {
      trimmed = trimmed.substring(1, closing).trim();
    } else {
      trimmed = trimmed.substring(1).trim();
    }
  } else if (trimmed.startsWith('(')) {
    final closing = trimmed.indexOf(')');
    if (closing > 1) {
      trimmed = trimmed.substring(1, closing).trim();
    } else {
      trimmed = trimmed.substring(1).trim();
    }
  }
  final clean = trimmed.split(RegExp(r'[\(\[\-]')).first.trim();
  final candidate = clean.isNotEmpty ? clean : trimmed;
  if (candidate.length > 7) {
    return candidate.substring(0, 6);
  }
  return candidate;
}

String fitShortLabel(BoxFit fit) => switch (fit) {
  BoxFit.contain => 'Contain',
  BoxFit.cover => 'Cover',
  BoxFit.fill => 'Fill',
  BoxFit.fitHeight => 'Height',
  BoxFit.fitWidth => 'Width',
  BoxFit.scaleDown => 'Scale',
  BoxFit.none => 'None',
};
