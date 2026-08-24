import 'package:google_fonts/google_fonts.dart';

class NovelReaderFontOption {
  final String label;
  final String? key;
  const NovelReaderFontOption(this.label, this.key);
}

const novelReaderFontOptions = [
  NovelReaderFontOption('Default', null),
  NovelReaderFontOption('OpenDyslexic', 'OpenDyslexic'),
  NovelReaderFontOption('Lexend', 'Lexend'),
  NovelReaderFontOption('Atkinson Hyperlegible', 'AtkinsonHyperlegible'),
];

/// Resolves a stored font key to the actual font family name flutter_html
/// should render with. OpenDyslexic is bundled as a local asset (declared
/// in pubspec.yaml under the same family name), the others are resolved via
/// google_fonts the same way the app-wide font picker already does.
String? resolveNovelFontFamily(String? key) {
  switch (key) {
    case 'OpenDyslexic':
      return 'OpenDyslexic';
    case 'Lexend':
      return GoogleFonts.lexend().fontFamily;
    case 'AtkinsonHyperlegible':
      return GoogleFonts.atkinsonHyperlegible().fontFamily;
    default:
      return null;
  }
}
