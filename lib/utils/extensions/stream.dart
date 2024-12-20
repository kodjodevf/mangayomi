import 'package:flutter/material.dart';

extension StreamBuilderExtension<T> on Stream<T> {
  StreamBuilder<T> toStreamBuilder(
      Widget Function(BuildContext, AsyncSnapshot<T>) builder) {
    return StreamBuilder(stream: this, builder: builder);
  }
}
