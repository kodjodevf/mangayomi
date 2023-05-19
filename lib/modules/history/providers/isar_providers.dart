import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/history.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';
@riverpod
Stream<List<History>> getAllHistoryStream(
  GetAllHistoryStreamRef ref,
) async* {
  yield* isar.historys.filter().idIsNotNull().watch(fireImmediately: true);
}
