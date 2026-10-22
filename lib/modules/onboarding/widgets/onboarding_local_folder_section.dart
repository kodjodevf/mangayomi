import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_folder_status.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:path/path.dart' as p;
import 'package:shiori/shiori.dart';

/// Section for adding and managing a folder of the user's own local files during onboarding.
class OnboardingLocalFolderSection extends ConsumerStatefulWidget {
  const OnboardingLocalFolderSection({
    super.key,
    required this.isAdding,
    this.onFolderChanged,
  });

  final bool isAdding;
  final ValueChanged<bool>? onFolderChanged;

  @override
  ConsumerState<OnboardingLocalFolderSection> createState() =>
      _OnboardingLocalFolderSectionState();
}

class _OnboardingLocalFolderSectionState
    extends ConsumerState<OnboardingLocalFolderSection> {
  /// The folder that was added here, so a wrong pick can be undone without
  /// going to look for it in Settings.
  String? _addedFolderPath;

  /// The names of the titles that folder turned out to hold, so the user can
  /// see what they just added rather than only how many.
  List<String> _foundTitleNames = const [];

  /// How the folder's titles were split across the libraries. The scanner
  /// decides that per title from what is inside it, so this is the answer to
  /// "did my anime land in Anime", which a bare count cannot give.
  Map<ItemType, int> _foundByType = const {};
  bool _scanningFolder = false;

  /// Whether the picked folder sits inside the app's own downloads directory,
  /// which is almost always a mistake.
  bool _folderIsInDownloads = false;

  /// How many titles the scan found, once it has finished. Zero is the
  /// interesting answer: it almost always means the folder above the one that
  /// was picked.
  int? _foundTitles;

  /// The local folders already set up before this screen ran.
  List<LocalFolder> get _existingFolders =>
      ref.watch(localFoldersStateProvider);

  /// Whether the folder this section added is still on the list.
  bool get _addedLocalFolder =>
      _addedFolderPath != null &&
      ref
          .watch(localFoldersStateProvider)
          .any((folder) => folder.path == _addedFolderPath);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _existingFolders.isNotEmpty) {
        widget.onFolderChanged?.call(true);
      }
    });
  }

  /// Adds a folder of the user's own files.
  Future<void> _addLocalFolder() async {
    final path =
        await LocalDirectoryAccess.pickDirectory() ??
        await FilePicker.getDirectoryPath(
          linuxOptions: const LinuxOptions(lockParentWindow: true),
        );
    if (path == null || !mounted) return;
    final folders = ref.read(localFoldersStateProvider).toList();
    if (!folders.any((folder) => folder.path == path)) {
      folders.add(
        LocalFolder(
          name: LocalFolder.fromPath(path: path).name ?? p.basename(path),
          path: path,
        ),
      );
      ref.read(localFoldersStateProvider.notifier).set(folders);
    }
    final base = await StorageProvider().getDirectory();
    final inDownloads =
        base != null && p.isWithin(p.join(base.path, 'downloads'), path);

    setState(() {
      _addedFolderPath = path;
      _folderIsInDownloads = inDownloads;
      _scanningFolder = true;
      _foundTitles = null;
    });
    widget.onFolderChanged?.call(true);

    try {
      await ref.read(scanLocalLibraryProvider.future);
    } finally {
      if (mounted) {
        setState(() {
          _scanningFolder = false;
          final prefix = '${p.basename(path)}/';
          final mine = mangaRepository
              .getLocalArchive()
              .where((manga) => (manga.link ?? '').startsWith(prefix))
              .toList();
          _foundTitles = mine.length;
          _foundTitleNames = mine
              .map((manga) => manga.name ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
          _foundByType = {
            for (final type in ItemType.values)
              if (mine.any((manga) => manga.itemType == type))
                type: mine.where((manga) => manga.itemType == type).length,
          };
        });
      }
    }
  }

  /// Takes back the folder this screen added.
  void _removeLocalFolder() {
    final path = _addedFolderPath;
    if (path == null) return;
    final remaining = ref
        .read(localFoldersStateProvider)
        .where((folder) => folder.path != path)
        .toList();
    ref.read(localFoldersStateProvider.notifier).set(remaining);
    setState(() {
      _addedFolderPath = null;
      _folderIsInDownloads = false;
      _foundTitles = null;
      _foundTitleNames = const [];
      _foundByType = const {};
    });
    widget.onFolderChanged?.call(remaining.isNotEmpty);
  }

  /// "6 manga, 3 anime" rather than "9 titles found", when the folder turned
  /// out to hold more than one kind.
  String _typeBreakdown(AppLocalizations l10n) {
    if (_foundByType.length <= 1) {
      return l10n.onboarding_local_found('$_foundTitles');
    }
    return _foundByType.entries
        .map((entry) => '${entry.value} ${_libraryLabel(l10n, entry.key)}')
        .join(', ');
  }

  String _libraryLabel(AppLocalizations l10n, ItemType type) => switch (type) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.onboarding_or_local,
          textAlign: TextAlign.center,
          style: context.shiori.caption,
        ),
        const SizedBox(height: ShioriSpace.s8),
        ShioriButton.secondary(
          expand: true,
          onPressed: widget.isAdding ? null : _addLocalFolder,
          icon: Symbols.folder_open_rounded,
          label: l10n.onboarding_local_folder,
        ),
        if (_addedFolderPath == null && _existingFolders.isNotEmpty) ...[
          const SizedBox(height: ShioriSpace.s12),
          OnboardingFolderStatus(
            message: l10n.onboarding_local_existing(
              '${_existingFolders.length}',
            ),
            titles: _existingFolders
                .map((folder) => folder.name ?? '')
                .where((name) => name.isNotEmpty)
                .toList(),
          ),
        ],
        const SizedBox(height: ShioriSpace.s8),
        Text(
          l10n.onboarding_local_any_type,
          textAlign: TextAlign.center,
          style: context.shiori.caption,
        ),
        if (_addedLocalFolder) ...[
          const SizedBox(height: ShioriSpace.s12),
          if (_scanningFolder)
            OnboardingFolderStatus(
              message: l10n.onboarding_local_scanning,
              busy: true,
            )
          else if ((_foundTitles ?? 0) > 0)
            OnboardingFolderStatus(
              message: _folderIsInDownloads
                  ? l10n.onboarding_local_in_downloads
                  : _typeBreakdown(l10n),
              path: _addedFolderPath,
              titles: _foundTitleNames,
              warn: _folderIsInDownloads,
            )
          else
            OnboardingFolderStatus(
              message: l10n.onboarding_local_empty,
              path: _addedFolderPath,
              warn: true,
            ),
          if (!_scanningFolder) ...[
            const SizedBox(height: ShioriSpace.s4),
            ShioriButton.quiet(
              onPressed: _removeLocalFolder,
              label: l10n.onboarding_local_remove,
            ),
          ],
        ],
      ],
    );
  }
}
