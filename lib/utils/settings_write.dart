import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

/// Applies [change] to the settings row, reading it inside the transaction
/// that writes it.
///
/// Every setting the app has lives in one row, and `putSync` writes the whole
/// row. Reading it, holding the object, and writing it back later therefore
/// puts back whatever else changed in the meantime, so the read has to happen
/// inside the write. [change] runs in an open transaction: keep it to touching
/// the row, and do not call anything that opens a transaction of its own.
void updateSettings(void Function(Settings settings) change) {
  isar.writeTxnSync(() {
    final settings = isar.settings.getSync(227);
    if (settings == null) return;
    change(settings);
    settings.updatedAt = DateTime.now().millisecondsSinceEpoch;
    isar.settings.putSync(settings);
  });
}
