import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'custom_buttons_provider.g.dart';

@riverpod
Stream<List<CustomButton>> getCustomButtonsStream(Ref ref) async* {
  yield* customButtonRepository.watchAllSortedByPos();
}
