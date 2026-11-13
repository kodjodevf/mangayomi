import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi_sync/testing.dart';
import 'package:test/test.dart';

void main() {
  syncStoreSuite(
    test: test,
    setUp: setUp,
    tearDown: tearDown,
    openStore: MemorySyncStore.new,
  );
}
