import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/tracker_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/external_browser.dart';
import 'package:mangayomi/services/trackers/track_progress.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:numberpicker/numberpicker.dart';

/// One series on one tracker: what it is matched to, then its status,
/// progress and score, and when it was started and finished.
///
/// Each value sits in its own cell under a label, so the card reads at a
/// glance and every value is one tap from being changed. The rest — another
/// match, the tracker's page, no longer tracking it — is in the card's menu,
/// where removing it asks first.
class TrackerWidget extends ConsumerStatefulWidget {
  final ItemType itemType;
  final Track trackRes;
  final int mangaId;
  final int syncId;

  /// Inside a list of one tracker's entries: no logo, and no other match
  /// to pick from there.
  final bool hide;
  const TrackerWidget({
    super.key,
    required this.itemType,
    required this.syncId,
    required this.trackRes,
    required this.mangaId,
    this.hide = false,
  });

  @override
  ConsumerState<TrackerWidget> createState() => _TrackerWidgetState();
}

class _TrackerWidgetState extends ConsumerState<TrackerWidget> {
  @override
  initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Yield to microtask queue so initState completes before async work
    await Future(() {});
    try {
      final findManga = await _notifier().findManga();
      if (mounted && findManga != null) {
        ref
            .read(tracksProvider(syncId: widget.syncId).notifier)
            .updateTrackManga(findManga, widget.itemType);
      }
    } catch (e, stack) {
      recordError(e, stack: stack, source: 'tracker card');
    }
  }

  Track get _track => widget.trackRes;
  bool get _isLocal => widget.syncId == TrackerProviders.local.syncId;

  TrackState _notifier([Track? track]) => ref.read(
    trackStateProvider(
      track: track ?? _track,
      itemType: widget.itemType,
      widgetRef: ref,
    ).notifier,
  );

  /// Applies [change] and sends it to the tracker. A tracker that does not
  /// answer says so, rather than the card quietly showing what it did not
  /// keep.
  Future<void> _save(void Function(Track track) change) async {
    change(_track);
    try {
      await _notifier(_track).updateManga();
    } catch (e, stack) {
      toastError(e, stack: stack, source: 'tracker update');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final c = tokens.color;
    final isManga = widget.itemType != ItemType.anime;
    final status = toTrackStatus(_track.status, widget.itemType, widget.syncId);
    final read = _track.lastChapterRead ?? 0;
    final total = _track.totalChapter ?? 0;
    final score = _track.score ?? 0;
    final canAdvance =
        status != TrackStatus.completed && (total == 0 || read < total);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: Border.all(color: c.hairline, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ShioriSpace.s8,
          children: [
            _header(context),
            Row(
              spacing: ShioriSpace.s8,
              children: [
                Expanded(
                  child: _Cell(
                    icon: _statusIcon(status),
                    iconColor: status == TrackStatus.completed
                        ? c.completed.foreground
                        : c.accentInk,
                    label: l10n.status,
                    value: getTrackStatus(status, context),
                    onTap: _pickStatus,
                  ),
                ),
                Expanded(
                  child: _Cell(
                    icon: Symbols.star_rounded,
                    label: l10n.score,
                    value: score > 0 ? _scoreLabel(score) : null,
                    onTap: _pickScore,
                  ),
                ),
              ],
            ),
            _Cell(
              icon: isManga
                  ? Symbols.auto_stories_rounded
                  : Symbols.play_circle_rounded,
              label: isManga ? l10n.chapters : l10n.episodes,
              value: read == 0 && total == 0
                  ? l10n.not_started
                  : total > 0
                  ? '$read / $total'
                  : '$read',
              onTap: _pickProgress,
              trailing: canAdvance
                  ? IconButton.filledTonal(
                      tooltip: l10n.track_add_one,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _save(
                        (t) => advanceTrack(
                          t,
                          widget.itemType,
                          DateTime.now().millisecondsSinceEpoch,
                        ),
                      ),
                      icon: const Icon(Symbols.add_rounded),
                    )
                  : null,
              footer: total > 0
                  ? ShioriProgressBar(
                      value: read / total,
                      height: 4,
                      color: status == TrackStatus.completed
                          ? c.completed.foreground
                          : null,
                    )
                  : null,
            ),
            Row(
              spacing: ShioriSpace.s8,
              children: [
                Expanded(
                  child: _dateCell(
                    context,
                    icon: Symbols.event_rounded,
                    label: l10n.start_date,
                    value: _track.startedReadingDate,
                    onPicked: (date) =>
                        _save((t) => t.startedReadingDate = date),
                  ),
                ),
                Expanded(
                  child: _dateCell(
                    context,
                    icon: Symbols.flag_rounded,
                    label: l10n.finish_date,
                    value: _track.finishedReadingDate,
                    onPicked: (date) =>
                        _save((t) => t.finishedReadingDate = date),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final url = _track.trackingUrl ?? '';
    final canRematch = !widget.hide && !_isLocal;
    return Row(
      spacing: ShioriSpace.s12,
      children: [
        if (!widget.hide) TrackerLogo(syncId: widget.syncId, size: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _track.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.card.copyWith(color: tokens.color.fg),
              ),
              Text(
                trackInfos(widget.syncId).$2,
                maxLines: 1,
                style: tokens.text.meta.copyWith(color: tokens.color.fgMuted),
              ),
            ],
          ),
        ),
        ShioriMenuButton(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          items: [
            if (canRematch)
              ShioriMenuItem(
                icon: Symbols.manage_search_rounded,
                label: l10n.track_change_match,
                onSelected: _rematch,
              ),
            if (url.isNotEmpty)
              ShioriMenuItem(
                icon: Symbols.public_rounded,
                label: l10n.open_in_browser,
                onSelected: () => ExternalBrowser.open(url),
              ),
            null,
            ShioriMenuItem(
              icon: Symbols.delete_rounded,
              label: l10n.track_remove,
              destructive: true,
              onSelected: _remove,
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateCell(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int? value,
    required ValueChanged<int> onPicked,
  }) {
    final isSet = value != null && value > 0;
    return _Cell(
      icon: icon,
      label: label,
      value: isSet
          ? dateFormat(
              value.toString(),
              ref: ref,
              useRelativeTimesTamps: false,
              context: context,
            )
          : null,
      onTap: () async {
        final date = await showDatePicker(
          helpText: label,
          locale: ref.read(l10nLocaleStateProvider),
          context: context,
          initialDate: isSet
              ? DateTime.fromMillisecondsSinceEpoch(value)
              : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) onPicked(date.millisecondsSinceEpoch);
      },
    );
  }

  /// The score on its scale when that is out of ten; AniList's own formats
  /// say theirs.
  String _scoreLabel(int score) {
    final notifier = _notifier();
    return notifier.getScoreMaxValue() == 10
        ? '$score / 10'
        : notifier.displayScore(score);
  }

  Future<void> _pickStatus() async {
    final picked = await showShioriChoice<TrackStatus>(
      context,
      title: context.l10n.status,
      selected: toTrackStatus(_track.status, widget.itemType, widget.syncId),
      options: [
        for (final status in _notifier().getStatusList())
          ShioriChoice(status, getTrackStatus(status, context)),
      ],
    );
    if (picked != null) await _save((t) => t.status = picked);
  }

  Future<void> _pickScore() async {
    final notifier = _notifier();
    final step = notifier.getScoreStep();
    final picked = await showShioriChoice<int>(
      context,
      title: context.l10n.score,
      selected: _track.score,
      options: [
        for (var v = 0; v <= notifier.getScoreMaxValue(); v += step)
          ShioriChoice(v, v == 0 ? '–' : notifier.getTextMapper('$v')),
      ],
    );
    if (picked != null) await _save((t) => t.score = picked);
  }

  Future<void> _pickProgress() async {
    final l10n = context.l10n;
    final total = _track.totalChapter ?? 0;
    var value = _track.lastChapterRead ?? 0;
    // A wheel, not a list: the count runs to the thousands.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ShioriDialog(
        title: widget.itemType != ItemType.anime
            ? l10n.chapters
            : l10n.episodes,
        content: StatefulBuilder(
          builder: (context, setState) => NumberPicker(
            value: value,
            minValue: 0,
            maxValue: total > 0 ? total : 10000,
            haptics: true,
            textStyle: context.shiori.text.row.copyWith(
              color: context.shiori.color.fgMuted,
            ),
            selectedTextStyle: context.shiori.text.seriesTitle.copyWith(
              color: context.shiori.color.accentInk,
            ),
            onChanged: (v) => setState(() => value = v),
          ),
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.ok,
        ),
      ),
    );
    if (confirmed == true) await _save((t) => t.lastChapterRead = value);
  }

  Future<void> _rematch() async {
    final trackSearch = await trackersSearchDraggableMenu(
      context,
      itemType: widget.itemType,
      track: _track,
    );
    if (trackSearch == null) return;
    try {
      await ref
          .read(
            trackStateProvider(
              track: null,
              itemType: widget.itemType,
              widgetRef: ref,
            ).notifier,
          )
          .setTrackSearch(trackSearch, widget.mangaId, widget.syncId);
    } catch (e, stack) {
      toastError(e, stack: stack, source: 'tracker match');
    }
  }

  Future<void> _remove() async {
    final l10n = context.l10n;
    final tracker = trackInfos(widget.syncId).$2;
    final confirmed = await showShioriConfirm(
      context,
      title: l10n.track_remove,
      message: _isLocal
          ? l10n.track_remove_local_msg
          : l10n.track_remove_online_msg(tracker),
      confirmLabel: l10n.remove,
      destructive: true,
    );
    if (!confirmed) return;
    ref
        .read(tracksProvider(syncId: widget.syncId).notifier)
        .deleteTrackManga(_track);
  }
}

IconData _statusIcon(TrackStatus status) => switch (status) {
  TrackStatus.reading => Symbols.auto_stories_rounded,
  TrackStatus.watching => Symbols.play_circle_rounded,
  TrackStatus.completed => Symbols.check_circle_rounded,
  TrackStatus.onHold => Symbols.pause_circle_rounded,
  TrackStatus.dropped => Symbols.cancel_rounded,
  TrackStatus.planToRead || TrackStatus.planToWatch => Symbols.schedule_rounded,
  TrackStatus.reReading || TrackStatus.reWatching => Symbols.replay_rounded,
};

/// One value of the card: its label over it, the whole cell a button that
/// changes it. A value not set yet shows a dash, muted.
class _Cell extends StatelessWidget {
  const _Cell({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.iconColor,
    this.trailing,
    this.footer,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;
  final String? value;
  final VoidCallback onTap;

  /// A quicker way to change it, beside the value.
  final Widget? trailing;

  /// Under the value, across the cell.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    return Material(
      color: c.ink2,
      borderRadius: BorderRadius.circular(ShioriShape.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: tokens.density.minTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ShioriSpace.s12,
              vertical: ShioriSpace.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: ShioriSpace.s8,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: ShioriSpace.s4,
                        children: [
                          Row(
                            spacing: ShioriSpace.s4,
                            children: [
                              Icon(
                                icon,
                                size: tokens.scaled(16),
                                fill: 1,
                                color: iconColor ?? c.fgMuted,
                              ),
                              Flexible(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tokens.text.meta.copyWith(
                                    color: c.fgMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            value ?? '–',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tokens.text.row.copyWith(
                              color: value == null ? c.fgMuted : c.fg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ?trailing,
                  ],
                ),
                ?footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
