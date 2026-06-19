String regHrefMatcher(String input) {
  RegExp exp = RegExp(r'href="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  if (matches.isEmpty) return '';
  return matches.first.group(1) ?? '';
}

String regDataSrcMatcher(String input) {
  RegExp exp = RegExp(r'data-src="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  if (matches.isEmpty) return '';
  return matches.first.group(1) ?? '';
}

String regSrcMatcher(String input) {
  RegExp exp = RegExp(r'src="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  if (matches.isEmpty) return '';
  return matches.first.group(1) ?? '';
}

String regImgMatcher(String input) {
  RegExp exp = RegExp(r'img="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  if (matches.isEmpty) return '';
  return matches.first.group(1) ?? '';
}

String regCustomMatcher(String input, String source, int group) {
  try {
    RegExp exp = RegExp(source);
    Iterable<Match> matches = exp.allMatches(input);
    String? firstMatch = matches.first.group(group);
    return firstMatch!;
  } catch (_) {
    return input;
  }
}

String padIndex(int index) {
  return (index + 1).toString().padLeft(3, "0");
}
