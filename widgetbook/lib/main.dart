import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:widgetbook/widgetbook.dart';

void main() => runApp(const ShioriCatalogue());

/// One way the app can look: a brightness, the pure black variant, and a
/// density. The catalogue offers every combination the app can produce.
class _Look {
  const _Look(this.brightness, this.density, {this.pureBlack = false});

  final Brightness brightness;
  final ShioriDensity density;
  final bool pureBlack;

  String get name {
    final ground = pureBlack
        ? 'Pure black'
        : brightness == Brightness.light
        ? 'Light'
        : 'Dark';
    return '$ground · ${density.name}';
  }

  ThemeData get theme {
    // Mangayomi's default palette.
    final scheme = FlexColor.schemesList[2];
    return buildShioriTheme(
      brightness: brightness,
      colors: brightness == Brightness.light ? scheme.light : scheme.dark,
      tintSurfaces: false,
      blendLevel: 10,
      density: density,
      pureBlack: pureBlack,
    );
  }
}

final _looks = [
  for (final density in ShioriDensity.values) ...[
    _Look(Brightness.dark, density),
    _Look(Brightness.light, density),
    _Look(Brightness.dark, density, pureBlack: true),
  ],
];

class ShioriCatalogue extends StatelessWidget {
  const ShioriCatalogue({super.key, this.initialRoute = '/'});

  /// Where the catalogue opens, as a Widgetbook route such as
  /// `/?path=components/shioricover/grid`.
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      initialRoute: initialRoute,
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            for (final look in _looks)
              WidgetbookTheme(name: look.name, data: look.theme),
          ],
          themeBuilder: (context, theme, child) => Theme(
            data: theme,
            child: ColoredBox(
              color: theme.scaffoldBackgroundColor,
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!,
                child: child,
              ),
            ),
          ),
        ),
        TextScaleAddon(min: 1, max: 2),
      ],
      directories: catalogue,
    );
  }
}

/// Every use case, by folder and component.
final catalogue = <WidgetbookNode>[
  WidgetbookFolder(
    name: 'Foundations',
    children: [
      WidgetbookComponent(
        name: 'Type scale',
        useCases: [WidgetbookUseCase(name: 'All roles', builder: _type)],
      ),
      WidgetbookComponent(
        name: 'Colours',
        useCases: [
          WidgetbookUseCase(name: 'Inks and status', builder: _colours),
        ],
      ),
    ],
  ),
  WidgetbookFolder(
    name: 'Components',
    children: [
      WidgetbookComponent(
        name: 'ShioriButton',
        useCases: [WidgetbookUseCase(name: 'Variants', builder: _buttons)],
      ),
      WidgetbookComponent(
        name: 'ShioriBadge',
        useCases: [
          WidgetbookUseCase(name: 'Counts', builder: _badges),
          WidgetbookUseCase(name: 'Status chips', builder: _chips),
        ],
      ),
      WidgetbookComponent(
        name: 'ShioriCover',
        useCases: [
          WidgetbookUseCase(name: 'Single', builder: _cover),
          WidgetbookUseCase(name: 'Grid', builder: _grid),
          WidgetbookUseCase(name: 'Grid loading', builder: _gridLoading),
        ],
      ),
      WidgetbookComponent(
        name: 'ShioriListRow',
        useCases: [WidgetbookUseCase(name: 'Rows', builder: _rows)],
      ),
      WidgetbookComponent(
        name: 'ShioriOverlayLabel',
        useCases: [
          WidgetbookUseCase(name: 'Over a page', builder: _overlayLabel),
        ],
      ),
      WidgetbookComponent(
        name: 'ShioriSegmentedControl',
        useCases: [
          WidgetbookUseCase(name: 'Media', builder: _segmented),
          WidgetbookUseCase(name: 'With tabs under it', builder: _switcher),
        ],
      ),
      WidgetbookComponent(
        name: 'Overlay controls',
        useCases: [
          WidgetbookUseCase(name: 'Video player', builder: _playerOverlay),
          WidgetbookUseCase(name: 'Gesture gauges', builder: _gauges),
        ],
      ),
      WidgetbookComponent(
        name: 'ShioriSectionHeader',
        useCases: [
          WidgetbookUseCase(name: 'Default', builder: _header),
          WidgetbookUseCase(name: 'Group label', builder: _groupLabel),
        ],
      ),
      WidgetbookComponent(
        name: 'ShioriEmptyState',
        useCases: [WidgetbookUseCase(name: 'Default', builder: _empty)],
      ),
      WidgetbookComponent(
        name: 'ShioriSkeleton',
        useCases: [WidgetbookUseCase(name: 'Rows', builder: _skeletons)],
      ),
      WidgetbookComponent(
        name: 'ShioriToastCard',
        useCases: [WidgetbookUseCase(name: 'Tones', builder: _toasts)],
      ),
      WidgetbookComponent(
        name: 'Dialog and sheet',
        useCases: [WidgetbookUseCase(name: 'Openers', builder: _overlays)],
      ),
      WidgetbookComponent(
        name: 'Settings rows',
        useCases: [WidgetbookUseCase(name: 'A screen', builder: _settings)],
      ),
      WidgetbookComponent(
        name: 'ShioriMenuButton',
        useCases: [WidgetbookUseCase(name: 'Actions', builder: _menu)],
      ),
      WidgetbookComponent(
        name: 'ShioriLoading',
        useCases: [
          WidgetbookUseCase(name: 'Sizes', builder: _loading),
          WidgetbookUseCase(name: 'Progress bars', builder: _progressBars),
        ],
      ),
    ],
  ),
];

