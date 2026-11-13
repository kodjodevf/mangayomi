import 'package:material_ui/material_ui.dart';

extension StreamBuilderExtension<T> on Stream<T> {
  StreamBuilder<T> toStreamBuilder(
    Widget Function(BuildContext, AsyncSnapshot<T>) builder,
  ) {
    return StreamBuilder(stream: this, builder: builder);
  }
}
