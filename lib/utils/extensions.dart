import 'package:html/dom.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

extension StringExtensions on String {
  String substringAfter(String pattern) {
    final startIndex = indexOf(pattern);
    if (startIndex == -1) return substring(0);

    final start = startIndex + pattern.length;
    return substring(start);
  }

  String substringAfterLast(String pattern) {
    return split(pattern).last;
  }

  String substringBefore(String pattern) {
    final endIndex = indexOf(pattern);
    if (endIndex == -1) return substring(0);

    return substring(0, endIndex);
  }

  String substringBeforeLast(String pattern) {
    final endIndex = lastIndexOf(pattern);
    if (endIndex == -1) return substring(0);

    return substring(0, endIndex);
  }

  String substringBetween(String left, String right) {
    int startIndex = 0;
    int index = indexOf(left, startIndex);
    if (index == -1) return "";
    int leftIndex = index + left.length;
    int rightIndex = indexOf(right, leftIndex);
    if (rightIndex == -1) return "";
    startIndex = rightIndex + right.length;
    return substring(leftIndex, rightIndex);
  }

  bool isMediaVideo() {
    return [
      "3gp",
      "avi",
      "mpg",
      "mpeg",
      "webm",
      "ogg",
      "flv",
      "m4v",
      "mvp",
      "mp4",
      "wmv",
      "mkv",
      "mov",
      "ts"
    ].any((extension) => toLowerCase().endsWith(extension));
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

extension SelectDocumentExtension on Document? {
  List<Element>? select(String selector) {
    try {
      return this?.querySelectorAll(selector);
    } catch (e) {
      return null;
    }
  }

  Element? selectFirst(String selector) {
    try {
      return this?.querySelector(selector);
    } catch (e) {
      return null;
    }
  }
}

extension SelectElementtExtension on Element {
  List<Element>? select(String selector) {
    try {
      return querySelectorAll(selector);
    } catch (e) {
      return null;
    }
  }

  Element? selectFirst(String selector) {
    try {
      return querySelector(selector);
    } catch (e) {
      return null;
    }
  }

  String? attr(String attribute) {
    try {
      return attributes[attribute];
    } catch (e) {
      return null;
    }
  }

  String? get getSrc {
    try {
      return regSrcMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getImg {
    try {
      return regImgMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getHref {
    try {
      return regHrefMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }

  String? get getDataSrc {
    try {
      return regDataSrcMatcher(outerHtml);
    } catch (e) {
      return null;
    }
  }
}
