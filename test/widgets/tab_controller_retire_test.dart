import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// #923: "Null check operator used on a null value" at
/// `_IndicatorPainter.paint (tabs.dart:633)`, reported from the library.
///
/// That line is `controller.animation!.value`, and `TabController.dispose()`
/// sets `_animationController = null`, so `animation` returns null afterwards.
/// The library rebuilt its TabController whenever the category count changed
/// and disposed the old one **inside build**, while the TabBar from the
/// previous frame was still holding it.
///
/// These pin the Flutter behaviour the fix depends on, and the shape of the
/// fix, without needing the whole library screen and its providers.
void main() {
  testWidgets('a disposed TabController has no animation left to read', (
    tester,
  ) async {
    late TabController controller;
    await tester.pumpWidget(
      MaterialApp(
        home: _Host(
          onInit: (c) => controller = c,
          child: (c) => TabBar(
            controller: c,
            tabs: const [Tab(text: 'a')],
          ),
        ),
      ),
    );

    expect(controller.animation, isNotNull);
    controller.dispose();

    // This is the value tabs.dart:633 dereferences with `!`.
    expect(controller.animation, isNull);
  });

  testWidgets('the replaced controller is still alive during that build', (
    tester,
  ) async {
    // The property the fix rests on, checked from inside the build itself:
    // one pump runs build, paint and post-frame callbacks together, so from
    // outside the disposal has already happened by the time the test looks.
    // What matters is that it had not happened *yet* while the tree was being
    // built, because that is when the old TabBar still holds it.
    await tester.pumpWidget(const MaterialApp(home: _Swapper()));

    await tester.tap(find.text('swap'));
    await tester.pump();

    expect(
      _SwapperState.current!.oldAliveDuringBuild,
      isTrue,
      reason:
          'disposed in build, and the next paint reads null at tabs.dart:633',
    );
  });

  testWidgets('and disposes it once the frame is done, so nothing leaks', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _Swapper()));
    final old = _SwapperState.current!.controller!;

    await tester.tap(find.text('swap'));
    await tester.pump();
    await tester.pump(); // post-frame callbacks run

    expect(old.animation, isNull, reason: 'retired, not kept forever');
  });

  testWidgets('a controller still waiting when the screen goes is disposed', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _Swapper()));
    final old = _SwapperState.current!.controller!;

    await tester.tap(find.text('swap'));
    await tester.pump();
    // Torn down before the post-frame callback could run.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    expect(old.animation, isNull);
  });
}

class _Host extends StatefulWidget {
  const _Host({required this.onInit, required this.child});
  final void Function(TabController) onInit;
  final Widget Function(TabController) child;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with TickerProviderStateMixin {
  late final TabController controller = TabController(length: 1, vsync: this);
  @override
  void initState() {
    super.initState();
    widget.onInit(controller);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: widget.child(controller),
      ),
    ),
  );
}

/// Rebuilds its TabController with a different length, the way the library
/// does when the category count changes.
class _Swapper extends StatefulWidget {
  const _Swapper();
  @override
  State<_Swapper> createState() => _SwapperState();
}

class _SwapperState extends State<_Swapper> with TickerProviderStateMixin {
  static _SwapperState? current;
  int _length = 2;
  TabController? _controller;
  TabController? get controller => _controller;

  /// Whether the controller being replaced was still usable at the moment the
  /// tree was rebuilt without it.
  bool? oldAliveDuringBuild;
  final _retired = <TabController>[];

  @override
  void initState() {
    super.initState();
    current = this;
  }

  @override
  void dispose() {
    _controller?.dispose();
    for (final c in _retired) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _controller!.length != _length) {
      // The same shape as library_screen: retire rather than dispose inline.
      final old = _controller;
      if (old != null) {
        // Recorded here because this is the only moment it can be observed.
        oldAliveDuringBuild = old.animation != null;
        _retired.add(old);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_retired.remove(old)) old.dispose();
        });
      }
      _controller = TabController(length: _length, vsync: this);
    }

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            tabs: [for (var i = 0; i < _length; i++) Tab(text: '$i')],
          ),
          TextButton(
            onPressed: () => setState(() => _length = 3),
            child: const Text('swap'),
          ),
        ],
      ),
    );
  }
}
