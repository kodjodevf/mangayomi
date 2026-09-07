import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/services/anime_extractors/voe_extractor.dart';

void main() {
  test('extracts videos from the current encoded VOE payload', () async {
    final requests = <Uri>[];
    final client = MockClient((request) async {
      requests.add(request.url);
      return switch (request.url.toString()) {
        'https://voe.example/e/video' => http.Response(_redirectPage, 200),
        'https://mirror.example/e/video' => http.Response(_embedPage, 200),
        'https://mirror.example/js/loader.js' => http.Response(_loader, 200),
        'https://cdn.example/video/master.m3u8' => http.Response(
          _masterPlaylist,
          200,
        ),
        _ => http.Response('not found', 404),
      };
    });

    final videos = await VoeExtractor(client: client)
        .videosFromUrl('https://voe.example/e/video', 'German ');

    expect(
      requests,
      containsAllInOrder([
        Uri.parse('https://voe.example/e/video'),
        Uri.parse('https://mirror.example/e/video'),
        Uri.parse('https://mirror.example/js/loader.js'),
        Uri.parse('https://cdn.example/video/master.m3u8'),
      ]),
    );
    expect(videos, hasLength(2));
    expect(videos[0].quality, 'German Voe: 720p');
    expect(videos[0].url, 'https://cdn.example/video/720/index.m3u8');
    expect(videos[1].quality, 'German Voe: 480p');
    expect(videos[1].url, 'https://cdn.example/video/480/index.m3u8');
  });
}

const _redirectPage = '''
<script>
  if (typeof localStorage !== 'undefined') {
    window.location.href = 'https://mirror.example/e/video';
  }
</script>
''';

const _embedPage = '''
<script type="application/json">["DQAkGQqLAyO@\$3BTkzo1H2Mz^^f0AH95JHcqp~@102G297FzM3%?FHcbomufMJ5*~EAH95pa1zry!!IYM3WAoSWfJ#&QIpsSx2MK1AsTt="]</script><script src="/js/loader.js"></script>
''';

const _loader = "const lookup = ['@\$', '^^', '~@', '%?', '*~', '!!', '#&'];";

const _masterPlaylist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=2800000,RESOLUTION=1280x720
720/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1400000,RESOLUTION=854x480
480/index.m3u8
''';
