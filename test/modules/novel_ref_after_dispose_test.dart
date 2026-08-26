import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// #949 is `Bad state: Using "ref" when a widget is about to or has been
/// unmounted is unsafe.`, thrown from `_NovelWebViewState.dispose()`.
///
/// The novel reader held its controller as a `late` field with an initialiser:
///
/// ```dart
/// late final NovelReaderController _readerController = ref.read(
///   novelReaderControllerProvider(chapter: chapter).notifier,
/// );
/// ```
///
/// A `late` field is resolved by whoever reads it first. Every ordinary path
/// reads it during `build`, which is safe. But `dispose()` also uses it, to
/// write the scroll offset and the history entry, and a reader closed before
/// its first build got that far leaves `dispose()` as the first reader — at
/// which point the element is deactivated and `ref` is gone.
///
/// These cover the shape of that, since the real widget needs isar, a chapter
/// and a loaded source to build at all.
void main() {
  final probeProvider = Provider<int>((ref) => 1);

  testWidgets('a late field read first by dispose reaches for a dead ref', (
    tester,
  ) async {
    // The premise. If this did not throw there would be nothing to fix.
    Object? thrown;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _Probe(
            provider: probeProvider,
            onDisposeError: (e) {
              thrown = e;
            },
          ),
        ),
      ),
    );

    // Never built anything that touched the field, which is the case a reader
    // closed during loading hits.
    await tester.pumpWidget(const ProviderScope(child: SizedBox()));

    expect(thrown, isStateError);
    expect(
      (thrown as StateError).message,
      contains('unmounted'),
      reason: 'this is the exact error #949 reports',
    );
  });

  testWidgets('resolving it in initState leaves dispose something to use', (
    tester,
  ) async {
    // The shape the fix uses.
    Object? thrown;
    int? seenInDispose;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _Probe(
            provider: probeProvider,
            eager: true,
            onDisposeError: (e) {
              thrown = e;
            },
            onDisposeValue: (v) {
              seenInDispose = v;
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(const ProviderScope(child: SizedBox()));

    expect(thrown, isNull);
    expect(
      seenInDispose,
      1,
      reason: 'dispose still gets the real value, not a fallback',
    );
  });
}

class _Probe extends ConsumerStatefulWidget {
  const _Probe({
    required this.provider,
    required this.onDisposeError,
    this.onDisposeValue,
    this.eager = false,
  });

  final Provider<int> provider;
  final void Function(Object) onDisposeError;
  final void Function(int)? onDisposeValue;

  /// Whether to resolve the field while the widget is still alive.
  final bool eager;

  @override
  ConsumerState<_Probe> createState() => _ProbeState();
}

class _ProbeState extends ConsumerState<_Probe> {
  late final int _lazy = ref.read(widget.provider);
  int? _eager;

  @override
  void initState() {
    super.initState();
    if (widget.eager) _eager = ref.read(widget.provider);
  }

  @override
  void dispose() {
    // The reader writes its scroll offset and history entry from here, so it
    // has to read the field whether or not anything else already did.
    try {
      final value = widget.eager ? _eager! : _lazy;
      widget.onDisposeValue?.call(value);
    } catch (e) {
      widget.onDisposeError(e);
    }
    super.dispose();
  }

  // Deliberately does not touch the field: that is the path that breaks.
  @override
  Widget build(BuildContext context) => const SizedBox();
}
