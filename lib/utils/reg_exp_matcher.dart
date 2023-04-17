String regHrefMatcher(String input) {
  RegExp exp = RegExp(r'href="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  String? firstMatch = matches.first.group(1);
  return firstMatch!;
}

String regSrcMatcher(String input) {
  RegExp exp = RegExp(r'src="([^"]+)"');
  Iterable<Match> matches = exp.allMatches(input);
  String? firstMatch = matches.first.group(1);
  return firstMatch!;
}

String padIndex(int index) {
  String idx = index.toString();

  if (idx.length == 1) {
    return '00$idx';
  } else if (idx.length == 2) {
    return '0$idx';
  }
  return idx;
}
