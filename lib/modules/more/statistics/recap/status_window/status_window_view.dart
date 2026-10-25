import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_badges.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_cycle.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_gate.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_notification.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_skills.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_status_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:shiori/shiori.dart';

/// The all-time Status Window for one item type. Always dark.
class StatusWindowView extends ConsumerWidget {
  const StatusWindowView({super.key, required this.itemType});

  final ItemType itemType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(statusWindowProvider(itemType: itemType));
    final text = SwText(ref.watch(recapFontsProvider));
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4,
          colors: [SwColors.bgTop, SwColors.bg],
          stops: [0, 0.6],
        ),
      ),
      child: data.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SwColors.cyan),
        ),
        error: (err, _) => ErrorState(detail: err.toString()),
        data: (data) =>
            _StatusWindowBody(data: data, itemType: itemType, text: text),
      ),
    );
  }
}

class _StatusWindowBody extends StatefulWidget {
  const _StatusWindowBody({
    required this.data,
    required this.itemType,
    required this.text,
  });

  final StatusWindowData data;
  final ItemType itemType;
  final SwText text;

  @override
  State<_StatusWindowBody> createState() => _StatusWindowBodyState();
}

class _StatusWindowBodyState extends State<_StatusWindowBody>
    with SingleTickerProviderStateMixin {
  static const _sections = 7;

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: SwMotion.entrance + SwMotion.stagger * (_sections - 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (!_entrance.isAnimating && _entrance.value == 0) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Window [index] fades and rises in after the ones above it.
  Widget _reveal(int index, Widget child) {
    final total = _entrance.duration!.inMicroseconds;
    final start = (SwMotion.stagger * index).inMicroseconds / total;
    final end = start + SwMotion.entrance.inMicroseconds / total;
    final curve = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end.clamp(0, 1), curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final type = widget.itemType;
    final text = widget.text;
    final sections = [
      SwNotification(data: data, itemType: type, text: text),
      SwStatusPanel(data: data, itemType: type, text: text),
      SwSkills(skills: data.skills, text: text),
      SwBonded(bonded: data.bonded, itemType: type, text: text),
      SwCycle(
        hours: data.hourHistogram,
        weekdays: data.weekdayHistogram,
        text: text,
      ),
      SwBadges(badges: data.badges, itemType: type, text: text),
      SwGate(itemType: type, text: text),
    ];
    assert(sections.length == _sections);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s16,
        ShioriSpace.s16,
        ShioriSpace.s48,
      ),
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: ShioriSpace.s16),
      itemBuilder: (_, i) => _reveal(i, sections[i]),
    );
  }
}
