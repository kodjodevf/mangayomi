import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:shiori/shiori.dart';

/// The page of a route built without what it shows: go_router can rebuild a
/// page it has lost the `extra` of, which a cast to the route's type turned
/// into a crash (#997).
///
/// The page may not be on top, so it is not taken off the stack from here:
/// it says something went wrong and offers the way back. The error is
/// recorded, and in developer mode the route and what it got are on the page.
class MissingExtraPage extends ConsumerStatefulWidget {
  const MissingExtraPage({
    super.key,
    required this.route,
    required this.expected,
    required this.extra,
  });

  /// The route's name or path.
  final String route;

  /// The type the route's builder takes.
  final Type expected;

  /// What the route got instead.
  final Object? extra;

  String get description =>
      'Route "$route" expected $expected as its extra, got '
      '${extra == null ? 'null' : extra.runtimeType}';

  @override
  ConsumerState<MissingExtraPage> createState() => _MissingExtraPageState();
}

class _MissingExtraPageState extends ConsumerState<MissingExtraPage> {
  @override
  void initState() {
    super.initState();
    recordError(
      StateError(widget.description),
      stack: StackTrace.current,
      source: 'router',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ErrorState(
        detail: ref.watch(developerModeStateProvider)
            ? widget.description
            : null,
        secondaryLabel: context.l10n.go_back,
        secondaryIcon: Symbols.arrow_back_rounded,
        onSecondary: () => context.canPop()
            ? context.pop()
            : context.go(
                homeLocation(
                  ref.read(navigationOrderStateProvider),
                  ref.read(hideItemsStateProvider),
                ),
              ),
      ),
    );
  }
}
