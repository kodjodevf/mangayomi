class MHttpResponse {
  bool? hasError;
  int? statusCode;
  String? body;

  MHttpResponse({this.body, this.hasError, this.statusCode});
}
