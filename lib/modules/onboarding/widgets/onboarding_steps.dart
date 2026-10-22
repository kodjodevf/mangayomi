import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_controls.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_local_folder_section.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_nav_preview.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Formats the display name for a library [ItemType].
String onboardingLibraryLabel(AppLocalizations l10n, ItemType type) =>
    switch (type) {
      ItemType.manga => l10n.manga,
      ItemType.anime => l10n.anime,
      ItemType.novel => l10n.novel,
    };

/// Step where the user chooses which library types (manga, anime, novel) to keep.
class OnboardingLibrariesStep extends StatelessWidget {
  const OnboardingLibrariesStep({
    super.key,
    required this.libraries,
    required this.onLibraryToggled,
    required this.onNext,
    required this.onRestore,
  });

  final Set<ItemType> libraries;
  final ValueChanged<ItemType> onLibraryToggled;
  final VoidCallback onNext;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        OnboardingChoiceRow<ItemType>(
          values: ItemType.values,
          label: (type) => onboardingLibraryLabel(l10n, type),
          isSelected: libraries.contains,
          onTap: onLibraryToggled,
        ),
        const SizedBox(height: ShioriSpace.s16),
        ShioriButton(
          expand: true,
          onPressed: onNext,
          label: l10n.onboarding_next,
        ),
        const SizedBox(height: ShioriSpace.s12),
        ShioriButton.secondary(
          expand: true,
          onPressed: onRestore,
          icon: Symbols.settings_backup_restore_rounded,
          label: l10n.onboarding_restore,
        ),
      ],
    );
  }
}

/// Step where the user chooses whether navigation should group libraries together.
class OnboardingNavigationStep extends StatelessWidget {
  const OnboardingNavigationStep({
    super.key,
    required this.mergeLibraries,
    required this.chosen,
    required this.onChanged,
    required this.onNext,
  });

  final bool mergeLibraries;
  final List<ItemType> chosen;
  final ValueChanged<bool> onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        OnboardingChoiceRow<bool>(
          values: const [false, true],
          label: (merged) =>
              merged ? l10n.onboarding_nav_grouped : l10n.onboarding_nav_split,
          isSelected: (merged) => merged == mergeLibraries,
          onTap: onChanged,
        ),
        const SizedBox(height: ShioriSpace.s16),
        OnboardingNavPreview(libraries: chosen, merged: mergeLibraries),
        const SizedBox(height: ShioriSpace.s16),
        ShioriButton(
          expand: true,
          onPressed: onNext,
          label: l10n.onboarding_next,
        ),
      ],
    );
  }
}

/// Step where the user adds a remote repository or links a local folder.
class OnboardingRepositoryStep extends StatelessWidget {
  const OnboardingRepositoryStep({
    super.key,
    required this.chosen,
    required this.repoType,
    required this.onRepoTypeChanged,
    required this.controller,
    required this.isAdding,
    required this.error,
    required this.added,
    required this.urlLooksValid,
    required this.onChanged,
    required this.onSubmitted,
    required this.onAddRepo,
    this.onFolderChanged,
  });

  final List<ItemType> chosen;
  final ItemType repoType;
  final ValueChanged<ItemType>? onRepoTypeChanged;
  final TextEditingController controller;
  final bool isAdding;
  final String? error;
  final Repo? added;
  final bool urlLooksValid;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onAddRepo;
  final ValueChanged<bool>? onFolderChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chosen.length > 1) ...[
          OnboardingChoiceRow<ItemType>(
            values: chosen,
            label: (type) => onboardingLibraryLabel(l10n, type),
            isSelected: (type) => type == repoType,
            onTap: onRepoTypeChanged,
          ),
          const SizedBox(height: ShioriSpace.s16),
        ],
        TextField(
          controller: controller,
          autofocus: isTv,
          autocorrect: false,
          enabled: !isAdding,
          keyboardType: TextInputType.url,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            labelText: l10n.repo_url,
            errorText: error,
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: ShioriSpace.s12),
        if (isAdding)
          const Center(child: ShioriLoading.inline())
        else
          ShioriButton(
            expand: true,
            onPressed: urlLooksValid ? onAddRepo : null,
            label: l10n.onboarding_add,
          ),
        if (added != null) ...[
          const SizedBox(height: ShioriSpace.s12),
          OnboardingAddedRepo(name: added!.name ?? added!.jsonUrl ?? ''),
        ],
        const SizedBox(height: ShioriSpace.s24),
        OnboardingLocalFolderSection(
          isAdding: isAdding,
          onFolderChanged: onFolderChanged,
        ),
      ],
    );
  }
}
