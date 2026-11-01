import 'package:flutter/painting.dart' show FontWeight;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font families for the recap. Each null falls back to the platform font,
/// which is also what shows offline before Google Fonts has been cached.
class RecapFonts {
  /// Rajdhani: the Status Window's system text.
  final String? display;
  final String? displayBold;

  /// Bangers: comic sound-effect words.
  final String? comic;

  /// Anton: comic numerals (Bangers' 7 reads as a 1).
  final String? numerals;

  const RecapFonts({this.display, this.displayBold, this.comic, this.numerals});

  static const system = RecapFonts();

  factory RecapFonts.google() => RecapFonts(
    display: GoogleFonts.rajdhani(fontWeight: FontWeight.w600).fontFamily,
    displayBold: GoogleFonts.rajdhani(fontWeight: FontWeight.w700).fontFamily,
    comic: GoogleFonts.bangers().fontFamily,
    numerals: GoogleFonts.anton().fontFamily,
  );
}

final recapFontsProvider = Provider<RecapFonts>((ref) => RecapFonts.google());
