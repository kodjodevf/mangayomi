class ChapterRecognition {
  static final _unwanted = RegExp(
    r"\b(?:v|ver|vol|version|volume|season|staffel|saison|temporada|s)[^a-z]?[0-9]+",
  );
  static final _unwantedWhiteSpace = RegExp(r"\s(?=extra|special|omake)");
  static final _seasonKeyword = RegExp(
    r"\b(?:staffel|season|saison|temporada|s)\s*([0-9]+)",
  );
  static final _episodeKeyword = RegExp(
    r"\b(?:folge|episode|ep\.?)\s*([0-9]+(?:\.[0-9]+)?)",
  );
  // lookbehind for "ch." then zero or more spaces.
  static final _chNotation = RegExp(
    r"(?<=ch\.) *([0-9]+)(\.[0-9]+)?(\.?[a-z]+)?",
  );
  static final _bareNumber = RegExp(r"([0-9]+)(\.[0-9]+)?(\.?[a-z]+)?");

  /// Sort key for a single chapter with no list context. Always buckets by
  /// season when present: key = season * 100000 + episode.
  int parseChapterNumber(String mangaTitle, String chapterName) {
    final (season, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
    return _withSeason(season, ep).toInt();
  }

  /// Episode number within a season, for tracker updates (MAL/AniList/Kitsu)
  /// and AniSkip results. The tracker entry is already season-specific,
  /// so season is never applied.
  int parseEpisodeNumber(String mangaTitle, String chapterName) {
    final (_, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
    return ep.toInt();
  }

  /// Raw (season, episode) pair, unbucketed — season is 0 if none matched.
  /// Episode keeps its fractional part (e.g. 12.5) so callers needing exact
  /// chapter identity (dedup, stable sort of split chapters) don't collide
  /// at the same truncated integer.
  (int, double) rawSeasonAndNumber(String mangaTitle, String chapterName) {
    final name = chapterName
        .toLowerCase()
        .replaceAll(mangaTitle.toLowerCase(), '')
        .trim()
        .replaceAll(',', '.')
        .replaceAll('-', '.')
        .replaceAll(_unwantedWhiteSpace, '');

    final season =
        int.tryParse(_seasonKeyword.firstMatch(name)?.group(1) ?? '') ?? 0;

    final epMatch = _episodeKeyword.firstMatch(name);
    if (epMatch != null) {
      return (season, double.parse(epMatch.group(1)!));
    }

    final stripped = name.replaceAll(_unwanted, '');
    return (season, _extractNumber(stripped) ?? 0);
  }

  // Combines season + episode into a sortable number.
  double _withSeason(int season, double ep) =>
      season > 0 ? season * 100000 + ep : ep;

  double? _extractNumber(String name) {
    final chMatch = _chNotation.firstMatch(name);
    if (chMatch != null) return _fromMatch(chMatch);

    final numMatch = _bareNumber.firstMatch(name);
    if (numMatch != null) return _fromMatch(numMatch);

    return null;
  }

  double _fromMatch(Match match) {
    final base = double.parse(match.group(1)!);
    return base + _decimalAddition(match.group(2), match.group(3));
  }

  double _decimalAddition(String? decimal, String? alpha) {
    if (decimal != null && decimal.isNotEmpty) return double.parse(decimal);
    if (alpha != null && alpha.isNotEmpty) {
      if (alpha.contains("extra")) {
        return 0.99;
      }
      if (alpha.contains("omake")) {
        return 0.98;
      }
      if (alpha.contains("special")) {
        return 0.97;
      }
      final trimmedAlpha = alpha.replaceFirst('.', '');
      if (trimmedAlpha.length == 1) {
        return _parseAlphaPostFix(trimmedAlpha[0]);
      }
    }

    return 0.0;
  }

  double _parseAlphaPostFix(String alpha) {
    final number = alpha.codeUnitAt(0) - ('a'.codeUnitAt(0) - 1);
    if (number >= 10) return 0.0;
    return number / 10.0;
  }
}
