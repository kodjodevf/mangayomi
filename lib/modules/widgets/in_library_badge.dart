import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The veil over a cover whose series is already in the library: light,
/// so the cover stays recognisable. A near-black veil used to hide it.
const inLibraryVeil = ShioriScrim.onImage;

/// "In library" on a cover, in the unread colour, so a result the reader
/// already follows reads as such at a glance.
class InLibraryBadge extends StatelessWidget {
  const InLibraryBadge({super.key});

  @override
  Widget build(BuildContext context) => EntryBadgeChip(
    label: context.l10n.in_library,
    tone: context.shiori.color.unread,
  );
}
