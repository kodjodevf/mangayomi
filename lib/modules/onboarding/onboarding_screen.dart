import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Shown once, on the first launch of a fresh install.
///
/// It exists for one reason: the app ships with no repositories, so a new user
/// lands on an empty Browse with nothing to read and no indication that they
/// are supposed to supply the sources themselves. This says so, and takes the
/// repository there and then.
///
/// No repository is suggested or shipped. The field starts empty and the user
/// can leave without filling it in.
///
/// ## On a TV
///
/// The same three decisions, laid out for a remote instead of a thumb. Typing a
/// repository URL on a d-pad is genuinely unpleasant, so the TV build says out
/// loud that this can be done later from Settings, and Skip is a first-class
/// way off the screen rather than a consolation. The field takes focus on
/// arrival so the first press of OK opens the keyboard, and the item type is a
/// row of [TvPill]s because a SegmentedButton's internals are not reliably
/// reachable with a d-pad.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();
  ItemType _itemType = ItemType.manga;
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
      final repos = ref.read(extensionsRepoStateProvider(_itemType)).toList()
        ..add(repo);
      ref.read(extensionsRepoStateProvider(_itemType).notifier).set(repos);
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

  void _finish() =>
      ref.read(onboardingCompletedStateProvider.notifier).complete();

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
                  // The app's own mark rather than a stock glyph. icon.png is a
                  // silhouette, tinted against the background the same way the
                  // More and About screens tint it.
                  Image.asset(
                    'assets/app_icons/icon.png',
                    height: isTv ? 96 : 80,
                    color: theme.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.onboarding_title,
                    textAlign: TextAlign.center,
                    style:
                        (isTv
                                ? theme.textTheme.headlineMedium
                                : theme.textTheme.headlineSmall)
                            ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.onboarding_body,
                    textAlign: TextAlign.center,
                    style:
                        (isTv
                                ? theme.textTheme.bodyLarge
                                : theme.textTheme.bodyMedium)
                            ?.copyWith(color: theme.hintColor, height: 1.45),
                  ),
                  const SizedBox(height: 28),
                  _ItemTypePicker(
                    selected: _itemType,
                    onChanged: _adding
                        ? null
                        : (value) => setState(() => _itemType = value),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    // The remote's first OK should open the keyboard rather
                    // than land on something the user has to hunt for.
                    autofocus: isTv,
                    autocorrect: false,
                    enabled: !_adding,
                    keyboardType: TextInputType.url,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) =>
                        _urlLooksValid && !_adding ? _addRepo() : null,
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
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _adding ? null : _finish,
                    child: Text(
                      _added == null
                          ? l10n.onboarding_skip
                          : l10n.onboarding_continue,
                    ),
                  ),
                  // Typing a URL on a d-pad is miserable, so on a TV say
                  // plainly that leaving now costs nothing.
                  if (isTv && _added == null) ...[
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
}

/// Which library the repository stocks. Repositories are per item type, so this
/// has to be asked rather than guessed, and getting it wrong puts the sources
/// somewhere the user will not look for them.
class _ItemTypePicker extends StatelessWidget {
  const _ItemTypePicker({required this.selected, required this.onChanged});

  final ItemType selected;
  final ValueChanged<ItemType>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final labels = {
      ItemType.manga: l10n.manga,
      ItemType.anime: l10n.anime,
      ItemType.novel: l10n.novel,
    };
    // A SegmentedButton's segments are not reliably reachable with a d-pad, so
    // the TV build uses the same pills as the TV home and Browse switchers.
    if (isTv) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final entry in labels.entries)
            TvPill(
              label: entry.value,
              selected: entry.key == selected,
              onTap: () => onChanged?.call(entry.key),
            ),
        ],
      );
    }
    return SegmentedButton<ItemType>(
      segments: [
        for (final entry in labels.entries)
          ButtonSegment(value: entry.key, label: Text(entry.value)),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: onChanged == null
          ? null
          : (values) => onChanged!(values.first),
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