Widget _padded(Widget child) => SingleChildScrollView(
  padding: const EdgeInsets.all(ShioriSpace.s24),
  child: child,
);

Widget _type(BuildContext context) {
  final t = context.shiori.text;
  final fg = context.shiori.color.fg;
  final roles = {
    'screenTitle': t.screenTitle,
    'seriesTitle': t.seriesTitle,
    'section': t.section,
    'card': t.card,
    'body': t.body,
    'row': t.row,
    'meta': t.meta,
    'badge': t.badge,
    'overline': t.overline,
  };
  return _padded(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s16,
      children: [
        for (final MapEntry(:key, :value) in roles.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key,
                style: t.meta.copyWith(color: context.shiori.color.fgMuted),
              ),
              Text(
                'Frieren: Beyond Journey\'s End — 128',
                style: value.copyWith(color: fg),
              ),
            ],
          ),
      ],
    ),
  );
}

Widget _colours(BuildContext context) {
  final c = context.shiori.color;
  Widget swatch(String name, Color fill, Color on) => Container(
    width: 140,
    height: 64,
    padding: const EdgeInsets.all(ShioriSpace.s8),
    decoration: BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(ShioriShape.card),
      border: Border.all(color: c.hairline),
    ),
    child: Text(name, style: context.shiori.text.meta.copyWith(color: on)),
  );
  final status = {
    'unread': c.unread,
    'downloaded': c.downloaded,
    'read': c.read,
    'offline': c.offline,
    'completed': c.completed,
    'newChapter': c.newChapter,
    'error': c.error,
  };
  return _padded(
    Wrap(
      spacing: ShioriSpace.s12,
      runSpacing: ShioriSpace.s12,
      children: [
        swatch('ink0', c.ink0, c.fg),
        swatch('ink1', c.ink1, c.fg),
        swatch('ink2', c.ink2, c.fg),
        swatch('ink3', c.ink3, c.fg),
        swatch('accent', c.accent, c.onAccent),
        for (final MapEntry(:key, :value) in status.entries)
          swatch(key, value.background, value.foreground),
      ],
    ),
  );
}

Widget _buttons(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Resume');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final destructive = context.knobs.boolean(label: 'Destructive');
  final withIcon = context.knobs.boolean(label: 'Icon', initialValue: true);
  final icon = withIcon ? Symbols.play_arrow_rounded : null;
  final onPressed = enabled ? () {} : null;
  return _padded(
    Wrap(
      spacing: ShioriSpace.s12,
      runSpacing: ShioriSpace.s12,
      children: [
        ShioriButton(
          label: label,
          icon: icon,
          destructive: destructive,
          onPressed: onPressed,
        ),
        ShioriButton.secondary(
          label: label,
          icon: icon,
          destructive: destructive,
          onPressed: onPressed,
        ),
        ShioriButton.quiet(
          label: label,
          icon: icon,
          destructive: destructive,
          onPressed: onPressed,
        ),
      ],
    ),
  );
}

