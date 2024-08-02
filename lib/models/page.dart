import 'package:mangayomi/eval/javascript/http.dart';

class PageUrl {
  String url;
  Map<String, String>? headers;

  PageUrl(this.url, {this.headers});
  factory PageUrl.fromJson(Map<String, dynamic> json) {
    return PageUrl(
      json['url'],
      headers: (json['headers'] as Map?)?.toMapStringString,
    );
  }
  Map<String, dynamic> toJson() => {'url': url, 'headers': headers};
}
