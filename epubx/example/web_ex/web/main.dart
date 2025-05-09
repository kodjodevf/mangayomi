import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:epubx/epub.dart' as epub;

void main() async {
  querySelector('#output').text = 'Your Dart app is running.';

  var epubRes = await http.get('alicesAdventuresUnderGround.epub');
  if (epubRes.statusCode == 200) {
    var book = await epub.EpubReader.openBook(epubRes.bodyBytes);
    querySelector('#title').text = book.Title;
    querySelector('#author').text = book.Author;
    var chapters = await book.getChapters();
    querySelector('#nchapters').text = chapters.length.toString();
    querySelectorAll('h2').style.visibility = 'visible';
  }
}
