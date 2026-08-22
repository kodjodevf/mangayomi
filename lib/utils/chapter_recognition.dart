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

  /// How many decimal places [parseChapterNumber] keeps.
  ///
  /// The key is an int so it can be compared, sorted and used as a map key
  /// exactly as before, but it is scaled so the fraction survives: chapter 1.5
  /// is 1500, not 1.
  static const int _scale = 1000;

  /// Room for one season, wide enough for the scaled chapter numbers below it.
  static const int _seasonStride = 100000 * _scale;

  /// Sort key for the UI list, and the identity used to tell two chapters
  /// apart. Encodes season so multi-season anime sort correctly:
  /// key = season * [_seasonStride] + chapter * [_scale].
  ///
  /// The fraction has to survive. Chapters numbered 1, 1.1 and 1.5 are three
  /// different chapters, and truncating them to 1 made the app treat them as
  /// one: the refresh in update_manga_detail_providers de-duplicates on this
  /// number and drops the collisions, so the decimal ones never reached the
  /// library at all. See #812.
  int parseChapterNumber(String mangaTitle, String chapterName) {
    final (season, number) = _parse(mangaTitle, chapterName, applySeason: true);
    if (number == null) return 0;
    final scaled = (number * _scale).round();
    return season > 0 ? season * _seasonStride + scaled : scaled;
  }

  /// Episode number within a season, for tracker updates (MAL/AniList/Kitsu)
  /// and AniSkip results. The tracker entry is already season-specific,
  /// so season is stripped.
  ///
  /// Trackers count whole chapters, so the fraction is dropped here on
  /// purpose. This is not the same number as [parseChapterNumber].
  int parseEpisodeNumber(String mangaTitle, String chapterName) {
    final (_, number) = _parse(mangaTitle, chapterName, applySeason: false);
    return number?.toInt() ?? 0;
  }

  (int, double?) _parse(
    String mangaTitle,
    String chapterName, {
    required bool applySeason,
  }) {
    // Normalize the chapter name by removing title, punctuation noise, etc.
    final name = chapterName
        .toLowerCase()
        .replaceAll(mangaTitle.toLowerCase(), '')
        .trim()
        .replaceAll(',', '.')
        .replaceAll('-', '.')
        .replaceAll(_unwantedWhiteSpace, '');

    final season = applySeason
        ? int.tryParse(_seasonKeyword.firstMatch(name)?.group(1) ?? '') ?? 0
        : 0;

    final epMatch = _episodeKeyword.firstMatch(name);
    if (epMatch != null) {
      return (season, double.parse(epMatch.group(1)!));
    }

    // strip season/volume noise, then look for ch. or bare number.
    final stripped = name.replaceAll(_unwanted, '');
    return (season, _extractNumber(stripped));
  }

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
