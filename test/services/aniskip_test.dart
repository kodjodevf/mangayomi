import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  test('optional AniSkip requests do not show Cloudflare prompts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(aniSkipProvider);
    final client = container.read(aniSkipProvider.notifier).http;
    final logger = client.interceptors.whereType<LoggerInterceptor>().single;
    final retryPolicy = client.retryPolicy as ResolveCloudFlareChallenge;

    expect(logger.showCloudFlareError, isFalse);
    expect(retryPolicy.showCloudFlareError, isFalse);
  });
}