Widget _badges(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 12,
    max: 1200,
  );
  return _padded(
    Wrap(
      spacing: ShioriSpace.s12,
      runSpacing: ShioriSpace.s12,
      children: [
        for (final kind in ShioriStatusKind.values)
          ShioriBadge(count, kind: kind),
      ],
    ),
  );
}

Widget _chips(BuildContext context) => _padded(
  const Wrap(
    spacing: ShioriSpace.s8,
    runSpacing: ShioriSpace.s8,
    children: [
      ShioriStatusChip(
        kind: ShioriStatusKind.completed,
        label: 'Completed',
        icon: Symbols.done_all_rounded,
      ),
      ShioriStatusChip(kind: ShioriStatusKind.newChapter, label: 'New chapter'),
      ShioriStatusChip(
        kind: ShioriStatusKind.offline,
        label: 'Offline',
        icon: Symbols.cloud_off_rounded,
      ),
      ShioriStatusChip(
        kind: ShioriStatusKind.error,
        label: 'Source error',
        icon: Symbols.error_rounded,
      ),
    ],
  ),
);

/// Covers need no network here: the catalogue draws the placeholder, which is
/// what a cover looks like before its image arrives.
ShioriCover _sampleCover(BuildContext context, int index) => ShioriCover(
  image: null,
  title: _titles[index % _titles.length],
  unread: (index * 7) % 23,
  downloaded: index.isEven,
  progress: (index % 5) / 5,
);

const _titles = [
  'Frieren',
  'Vagabond',
  'Dungeon Meshi',
  'Blue Period',
  'Kingdom',
  'Witch Hat Atelier',
];

Widget _cover(BuildContext context) {
  final knobs = context.knobs;
  return Center(
    child: SizedBox(
      width: 160,
      child: ShioriCoverTile(
        subtitle: 'Chapter 128',
        cover: ShioriCover(
          image: null,
          title: knobs.string(label: 'Title', initialValue: 'Frieren'),
          unread: knobs.int.slider(label: 'Unread', initialValue: 3, max: 1200),
          downloaded: knobs.boolean(label: 'Downloaded', initialValue: true),
          progress: knobs.double.slider(
            label: 'Progress',
            initialValue: 0.4,
            min: 0,
            max: 1,
          ),
          selected: knobs.boolean(label: 'Selected'),
          onTap: () {},
        ),
      ),
    ),
  );
}

Widget _grid(BuildContext context) => ShioriCoverGrid(
  itemCount: 24,
  itemBuilder: (context, index) => ShioriCoverTile(
    cover: _sampleCover(context, index),
    subtitle: 'Chapter ${index + 1}',
  ),
);

Widget _gridLoading(BuildContext context) => const ShioriCoverGrid.skeleton();

Widget _header(BuildContext context) => _padded(
  ShioriSectionHeader(
    title: context.knobs.string(
      label: 'Title',
      initialValue: 'Continue reading',
    ),
    count: context.knobs.int.slider(label: 'Count', initialValue: 8, max: 99),
    actionLabel: 'See all',
    onAction: () {},
  ),
);

/// The one label of a group: over a settings group, as a section header's
/// overline, or over a list's own groups.
Widget _groupLabel(BuildContext context) => ListView(
  children: [
    ShioriSectionHeader(
      title: context.knobs.string(label: 'Title', initialValue: 'Today'),
      count: 3,
      overline: true,
    ),
    for (final title in _titles.take(3))
      ShioriListRow(
        leading: const ShioriThumbnail(child: SizedBox.expand()),
        title: title,
        subtitle: 'Chapter 12 · 18:40',
      ),
    const ShioriSettingsGroup(
      title: 'Reading',
      children: [
        ShioriSettingRow(title: 'Keep the screen on'),
        ShioriSettingRow(title: 'Crop borders'),
      ],
    ),
    const Padding(
      padding: EdgeInsets.all(ShioriSpace.s16),
      child: ShioriGroupLabel('Pinned'),
    ),
  ],
);

Widget _empty(BuildContext context) => ShioriEmptyState(
  icon: Symbols.collections_bookmark_rounded,
  title: context.knobs.string(
    label: 'Title',
    initialValue: 'Your library is empty',
  ),
  message: context.knobs.string(
    label: 'Message',
    initialValue: 'Add a series from Browse and it will appear here.',
  ),
  actionLabel: 'Browse',
  onAction: () {},
  compact: context.knobs.boolean(label: 'Compact'),
);

