import 'package:flutter/widgets.dart';

/// Gives [child] back the bottom padding its Scaffold took away.
///
/// A Scaffold strips the bottom padding from its body whenever its
/// `bottomNavigationBar` slot is filled, even by a bar that has collapsed to
/// nothing, such as a selection bar waiting for a selection. Under the
/// floating navigation bar that padding is the bar's height, which scroll
/// views add back at their end (`pageBottomInsets`); without it the last row
/// of a list stays underneath the bar. Read [bottom] above the Scaffold and
/// hand it back here.
class RestoreBottomPadding extends StatelessWidget {
  const RestoreBottomPadding({
    super.key,
    required this.bottom,
    required this.child,
  });

  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(padding: data.padding.copyWith(bottom: bottom)),
      child: child,
    );
  }
}
