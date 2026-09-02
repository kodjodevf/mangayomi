import 'dart:typed_data';

class ImageRequestResult {
  final String url;
  final Map<String, String> headers;
  final Uint8List? body;

  const ImageRequestResult({
    required this.url,
    this.headers = const {},
    this.body,
  });
}

typedef ImageRef = int;

class Request {
  Request({this.url, required this.headers});
  final String? url;
  final Map<String, String> headers;
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
}
