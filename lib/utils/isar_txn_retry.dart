import 'package:mangayomi/main.dart';

Future<T> writeTxnSyncWithRetry<T>(
  T Function() body, {
  int maxAttempts = 6,
}) async {
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return isar.writeTxnSync<T>(body);
    } catch (e) {
      final isAsyncTxnConflict = e.toString().contains(
        'async write transaction is already in progress',
      );
      if (!isAsyncTxnConflict || attempt == maxAttempts - 1) rethrow;
      await Future.delayed(Duration(milliseconds: 100 * (attempt + 1)));
    }
  }
  throw StateError('writeTxnSyncWithRetry: exhausted retries');
}
