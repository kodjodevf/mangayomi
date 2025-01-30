import 'package:mangayomi/eval/javascript/http.dart';

class PageUrl {
  String url;
  String? fileName;
  Map<String, String>? headers;

  PageUrl(this.url, {this.fileName, this.headers});
  factory PageUrl.fromJson(Map<String, dynamic> json) {
    return PageUrl(
      json['url'].toString().trim(),
      headers: (json['headers'] as Map?)?.toMapStringString,
    );
  }
  Map<String, dynamic> toJson() => {'url': url, 'headers': headers};

  @override
  String toString() {
    return 'PageUrl(url: $url, headers: $headers, fileName: $fileName)';
  }
}
