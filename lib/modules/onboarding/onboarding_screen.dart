import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum _Step { libraries, navigation, repository }

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();

  _Step _step = _Step.libraries;
  final Set<ItemType> _libraries = {...ItemType.values};
  bool _mergeLibraries = false;
  ItemType _repoType = ItemType.manga;

  bool _adding = false;
  String? _error;
  Repo? _added;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _urlLooksValid {
    final text = _controller.text.trim();
    return text.isNotEmpty && Uri.tryParse(text)?.isAbsolute == true;
  }

  /// The chosen libraries in the order the nav bar shows them, so the
  /// repository step offers them the same way round.
  List<ItemType> get _chosen =>
      ItemType.values.where(_libraries.contains).toList();

  void _next() {
    if (_step == _Step.libraries) {
      _applyLibraries();
      setState(() {
        _repoType = _chosen.first;
        // Nothing to arrange when only one library is in the bar.
        _step = _chosen.length > 1 ? _Step.navigation : _Step.repository;
      });
      return;
    }
    ref.read(mergeLibraryNavMobileStateProvider.notifier).set(_mergeLibraries);
    setState(() => _step = _Step.repository);
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
        setState(() => _error = l10n.unsupported_repo);
        return;
      }
      final repos = ref.read(extensionsRepoStateProvider(_repoType)).toList()
        ..add(repo);
      ref.read(extensionsRepoStateProvider(_repoType).notifier).set(repos);
      setState(() {
        _added = repo;
        _controller.clear();
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  /// Leaves on Browse, where the extensions the new repository provides are
  /// waiting to be installed. That is the next thing to do, so there is no
  /// reason to make the user go and find it.
  ///
  /// Only when a repository was actually added. Somebody who skipped has
  /// nothing to install and is better off in their library.
  void _finish() {
    if (_added != null) ref.read(routerProvider).go('/browse');
    ref.read(onboardingCompletedStateProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTv ? 48 : 24,
              vertical: 32,
            ).add(tvPageInsets),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isTv ? 620 : 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The app's own mark, in whichever form suits the background.
                  // Both full colour icons are drawn on a white tile, which
                  // reads as a bright block on a dark theme, so dark gets the
                  // bare silhouette tinted white and light gets the real icon.
                  if (theme.brightness == Brightness.light)
                    Image.asset(
                      'assets/app_icons/icon-red.png',
                      height: isTv ? 96 : 80,
                      fit: BoxFit.contain,
                    )
                  else
                    Image.asset(
                      'assets/app_icons/icon.png',
                      height: isTv ? 96 : 80,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    _title(l10n),
                    textAlign: TextAlign.center,
                    style:
                        (isTv
                                ? theme.textTheme.headlineMedium
                                : theme.textTheme.headlineSmall)
                            ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _body(l10n),
                    textAlign: TextAlign.center,
                    style:
                        (isTv
                                ? theme.textTheme.bodyLarge
                                : theme.textTheme.bodyMedium)
                            ?.copyWith(color: theme.hintColor, height: 1.45),
                  ),
                  const SizedBox(height: 28),
                  ..._stepBody(l10n),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _adding ? null : _finish,
                    child: Text(_leaveLabel(l10n)),
                  ),
                  // Typing a URL on a d-pad is miserable, so on a TV say
                  // plainly that leaving now costs nothing.
                  if (isTv && _step == _Step.repository && _added == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.onboarding_later,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => l10n.onboarding_title,
    _Step.navigation => l10n.onboarding_nav_title,
    _Step.repository => l10n.onboarding_repo_title,
  };

  String _body(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => l10n.onboarding_libraries_body,
    _Step.navigation => l10n.onboarding_nav_body,
    _Step.repository => l10n.onboarding_body,
  };

  String _leaveLabel(AppLocalizations l10n) =>
      _step == _Step.repository && _added != null
      ? l10n.onboarding_continue
      : l10n.onboarding_skip;

  List<Widget> _stepBody(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => [
      _ChoiceRow<ItemType>(
        values: ItemType.values,
        label: (type) => _libraryLabel(l10n, type),
        isSelected: _libraries.contains,
        onTap: (type) => setState(() {
          // One has to stay. An empty bar would have no library in it and the
          // next step nothing to arrange.
          if (!_libraries.remove(type)) {
            _libraries.add(type);
          } else if (_libraries.isEmpty) {
            _libraries.add(type);
          }
        }),
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: _next, child: Text(l10n.onboarding_next)),
    ],
    _Step.navigation => [
      _ChoiceRow<bool>(
        values: const [false, true],
        label: (merged) =>
            merged ? l10n.onboarding_nav_merged : l10n.onboarding_nav_split,
        isSelected: (merged) => merged == _mergeLibraries,
        onTap: (merged) => setState(() => _mergeLibraries = merged),
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: _next, child: Text(l10n.onboarding_next)),
    ],
    _Step.repository => [
      if (_chosen.length > 1) ...[
        _ChoiceRow<ItemType>(
          values: _chosen,
          label: (type) => _libraryLabel(l10n, type),
          isSelected: (type) => type == _repoType,
          onTap: _adding ? null : (type) => setState(() => _repoType = type),
        ),
        const SizedBox(height: 16),
      ],
      TextField(
        controller: _controller,
        // The remote's first OK should open the keyboard rather than land on
        // something the user has to hunt for.
        autofocus: isTv,
        autocorrect: false,
        enabled: !_adding,
        keyboardType: TextInputType.url,
        onChanged: (_) => setState(() => _error = null),
        onSubmitted: (_) => _urlLooksValid && !_adding ? _addRepo() : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          isDense: true,
          labelText: l10n.repo_url,
          errorText: _error,
          errorMaxLines: 3,
        ),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: _urlLooksValid && !_adding ? _addRepo : null,
        child: _adding
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(l10n.onboarding_add),
      ),
      if (_added != null) ...[
        const SizedBox(height: 14),
        _AddedRepo(name: _added!.name ?? _added!.jsonUrl ?? ''),
      ],
    ],
  };

  String _libraryLabel(AppLocalizations l10n, ItemType type) => switch (type) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };
}

/// A row of choices that works under a thumb and under a d-pad.
///
/// The TV build uses the same pills as the TV home and the Browse switcher,
/// because a SegmentedButton's segments are not reliably reachable with a
/// d-pad.
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.values,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final List<T> values;
  final String Function(T) label;
  final bool Function(T) isSelected;
  final void Function(T)? onTap;

  @override
  Widget build(BuildContext context) {
    if (isTv) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final value in values)
            TvPill(
              label: label(value),
              selected: isSelected(value),
              onTap: () => onTap?.call(value),
            ),
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          FilterChip(
            label: Text(label(value)),
            selected: isSelected(value),
            onSelected: onTap == null ? null : (_) => onTap!(value),
          ),
      ],
    );
  }
}

class _AddedRepo extends StatelessWidget {
  const _AddedRepo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 18, color: theme.hintColor),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ),
      ],
    );
  }
}
