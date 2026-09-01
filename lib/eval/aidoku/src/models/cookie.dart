import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

class Cookie {
  Cookie({
    required this.name,
    required this.value,
    this.expiresDate,
    required this.domain,
    required this.path,
    this.isSecure = false,
    this.isHttpOnly = false,
  });

  final String name;
  final String value;
  final DateTime? expiresDate;
  final String domain;
  final String path;
  final bool isSecure;
  final bool isHttpOnly;

  factory Cookie.fromPostcard(PostcardReader reader) {
    final name = reader.readString();
    final value = reader.readString();
    final expSec = reader.readOption((r) => r.readF64());
    final domain = reader.readString();
    final path = reader.readString();
    final isSecure = reader.readBool();
    final isHttpOnly = reader.readBool();

    return Cookie(
      name: name,
      value: value,
      expiresDate: expSec != null
          ? DateTime.fromMillisecondsSinceEpoch((expSec * 1000).toInt(), isUtc: true)
          : null,
      domain: domain,
      path: path,
      isSecure: isSecure,
      isHttpOnly: isHttpOnly,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(name);
    writer.writeString(value);
    writer.writeOption(
      expiresDate?.millisecondsSinceEpoch != null
          ? expiresDate!.millisecondsSinceEpoch / 1000.0
          : null,
      (w, v) => w.writeF64(v),
    );
    writer.writeString(domain);
    writer.writeString(path);
    writer.writeBool(isSecure);
    writer.writeBool(isHttpOnly);
  }
}
