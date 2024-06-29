import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

final sources = _Sources._();

class _Sources {
  _Sources._();

  List<String> get platform => file;

  final List<String> network = [
    'https://user-images.githubusercontent.com/28951144/229373709-603a7a89-2105-4e1b-a5a5-a6c3567c9a59.mp4',
    'https://user-images.githubusercontent.com/28951144/229373716-76da0a4e-225a-44e4-9ee7-3e9006dbc3e3.mp4',
    'https://user-images.githubusercontent.com/28951144/229373718-86ce5e1d-d195-45d5-baa6-ef94041d0b90.mp4',
    'https://user-images.githubusercontent.com/28951144/229373720-14d69157-1a56-4a78-a2f4-d7a134d7c3e9.mp4',
  ];

  final List<String> file = [];

  final List<Uint8List> bytes = [];

  Future<void> prepare() async {
    if (_prepared) return;
    // Download to local [File]s.
    for (int i = 0; i < network.length; i++) {
      final destination = path.join(
        Directory.systemTemp.path,
        'media_kit',
        network[i].split('/').last,
      );
      if (!await File(destination).parent.exists()) {
        await File(destination).parent.create(recursive: true);
      }
      if (!await File(destination).exists()) {
        final response = await http.get(Uri.parse(network[i]));
        await File(destination).writeAsBytes(response.bodyBytes);
      }
      file.add(destination);
      bytes.add(await File(destination).readAsBytes());
    }
    // Force forward slashes for Windows.
    for (int i = 0; i < file.length; i++) {
      file[i] = file[i].replaceAll(r'\', '/');
    }
    _prepared = true;
  }

  bool _prepared = false;
}
