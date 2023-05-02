import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(
    {required Map<String, String>? headers,
    required String imageUrl,
    required double? width,
    required double? height,
    required BoxFit? fit,
    AlignmentGeometry? alignment}) {
  if (kIsWeb) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    );
  } else {
    return CachedNetworkImage(
      httpHeaders: headers ?? {},
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        size: 50,
      ),
    );
  }
}