Widget _skeletons(BuildContext context) => const Column(
  children: [
    ShioriSkeletonRow(),
    ShioriSkeletonRow(),
    ShioriSkeletonRow(leading: false),
  ],
);

Widget _toasts(BuildContext context) {
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Library updated: 12 new chapters.',
    maxLines: 4,
  );
  final withAction = context.knobs.boolean(label: 'Action', initialValue: true);
  return _padded(
    Column(
      spacing: ShioriSpace.s16,
      children: [
        for (final tone in ShioriToastTone.values)
          ShioriToastCard(
            message: message,
            tone: tone,
            actions: [if (withAction) ShioriToastAction('Details', () {})],
          ),
      ],
    ),
  );
}

Widget _overlays(BuildContext context) => _padded(
  Wrap(
    spacing: ShioriSpace.s12,
    runSpacing: ShioriSpace.s12,
    children: [
      ShioriButton.secondary(
        label: 'Confirm',
        onPressed: () => showShioriConfirm(
          context,
          title: 'Remove from library?',
          message: 'Downloaded chapters stay on the device.',
          confirmLabel: 'Remove',
          destructive: true,
        ),
      ),
      ShioriButton.secondary(
        label: 'Sheet',
        onPressed: () => showShioriSheet<void>(
          context,
          title: 'Sort by',
          builder: (context) => ListView(
            shrinkWrap: true,
            children: [
              for (final label in [
                'Alphabetical',
                'Last read',
                'Unread count',
                'Date added',
              ])
                ListTile(
                  title: Text(label),
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        ),
      ),
      ShioriButton.secondary(
        label: 'Choice',
        onPressed: () => showShioriChoice<String>(
          context,
          title: 'Reading mode',
          selected: 'rtl',
          options: _readingModes,
        ),
      ),
      ShioriButton.secondary(
        label: 'Multi choice',
        onPressed: () => showShioriMultiChoice<String>(
          context,
          title: 'Languages',
          selected: {'en', 'fr'},
          options: const [
            ShioriChoice('en', 'English'),
            ShioriChoice('fr', 'French'),
            ShioriChoice('ja', 'Japanese'),
            ShioriChoice('ko', 'Korean'),
          ],
        ),
      ),
      ShioriButton.secondary(
        label: 'Prompt',
        onPressed: () => showShioriPrompt(
          context,
          title: 'Rename category',
          confirmLabel: 'Rename',
          initialValue: 'Reading',
          validator: (t) => t == 'Default' ? 'That name is taken' : null,
        ),
      ),
    ],
  ),
);

const _readingModes = [
  ShioriChoice('ltr', 'Left to right'),
  ShioriChoice('rtl', 'Right to left'),
  ShioriChoice('vertical', 'Vertical'),
  ShioriChoice('webtoon', 'Webtoon', subtitle: 'One long strip, no gaps'),
];

/// A settings screen as the app builds them: groups of rows, each kind once.
Widget _settings(BuildContext context) {
  var mode = 'rtl';
  var keepOn = true;
  var crop = false;
  var brightness = 0.0;
  return StatefulBuilder(
    builder: (context, setState) => ListView(
      children: [
        ShioriSettingsGroup(
          title: 'Reading',
          children: [
            ShioriValueRow<String>(
              title: 'Default reading mode',
              icon: Symbols.chrome_reader_mode_rounded,
              value: mode,
              options: _readingModes,
              onChanged: (v) => setState(() => mode = v),
            ),
            ShioriSwitchRow(
              title: 'Keep screen on',
              icon: Symbols.light_mode_rounded,
              value: keepOn,
              onChanged: (v) => setState(() => keepOn = v),
            ),
            ShioriSwitchRow(
              title: 'Crop borders',
              subtitle: 'Trims the white margins scans often have',
              value: crop,
              onChanged: (v) => setState(() => crop = v),
            ),
          ],
        ),
        ShioriSettingsGroup(
          title: 'Display',
          footer: 'Applies to every series that has no setting of its own.',
          children: [
            ShioriSliderRow(
              title: 'Brightness',
              icon: Symbols.brightness_6_rounded,
              value: brightness,
              min: -50,
              max: 50,
              divisions: 100,
              valueLabel: (v) => '${v.round()} %',
              defaultValue: 0,
              onReset: () => setState(() => brightness = 0),
              resetTooltip: 'Reset',
              onChanged: (v) => setState(() => brightness = v),
            ),
          ],
        ),
        ShioriSettingsGroup(
          title: 'Data',
          children: [
            ShioriSettingRow(
              title: 'Storage location',
              subtitle: '/storage/emulated/0/Mangayomi',
              icon: Symbols.folder_rounded,
              onTap: () {},
            ),
            ShioriSettingRow(
              title: 'Clear chapter cache',
              icon: Symbols.delete_rounded,
              destructive: true,
              onTap: () {},
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _menu(BuildContext context) => Align(
  alignment: Alignment.topRight,
  child: ShioriMenuButton(
    tooltip: 'More',
    items: [
      ShioriMenuItem(
        label: 'Refresh',
        icon: Symbols.refresh_rounded,
        onSelected: () {},
      ),
      ShioriMenuItem(
        label: 'Show downloaded only',
        checked: true,
        onSelected: () {},
      ),
      ShioriMenuItem(
        label: 'Share',
        icon: Symbols.share_rounded,
        onSelected: () {},
      ),
      null,
      ShioriMenuItem(
        label: 'Remove from library',
        icon: Symbols.delete_rounded,
        destructive: true,
        onSelected: () {},
      ),
    ],
  ),
);

Widget _loading(BuildContext context) => const Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ShioriLoading(label: 'Asking the source…'),
    ShioriLoading(value: 0.4, label: 'Restoring backup · 40 %'),
    ShioriLoading.inline(),
  ],
);

/// One bar for every progress: known, running on its own, and failed.
Widget _progressBars(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'Value',
    initialValue: 0.4,
    min: 0,
    max: 1,
  );
  return _padded(
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ShioriSpace.s24,
      children: [
        ShioriProgressBar(value: value),
        const ShioriProgressBar(),
        ShioriProgressBar(
          value: value,
          height: 4,
          color: context.shiori.color.error.foreground,
        ),
        ShioriProgressBar(value: value, height: 2),
      ],
    ),
  );
}

Widget _rows(BuildContext context) {
  final dimmed = context.knobs.boolean(label: 'Dimmed');
  final selected = context.knobs.boolean(label: 'Selected');
  return ListView(
    children: [
      for (final (i, title) in _titles.indexed)
        ShioriListRow(
          leading: const ShioriThumbnail(child: SizedBox.expand()),
          title: title,
          subtitle: 'Chapter ${(i + 1) * 12} · 18:40',
          dimmed: dimmed && i.isOdd,
          selected: selected && i == 0,
          onTap: () {},
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.download_rounded),
          ),
        ),
    ],
  );
}

/// On both extremes of what it floats over: a white page and a black frame.
Widget _overlayLabel(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '12 / 48');
  return Row(
    children: [
      for (final ground in [Colors.white, Colors.black])
        Expanded(
          child: ColoredBox(
            color: ground,
            child: Center(child: ShioriOverlayLabel(label)),
          ),
        ),
    ],
  );
}

Widget _segmented(BuildContext context) {
  final selected = context.knobs.object.segmented(
    label: 'Selected',
    options: const ['Manga', 'Anime', 'Novel'],
  );
  final badge = context.knobs.int.slider(
    label: 'Anime badge',
    initialValue: 4,
    max: 120,
  );
  return _padded(
    ShioriSegmentedControl<String>(
      segments: [
        ShioriSegment(
          value: 'Manga',
          label: 'Manga',
          icon: Symbols.book_rounded,
        ),
        ShioriSegment(
          value: 'Anime',
          label: 'Anime',
          icon: Symbols.video_library_rounded,
          badge: badge,
        ),
        ShioriSegment(
          value: 'Novel',
          label: 'Novel',
          icon: Symbols.auto_stories_rounded,
        ),
      ],
      selected: selected,
      onSelected: (_) {},
    ),
  );
}

/// The two levels of switching as a screen stacks them: the media in a
/// segmented control, then the pages of that media as tabs with an accent
/// pill that follows a swipe.
Widget _switcher(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Column(
      children: [
        _padded(
          ShioriSegmentedControl<String>(
            segments: const [
              ShioriSegment(
                value: 'Manga',
                label: 'Manga',
                icon: Symbols.book_rounded,
              ),
              ShioriSegment(
                value: 'Anime',
                label: 'Anime',
                icon: Symbols.video_library_rounded,
                badge: 4,
              ),
              ShioriSegment(
                value: 'Novel',
                label: 'Novel',
                icon: Symbols.auto_stories_rounded,
              ),
            ],
            selected: 'Manga',
            onSelected: (_) {},
          ),
        ),
        const TabBar(
          tabs: [
            Tab(text: 'Sources'),
            Tab(text: 'Extensions'),
          ],
        ),
        const Expanded(
          child: TabBarView(
            children: [
              Center(child: Text('Sources')),
              Center(child: Text('Extensions')),
            ],
          ),
        ),
      ],
    ),
  );
}

/// The player's controls over a frame: identity and quick settings at the
/// top, the one accented control in the middle, the floating panel at the
/// foot with the timeline, the settings in sight and the next episode.
Widget _playerOverlay(BuildContext context) {
  final ground = context.knobs.object.dropdown<Color>(
    label: 'Frame',
    options: const [Colors.black, Colors.white],
    labelBuilder: (c) => c == Colors.black ? 'Dark frame' : 'Light frame',
  );
  final tokens = context.shiori;
  return ColoredBox(
    color: ground,
    child: Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: ShioriScrim.onImage),
        Positioned(
          top: ShioriSpace.s8,
          left: ShioriSpace.s8,
          right: ShioriSpace.s8,
          child: Row(
            children: [
              ShioriOverlayIconButton(
                icon: const Icon(Symbols.keyboard_arrow_down_rounded),
                tooltip: 'Close',
                onPressed: () {},
              ),
              Expanded(
                child: Text(
                  'Naruto: Shippuuden · Episode 495',
                  style: tokens.text.section.copyWith(color: Colors.white),
                ),
              ),
              ShioriOverlayPill(
                icon: Symbols.high_quality_rounded,
                label: '1080p',
                tooltip: 'Quality',
                onTap: () {},
              ),
              ShioriOverlayPill(
                icon: Symbols.subtitles_rounded,
                label: 'FR',
                tooltip: 'Subtitles',
                onTap: () {},
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s48,
            children: [
              ShioriOverlayIconButton(
                icon: const Icon(Symbols.replay_10_rounded),
                tooltip: 'Back 10 seconds',
                onPressed: () {},
              ),
              ShioriOverlayIconButton(
                icon: const Icon(Symbols.pause_rounded, fill: 1),
                tooltip: 'Pause',
                emphasized: true,
                size: 32,
                onPressed: () {},
              ),
              ShioriOverlayIconButton(
                icon: const Icon(Symbols.forward_10_rounded),
                tooltip: 'Forward 10 seconds',
                onPressed: () {},
              ),
            ],
          ),
        ),
        Positioned(
          left: ShioriSpace.s8,
          right: ShioriSpace.s8,
          bottom: ShioriSpace.s8,
          child: ShioriOverlayPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: ShioriSpace.s12,
                  children: [
                    const Text('12:04'),
                    Expanded(child: Slider(value: 0.52, onChanged: (_) {})),
                    const Text('−11:16'),
                  ],
                ),
                Row(
                  children: [
                    ShioriOverlayPill(
                      icon: Symbols.lock_open_rounded,
                      tooltip: 'Lock',
                      compact: true,
                      onTap: () {},
                    ),
                    ShioriOverlayPill(
                      icon: Symbols.speed_rounded,
                      label: '1.0×',
                      compact: true,
                      onTap: () {},
                    ),
                    ShioriOverlayPill(
                      icon: Symbols.fit_screen_rounded,
                      label: 'Fit',
                      compact: true,
                      onTap: () {},
                    ),
                    const Spacer(),
                    ShioriOverlayPill(
                      icon: Symbols.video_library_rounded,
                      label: 'Episodes',
                      compact: true,
                      onTap: () {},
                    ),
                    ShioriOverlayPill(
                      label: 'Next',
                      trailingIcon: Symbols.skip_next_rounded,
                      emphasized: true,
                      compact: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _gauges(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'Level',
    initialValue: 0.6,
    max: 1,
  );
  return ColoredBox(
    color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShioriGestureGauge(
          value: value,
          icon: Symbols.brightness_6_rounded,
          label: 'Brightness',
        ),
        ShioriGestureGauge(
          value: value,
          icon: Symbols.volume_up_rounded,
          label: 'Volume',
        ),
      ],
    ),
  );
}
