import 'package:flutter/widgets.dart';

/// The app with what may cover it (the lock screen, say) above it.
///
/// The app is always the first child of the same [Stack], whether anything
/// covers it or not. Returned on its own when nothing did, it was a widget of
/// another type in another place each time a cover came or went, so Flutter
/// built it again from nothing: the router with it, which brings its pages
/// back without their extras, and every page lost its state.
class AppLayers extends StatelessWidget {
  const AppLayers({super.key, required this.app, this.covers = const []});

  final Widget app;

  /// Bottom to top, each with a key of its own: a cover then keeps its
  /// state as others come and go around it. The lock screen must, as the
  /// secure-screen cover comes up over it while the user authenticates.
  final List<Widget> covers;

  @override
  Widget build(BuildContext context) {
    assert(
      covers.every((cover) => cover.key != null),
      'Every cover needs a key',
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        KeyedSubtree(key: const ValueKey(AppLayers), child: app),
        ...covers,
      ],
    );
  }
}
