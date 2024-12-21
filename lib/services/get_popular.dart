import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_popular.g.dart';

@riverpod
Future<MPages?> getPopular(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  return getExtensionService(source).getPopular(page);
}
