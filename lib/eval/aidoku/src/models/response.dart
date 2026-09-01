import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

typedef ImageRef = int;

class Request {
  Request({this.url, required this.headers});
  final String? url;
  final Map<String, String> headers;

  factory Request.fromPostcard(PostcardReader reader) {
    final url = reader.readOption((r) => r.readString());
    final headers = reader.readMap((r) => r.readString(), (r) => r.readString());
    return Request(url: url, headers: headers);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeOption(url, (w, s) => w.writeString(s));
    writer.writeMap(headers, (w, k) => w.writeString(k), (w, v) => w.writeString(v));
  }
}

class Response {
  Response({
    required this.code,
    required this.headers,
    required this.request,
    required this.image,
  });

  final int code;
  final Map<String, String> headers;
  final Request request;
  final ImageRef image;

  factory Response.fromPostcard(PostcardReader reader) {
    final code = reader.readU16();
    final headers = reader.readMap((r) => r.readString(), (r) => r.readString());
    final request = Request.fromPostcard(reader);
    final image = reader.readI32();
    return Response(code: code, headers: headers, request: request, image: image);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeU16(code);
    writer.writeMap(headers, (w, k) => w.writeString(k), (w, v) => w.writeString(v));
    request.toPostcard(writer);
    writer.writeI32(image);
  }
}
