import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/unified_restore.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';
import 'package:mangayomi/modules/onboarding/widgets/language_list.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_controls.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_steps.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// The nav destination for each library, so a library the user does not read
/// can be kept out of the bar.
const _libraryRoutes = {
  ItemType.manga: '/MangaLibrary',
  ItemType.anime: '/AnimeLibrary',
  ItemType.novel: '/NovelLibrary',
};

/// Shown once, on the first launch of a fresh install.
///
/// A new install opens on an empty library, an empty Browse, and a nav bar
/// carrying three libraries the user may well not want. Nothing says that
/// Mangayomi ships with no sources of its own and that supplying them is the
/// first job. This asks the three things worth asking, applies them, and leaves
/// the user on Browse with a repository already added, which is where the
/// extensions it holds are waiting to be installed.
///
/// The steps are: which libraries they read, how those sit in the nav bar, and
/// a repository to stock them from. The middle step is skipped when only one
/// library is chosen, since there is then nothing to arrange.
///
/// No repository is suggested or shipped. The field starts empty and every step
/// can be left without answering.
///
/// ## On a TV
///
/// The same decisions, laid out for a remote instead of a thumb. Typing a
/// repository URL on a d-pad is genuinely unpleasant, so the TV build says out
/// loud that this can be done later from Settings, and Skip is a first-class
/// way off the screen rather than a consolation. The field takes focus on
/// arrival so the first press of OK opens the keyboard, and every choice is a
/// row of [TvPill]s, because a SegmentedButton's internals are not reliably
/// reachable with a d-pad.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A Navigator of its own, because this is mounted from
    // MaterialApp.builder, outside the router's, and everything that floats
    // needs one above it: the back arrow's tooltip, the repository field's
    // selection handles, and the dialogs the restore flow puts up.
    //
    // The state lives in the route rather than around the Navigator, or a
    // step change would rebuild the Navigator and leave the route showing the
    // step before it.
    return Navigator(
      onGenerateRoute: (_) => PageRouteBuilder(
        pageBuilder: (_, _, _) => const _OnboardingBody(),
        // The screen is already being faded in by the caller; a second
        // transition here would fight it.
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

class _OnboardingBody extends ConsumerStatefulWidget {
  const _OnboardingBody();

  @override
  ConsumerState<_OnboardingBody> createState() => _OnboardingScreenState();
}

enum _Step { language, libraries, navigation, repository }

class _OnboardingScreenState extends ConsumerState<_OnboardingBody>
    with WidgetsBindingObserver {
  final _controller = TextEditingController();

  _Step _step = _firstStep;

  /// Which way the last step change went, so the new words arrive from the
  /// side they came from. Going back animating like going forward is what made
  /// the movement feel arbitrary.
  bool _forward = true;

  /// A television only ever reads anime, so the question is not asked there
  /// and this is the answer. Everywhere else it starts with everything ticked
  /// and the reader narrows it.
  final Set<ItemType> _libraries = isTv
      ? {ItemType.anime}
      : {...ItemType.values};

  /// Whether the navigation groups the libraries behind one Library tab, and
  /// Updates and History behind one Activity tab. Starts on the app's own
  /// setting, which is on for a new install.
  late bool _mergeLibraries = ref.read(navGroupingProvider);
  ItemType _repoType = ItemType.manga;

  bool _adding = false;
  String? _error;
  Repo? _added;

  /// The library the repository was filed under, which is not necessarily
  /// [_repoType] by the time the user leaves: they can change the picker, or
  /// go back and stop reading that library altogether.
  ItemType? _addedFor;

  /// Whether a folder was added in the local folder section.
  bool _hasAddedLocalFolder = false;

  @override
  void initState() {
    super.initState();
    // Back has to be claimed from the binding, not from a route or a Router.
    // This screen replaces MaterialApp.builder's child, which puts it above
    // both the router and its Navigator, so a PopScope never sees the press
    // and BackButtonListener cannot find a Router to ask. Observers are
    // offered the press in reverse order of registration, and this one
    // registers after the router, so it gets first refusal for as long as it
    // is on screen.
    WidgetsBinding.instance.addObserver(this);
    // The very first question is asked in the reader's language when the
    // app speaks it, not in English.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(l10nLocaleStateProvider.notifier).adoptDeviceLocaleIfUnset();
      }
    });
    // A television never visits the library step, so the step that would have
    // written the choice never runs. Write it here instead, or the answer the
    // flow made on the reader's behalf would be silently dropped and manga and
    // novel would stay in the rail.
    if (isTv) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _applyLibraries();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /// Always handled, so back never reaches the router underneath and pops from
  /// behind a first run that is still going. On the first step there is
  /// nothing behind it, so it does nothing and Skip stays the way out.
  @override
  Future<bool> didPopRoute() async {
    if (!_adding && _step != _firstStep) _back();
    return true;
  }

  /// How long a step change takes, or nothing at all when the platform has
  /// been asked to keep still.
  /// A single frame rather than [Duration.zero], because the implicit
  /// animations assert on a zero-length controller.
  Duration get _motion => MediaQuery.disableAnimationsOf(context)
      ? const Duration(milliseconds: 1)
      : const Duration(milliseconds: 260);

  bool get _urlLooksValid {
    final text = _controller.text.trim();
    return text.isNotEmpty && Uri.tryParse(text)?.isAbsolute == true;
  }

  /// The chosen libraries in the order the nav bar shows them, so the
  /// repository step offers them the same way round.
  List<ItemType> get _chosen =>
      ItemType.values.where(_libraries.contains).toList();

  /// The steps that will actually be shown, in order.
  ///
  /// Not a constant: the arrange step drops out for a single library or a wide
  /// window, so the flow is two steps long as often as three.
  List<_Step> get _visibleSteps => [
    _Step.language,
    if (!isTv) _Step.libraries,
    if (_shouldArrangeBar) _Step.navigation,
    _Step.repository,
  ];

  /// Where the flow starts: the language, since every word after it depends
  /// on it. A television then skips straight to the source, because the two
  /// questions between have one answer each there: anime, and a rail rather
  /// than a bar.
  static const _Step _firstStep = _Step.language;

  /// Whether the arrange step has anything to offer: nothing with one library,
  /// and a television keeps one destination per route whatever the answer.
  bool get _shouldArrangeBar => _chosen.length > 1 && !isTv;

  void _next() {
    if (_step == _Step.language) {
      setState(() {
        _forward = true;
        _step = isTv ? _Step.repository : _Step.libraries;
      });
      return;
    }
    if (_step == _Step.libraries) {
      _applyLibraries();
      setState(() {
        _forward = true;
        _repoType = _chosen.first;
        _step = _shouldArrangeBar ? _Step.navigation : _Step.repository;
      });
      return;
    }
    // Shiori's grouping, which also folds Updates and History into Activity.
    // The older swap-the-bar switch is left off so the two never stack.
    ref.read(navGroupingProvider.notifier).set(_mergeLibraries);
    ref.read(mergeLibraryNavMobileStateProvider.notifier).set(false);
    setState(() {
      _forward = true;
      _step = _Step.repository;
    });
  }

  /// Runs the existing restore flow, then leaves.
  ///
  /// A backup carries repositories, library and settings, which answers every
  /// question this screen asks. Anyone who has one should not have to walk the
  /// steps first and find Settings afterwards. Mangayomi's own backups and
  /// Mihon, Aniyomi and Neko ones all go through the same picker.
  Future<void> _restore() async {
    final restored = await performRestore(context, ref);
    if (!mounted) return;
    // Nothing was restored, so nothing has been answered. Backing out of the
    // file picker used to drop the user into an empty library, which is the
    // opposite of what cancelling should do.
    if (!restored) return;
    // Whether the backup brought sources with it depends on what it was. A
    // Mangayomi backup carries the repositories, but only when its settings
    // were included in it, and a Mihon, Aniyomi or Neko backup references its
    // own ecosystem's extensions and never carries Mangayomi repositories.
    //
    // So ask rather than assume. Repositories present means the rest of this
    // screen has been answered already; none means the one question still
    // worth asking is where sources come from.
    if (_hasAnyRepo) {
      ref.read(onboardingCompletedStateProvider.notifier).complete();
    } else {
      setState(() {
        _forward = true;
        _step = _Step.repository;
      });
    }
  }

  /// Whether any library has a repository, asked after a restore that may have
  /// brought some in.
  bool get _hasAnyRepo => ItemType.values.any(
    (type) => ref.read(extensionsRepoStateProvider(type)).isNotEmpty,
  );

  /// Returns to the previous question, skipping the arrange step when it was
  /// skipped on the way in.
  ///
  /// Nothing is undone. Each step applies its answer as it is left, and coming
  /// back and going forward again simply applies the new one.
  void _back() {
    final steps = _visibleSteps;
    final index = steps.indexOf(_step);
    if (index <= 0) return;
    setState(() {
      _forward = false;
      _step = steps[index - 1];
    });
  }

  /// Keeps the chosen libraries in the nav bar and hides the rest, leaving
  /// anything else already hidden alone.
  void _applyLibraries() {
    final hidden = ref.read(hideItemsStateProvider).toSet();
    for (final entry in _libraryRoutes.entries) {
      if (_libraries.contains(entry.key)) {
        hidden.remove(entry.value);
      } else {
        hidden.add(entry.value);
      }
    }
    ref.read(hideItemsStateProvider.notifier).set(hidden.toList());
  }

  Future<void> _addRepo() async {
    final l10n = l10nLocalizations(context)!;
    final url = _controller.text.trim();
    setState(() {
      _adding = true;
      _error = null;
    });
    try {
      final repo = await ref.read(getRepoInfosProvider(jsonUrl: url).future);
      if (repo == null) {
        setState(() => _error = l10n.onboarding_repo_failed);
        return;
      }
      final currentRepos = ref.read(extensionsRepoStateProvider(_repoType));
      final alreadyExists = currentRepos.any((r) {
        final rUrl = r.jsonUrl?.trim().toLowerCase();
        final newUrl = repo.jsonUrl?.trim().toLowerCase();
        return (rUrl != null &&
                (rUrl == newUrl || rUrl == '$newUrl/' || '$rUrl/' == newUrl)) ||
            r == repo;
      });
      if (!alreadyExists) {
        await ref.read(extensionsRepoStateProvider(_repoType).notifier).set([
          ...currentRepos,
          repo,
        ]);
      }
      if (!mounted) return;
      setState(() {
        _added = repo;
        _addedFor = _repoType;
        _controller.clear();
      });
    } catch (e) {
      // Whatever went wrong, the user's move is the same: check the address
      // or the connection. A raw exception under a text field is noise.
      setState(() => _error = l10n.onboarding_repo_failed);
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  /// Leaves on the extensions list for the library the repository stocks,
  /// which is where the extensions it provides are waiting to be installed.
  /// That is the next thing to do, so there is no reason to make the user go
  /// and find it.
  ///
  /// Only when a repository was actually added. Somebody who skipped has
  /// nothing to install and is better off in their library.
  void _finish() {
    // The library the repository was filed under, and only while the user
    // still reads it. Changing the picker afterwards, or going back and
    // dropping that library, would otherwise land them on an extensions list
    // with nothing in it.
    final landing = _addedFor;
    if (landing == null || !_libraries.contains(landing)) {
      ref.read(onboardingCompletedStateProvider.notifier).complete();
      return;
    }
    ref
        .read(browseInitialTabProvider.notifier)
        .request(BrowseTab(landing, BrowseTabKind.extensions));
    ref.read(routerProvider).go('/browse');
    // Let Browse build behind this screen before fading to it. Navigating and
    // finishing in the same frame meant the fade ran over the frame the branch
    // was still being created in, tab controllers, permission check and all,
    // which is what made the end of the flow the roughest part of it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(onboardingCompletedStateProvider.notifier).complete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final theme = Theme.of(context);

    final scaffold = Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _content(l10n, theme),
            // A way back to change an earlier answer. Absent on the first
            // step, where there is nothing behind it.
            if (_step != _firstStep)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsets.all(isTv ? 12 : 4).add(tvPageInsets),
                  child: IconButton(
                    onPressed: _adding ? null : _back,
                    tooltip: l10n.go_back,
                    icon: const Icon(Symbols.arrow_back_rounded, fill: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return scaffold;
  }

  Widget _content(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isTv ? 48 : 24, vertical: 32)
            .add(tvPageInsets)
            // Room for the keyboard, so the repository field and the button
            // under it stay reachable on a short screen.
            .add(
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTv ? 620 : 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // The app's own mark rather than a stock glyph. icon.png is
              // the bare silhouette, tinted against the background the same
              // way the More and About screens tint it. The full colour
              // icons are drawn on a white tile, which reads as a bright
              // block on a dark theme, so they are not used here.
              Image.asset(
                appIconAssets[2],
                height: isTv ? 96 : 80,
                color: theme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: ShioriSpace.s16),
              // Above the words rather than below them, so it keeps its place
              // while the content underneath changes height. Not tappable:
              // going forward has to run through _next so each answer is
              // applied, and going back is the arrow's job.
              OnboardingStepDots(
                steps: _visibleSteps.length,
                current: _visibleSteps.indexOf(_step),
                duration: _motion,
              ),
              const SizedBox(height: ShioriSpace.s16),
              // Only the words and the controls change between steps. The mark
              // above keeps its place, so the screen reads as one place being
              // rewritten rather than three screens flipped through. The height
              // eases as well, or the buttons below would jump between steps
              // that say more and steps that say less.
              AnimatedSize(
                duration: _motion,
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: _motion,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    // Forward arrives from below and leaves upward; back does
                    // the reverse, so the movement matches the direction of
                    // travel instead of always looking like a step forward.
                    final entering = child.key == ValueKey(_step);
                    final from = _forward ? 0.05 : -0.05;
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, entering ? from : -from),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _title(l10n),
                        textAlign: TextAlign.center,
                        style:
                            (isTv
                                    ? context.shiori.text.screenTitle
                                    : context.shiori.text.seriesTitle)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.shiori.color.fg,
                                ),
                      ),
                      const SizedBox(height: ShioriSpace.s12),
                      Text(
                        _body(l10n),
                        textAlign: TextAlign.center,
                        style:
                            (isTv
                                    ? context.shiori.text.body
                                    : context.shiori.text.row)
                                .copyWith(
                                  color: context.shiori.color.fgMuted,
                                  height: 1.45,
                                ),
                      ),
                      const SizedBox(height: ShioriSpace.s32),
                      _stepBody(l10n),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: ShioriSpace.s24),
              ShioriButton.quiet(
                onPressed: _adding ? null : _finish,
                label: _leaveLabel(l10n),
              ),
              // Typing a URL on a d-pad is miserable, so on a TV say
              // plainly that leaving now costs nothing.
              if (isTv && _step == _Step.repository && _added == null) ...[
                const SizedBox(height: ShioriSpace.s8),
                Text(
                  l10n.onboarding_later,
                  textAlign: TextAlign.center,
                  style: context.shiori.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) => switch (_step) {
    _Step.language => l10n.onboarding_language_title,
    _Step.libraries => l10n.onboarding_title,
    _Step.navigation => l10n.onboarding_nav_title,
    _Step.repository => l10n.onboarding_repo_title,
  };

  String _body(AppLocalizations l10n) => switch (_step) {
    _Step.language => l10n.onboarding_language_body,
    _Step.libraries => l10n.onboarding_libraries_body,
    _Step.navigation => l10n.onboarding_nav_grouped_body,
    _Step.repository => l10n.onboarding_body,
  };

  String _leaveLabel(AppLocalizations l10n) =>
      _step == _Step.repository && (_added != null || _hasAddedLocalFolder)
      ? l10n.onboarding_continue
      : l10n.onboarding_skip;

  Widget _stepBody(AppLocalizations l10n) => switch (_step) {
    _Step.language => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const OnboardingLanguageList(),
        const SizedBox(height: ShioriSpace.s16),
        ShioriButton(
          expand: true,
          onPressed: _next,
          label: l10n.onboarding_next,
        ),
      ],
    ),
    _Step.libraries => OnboardingLibrariesStep(
      libraries: _libraries,
      onLibraryToggled: (type) => setState(() {
        // One has to stay. An empty bar would have no library in it and the
        // next step nothing to arrange.
        if (!_libraries.remove(type)) {
          _libraries.add(type);
        } else if (_libraries.isEmpty) {
          _libraries.add(type);
        }
      }),
      onNext: _next,
      onRestore: _restore,
    ),
    _Step.navigation => OnboardingNavigationStep(
      mergeLibraries: _mergeLibraries,
      chosen: _chosen,
      onChanged: (merged) => setState(() => _mergeLibraries = merged),
      onNext: _next,
    ),
    _Step.repository => OnboardingRepositoryStep(
      chosen: _chosen,
      repoType: _repoType,
      onRepoTypeChanged: _adding
          ? null
          : (type) => setState(() => _repoType = type),
      controller: _controller,
      isAdding: _adding,
      error: _error,
      added: _added,
      urlLooksValid: _urlLooksValid,
      onChanged: (_) => setState(() => _error = null),
      onSubmitted: (_) => _urlLooksValid && !_adding ? _addRepo() : null,
      onAddRepo: _addRepo,
      onFolderChanged: (hasFolder) =>
          setState(() => _hasAddedLocalFolder = hasFolder),
    ),
  };
}
