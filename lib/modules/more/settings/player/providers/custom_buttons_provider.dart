import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'custom_buttons_provider.g.dart';

@riverpod
Stream<List<CustomButton>> getCustomButtonsStream(Ref ref) async* {
  yield* isar.customButtons.filter().idIsNotNull().sortByPos().watch(
    fireImmediately: true,
  );
}
