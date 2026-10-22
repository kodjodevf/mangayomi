import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_release.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_release_service.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_utils.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/widgets/android_proxy_group.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/widgets/extension_server_actions_group.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/widgets/extension_server_status_group.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/widgets/ios_runtime_group.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/m_extension_server.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:path/path.dart' as path;
import 'package:shiori/shiori.dart';

class ExtensionServerScreen extends ConsumerStatefulWidget {
  const ExtensionServerScreen({super.key});

  @override
  ConsumerState<ExtensionServerScreen> createState() =>
      _ExtensionServerScreenState();
}

class _ExtensionServerScreenState extends ConsumerState<ExtensionServerScreen> {
  bool _isChecking = true;
  bool _isDownloading = false;
  bool _jreExists = false;
  bool _serverExists = false;
  int _totalBytes = 0;
  int _receivedBytes = 0;
  String _selectedInstallDirectory = '';
  String _jrePath = '';
  String _extensionServerPath = '';
  String _installedVersion = '';
  String _latestVersion = '';
  String _releaseCheckMessage = '';
  ExtensionServerRelease? _latestRelease;
  bool _runtimeRunning = false;
  bool _runtimeBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_refreshStatus());
      unawaited(_refreshRuntimeStatus());
    });
  }

  bool get _requiresJre => !Platform.isIOS;

  bool get _showExtensionServerSection => !isMobile;

  bool get _showAndroidProxyServerSection => isMobile;

  bool get _showDesktopAdvancedMExtensionServerSection => isDesktop;

  bool get _isInstalled => _serverExists && (!_requiresJre || _jreExists);

  bool get _hasUpdateAvailable =>
      _isInstalled &&
      _latestRelease != null &&
      compareVersions(_installedVersion, _latestRelease!.version) < 0;

  bool get _canDownloadOrUpdate =>
      !_isDownloading &&
      _latestRelease != null &&
      (!_isInstalled || _hasUpdateAvailable);

  bool get _canDetectFilesInSelectedFolder =>
      !_requiresJre || _selectedInstallDirectory.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final androidProxyServer = ref.watch(androidProxyServerStateProvider);
    final actionLabel = !_isInstalled
        ? l10n.download
        : (_hasUpdateAvailable ? l10n.update_files : l10n.up_to_date);
    final actionIcon = _isInstalled && _hasUpdateAvailable
        ? Symbols.system_update_alt_rounded
        : (_isInstalled
              ? Symbols.check_circle_rounded
              : Symbols.download_rounded);
    final statusLabel = _isChecking
        ? l10n.checking_files
        : (_isInstalled ? l10n.files_installed : l10n.files_missing);
    final versions = [
      if (_installedVersion.isNotEmpty) _installedVersion,
      if (_latestVersion.isNotEmpty && _latestVersion != _installedVersion)
        '→ $_latestVersion',
    ].join(' ');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showExtensionServerSection
              ? l10n.android_proxy_server_mihon
              : l10n.android_proxy_server,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: ShioriSpace.s24).add(tvPageInsets),
        children: [
          if (_showExtensionServerSection) ...[
            _intro(
              _requiresJre
                  ? l10n.extension_server_intro_with_jre
                  : l10n.extension_server_intro_ios,
            ),
            ExtensionServerActionsGroup(
              isChecking: _isChecking,
              isInstalled: _isInstalled,
              statusLabel: statusLabel,
              versions: versions,
              isDownloading: _isDownloading,
              onRefreshStatus: _refreshStatus,
              canDownloadOrUpdate: _canDownloadOrUpdate,
              onDownloadOrUpdate: _downloadOrUpdate,
              actionIcon: actionIcon,
              actionLabel: actionLabel,
              totalBytes: _totalBytes,
              receivedBytes: _receivedBytes,
              selectedInstallDirectory: _selectedInstallDirectory,
              requiresJre: _requiresJre,
              onChooseInstallDirectory: _chooseInstallDirectory,
              canDetectFilesInSelectedFolder: _canDetectFilesInSelectedFolder,
              onUseExistingLocation: _useExistingLocation,
            ),
            ExtensionServerStatusGroup(
              requiresJre: _requiresJre,
              jrePath: _jrePath,
              jreExists: _jreExists,
              extensionServerPath: _extensionServerPath,
              serverExists: _serverExists,
              installedVersion: _installedVersion,
              latestVersion: _latestVersion,
              releaseCheckMessage: _releaseCheckMessage,
            ),
          ],
          if (_showAndroidProxySectionOrAdvanced)
            AndroidProxyGroup(
              title: _showAndroidProxyServerSection
                  ? l10n.android_proxy_server
                  : l10n.advanced,
              androidProxyServer: androidProxyServer,
            ),
          if (_showAndroidProxyServerSection && Platform.isIOS)
            IosRuntimeGroup(
              runtimeRunning: _runtimeRunning,
              runtimeBusy: _runtimeBusy,
              onToggleRuntime: _toggleRuntime,
            ),
        ],
      ),
    );
  }

  bool get _showAndroidProxySectionOrAdvanced =>
      _showAndroidProxyServerSection ||
      _showDesktopAdvancedMExtensionServerSection;

  Widget _intro(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(
      ShioriSpace.s16,
      ShioriSpace.s16,
      ShioriSpace.s16,
      0,
    ),
    child: Text(text, style: context.shiori.caption),
  );

  Future<void> _refreshStatus() async {
    if (!_showExtensionServerSection) {
      _setCheckingState(false);
      return;
    }
    final l10n = l10nLocalizations(context)!;
    _setCheckingState(true);
    try {
      final configuredPaths = _readConfiguredPaths();
      final fileState = await _resolveFileState(configuredPaths);
      final releaseState = await _resolveLatestReleaseState(l10n, fileState);
      if (!mounted) return;
      final selectedInstallDirectory = await _resolveSelectedInstallDirectory(
        configuredPaths,
      );
      _applyStatusState(
        selectedInstallDirectory: selectedInstallDirectory,
        configuredPaths: configuredPaths,
        fileState: fileState,
        releaseState: releaseState,
      );
    } on FileSystemException {
      _applyStatusFailure(l10n.could_not_check_proxy_server_updates);
    } catch (error, stack) {
      CrashReports.record(
        source: 'ExtensionServerStatus',
        error: error,
        stack: stack,
      );
      _applyStatusFailure(l10n.could_not_check_proxy_server_updates);
    }
  }

  void _applyStatusFailure(String message) {
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _releaseCheckMessage = message;
    });
  }

  Future<void> _refreshRuntimeStatus() async {
    if (!Platform.isIOS) return;
    var running = false;
    try {
      running = await MExtensionServerPlatform(ref).checkLocalServer();
    } catch (_) {
      // A missing local runtime is a stopped server.
    }
    if (mounted) setState(() => _runtimeRunning = running);
  }

  Future<void> _toggleRuntime() async {
    setState(() => _runtimeBusy = true);
    final server = MExtensionServerPlatform(ref);
    if (_runtimeRunning) {
      await server.stopServer();
    } else {
      await server.startServer(forceLocal: true);
    }
    final running = await server.checkLocalServer();
    if (mounted) {
      setState(() {
        _runtimeRunning = running;
        _runtimeBusy = false;
      });
    }
  }

  Future<void> _downloadOrUpdate() async {
    final l10n = l10nLocalizations(context)!;
    final release = _validateDownloadAction(l10n);
    if (release == null) return;
    _setDownloadState(isDownloading: true, receivedBytes: 0, totalBytes: 0);
    final tempDir = await Directory.systemTemp.createTemp('extension-server-');
    final bundleZip = File(path.join(tempDir.path, release.assetName));
    final wasInstalled = _isInstalled;
    try {
      await ExtensionServerReleaseService.downloadBundle(
        release: release,
        destinationZip: bundleZip,
        onProgress: (received, total) {
          if (!mounted) return;
          setState(() {
            _receivedBytes = received;
            _totalBytes = total;
          });
        },
      );
      final installDir = await _resolveInstallDirectory();
      await MExtensionServerPlatform(ref).stopServer();
      await _installDownloadedBundle(bundleZip, installDir, l10n);
      await _startServerAndRefresh();
      botToast(l10n.extension_server_files_ready);
    } catch (e) {
      if (wasInstalled) {
        await _startServerAndRefresh();
      } else {
        await _refreshStatus();
      }
      botToast(e.toString(), second: 5);
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
      _setDownloadState(isDownloading: false);
    }
  }

  Future<void> _chooseInstallDirectory() async {
    final l10n = l10nLocalizations(context)!;
    if (!_requiresJre) {
      botToast(l10n.ios_extension_server_import_hint, second: 5);
      return;
    }
    final initialDirectory = _selectedInstallDirectory.isNotEmpty
        ? _selectedInstallDirectory
        : (await _defaultInstallDirectory()).path;
    final selectedDirectory = await FilePicker.getDirectoryPath(
      dialogTitle: l10n.select_extension_server_folder,
      initialDirectory: initialDirectory,
      linuxOptions: const LinuxOptions(lockParentWindow: true),
    );
    if (!mounted || selectedDirectory == null || selectedDirectory.isEmpty) {
      return;
    }
    setState(() {
      _selectedInstallDirectory = selectedDirectory;
    });
  }

  Future<void> _useExistingLocation() async {
    final l10n = l10nLocalizations(context)!;
    if (Platform.isIOS) {
      await _importExistingIosJar();
      return;
    }
    final installDir = await _selectedInstallDirectoryOrNull();
    if (installDir == null || !await installDir.exists()) {
      botToast(l10n.selected_folder_does_not_exist, second: 5);
      return;
    }
    final resolvedPaths = await _resolvePathsInDirectory(installDir);
    if (!_hasResolvedPaths(resolvedPaths)) {
      botToast(
        l10n.no_extension_server_files_found_in_selected_folder,
        second: 5,
      );
      return;
    }
    await _persistResolvedPaths(resolvedPaths, installDir.path);
    await _restartServerAndRefresh();
    botToast(l10n.extension_server_files_linked);
  }

  Future<void> _importExistingIosJar() async {
    final l10n = l10nLocalizations(context)!;
    final sourceFile = await _pickIosJarFile(l10n);
    if (sourceFile == null) return;
    if (!await sourceFile.exists()) {
      botToast(l10n.selected_file_could_not_be_accessed, second: 5);
      return;
    }
    final installDir = await _defaultInstallDirectory();
    await installDir.create(recursive: true);
    final targetFile = File(
      path.join(installDir.path, path.basename(sourceFile.path)),
    );
    await sourceFile.copy(targetFile.path);
    await _saveResolvedPaths(
      jrePath: '',
      extensionServerPath: targetFile.path,
      installDirectory: installDir.path,
    );
    await _restartServerAndRefresh();
    botToast(l10n.extension_server_jar_imported);
  }

  Future<void> _saveResolvedPaths({
    required String? jrePath,
    required String extensionServerPath,
    required String installDirectory,
  }) async {
    settingsRepository.update(
      (s) => s
        ..jrePath = jrePath
        ..extensionServerPath = extensionServerPath,
    );
    if (mounted) {
      setState(() {
        _selectedInstallDirectory = installDirectory;
      });
    } else {
      _selectedInstallDirectory = installDirectory;
    }
  }

  Future<Directory> _resolveInstallDirectory() async {
    if (Platform.isIOS) {
      return _defaultInstallDirectory();
    }
    if (_selectedInstallDirectory.isNotEmpty) {
      return Directory(_selectedInstallDirectory);
    }
    return _defaultInstallDirectory();
  }

  Future<Directory> _defaultInstallDirectory() async {
    final provider = StorageProvider();
    return provider.getExtensionServerDirectory();
  }

  void _setCheckingState(bool value) {
    if (!mounted) return;
    setState(() {
      _isChecking = value;
    });
  }

  void _setDownloadState({
    required bool isDownloading,
    int? receivedBytes,
    int? totalBytes,
  }) {
    if (!mounted) return;
    setState(() {
      _isDownloading = isDownloading;
      if (receivedBytes != null) {
        _receivedBytes = receivedBytes;
      }
      if (totalBytes != null) {
        _totalBytes = totalBytes;
      }
    });
  }

  _ConfiguredPaths _readConfiguredPaths() {
    final settings = settingsRepository.currentOrNull;
    return _ConfiguredPaths(
      jrePath: settings?.jrePath ?? '',
      extensionServerPath: settings?.extensionServerPath ?? '',
    );
  }

  Future<_ResolvedFileState> _resolveFileState(_ConfiguredPaths paths) async {
    final jreExists = !_requiresJre
        ? true
        : (paths.jrePath.isNotEmpty && await File(paths.jrePath).exists());
    final serverExists =
        paths.extensionServerPath.isNotEmpty &&
        await File(paths.extensionServerPath).exists();
    final isInstalled = serverExists && (!_requiresJre || jreExists);
    return _ResolvedFileState(
      jreExists: jreExists,
      serverExists: serverExists,
      installedVersion: isInstalled
          ? resolveInstalledExtensionServerVersion(paths.extensionServerPath)
          : '',
    );
  }

  Future<_LatestReleaseState> _resolveLatestReleaseState(
    dynamic l10n,
    _ResolvedFileState fileState,
  ) async {
    try {
      final latestRelease =
          await ExtensionServerReleaseService.fetchLatestRelease();
      return _LatestReleaseState(
        latestRelease: latestRelease,
        latestVersion: latestRelease?.version ?? '',
        releaseCheckMessage: _releaseMessageFor(fileState, latestRelease, l10n),
      );
    } catch (_) {
      return _LatestReleaseState(
        latestRelease: null,
        latestVersion: '',
        releaseCheckMessage: l10n.could_not_check_proxy_server_updates,
      );
    }
  }

  String _releaseMessageFor(
    _ResolvedFileState fileState,
    ExtensionServerRelease? latestRelease,
    dynamic l10n,
  ) {
    if (!fileState.isInstalled || latestRelease == null) {
      return '';
    }
    return compareVersions(fileState.installedVersion, latestRelease.version) >=
            0
        ? l10n.no_newer_proxy_server_release_available
        : '';
  }

  Future<String> _resolveSelectedInstallDirectory(
    _ConfiguredPaths paths,
  ) async {
    if (Platform.isIOS) {
      return (await _defaultInstallDirectory()).path;
    }
    return extensionServerDirectoryFromPaths(
          jrePath: paths.jrePath,
          extensionServerPath: paths.extensionServerPath,
        ) ??
        '';
  }

  void _applyStatusState({
    required String selectedInstallDirectory,
    required _ConfiguredPaths configuredPaths,
    required _ResolvedFileState fileState,
    required _LatestReleaseState releaseState,
  }) {
    setState(() {
      _selectedInstallDirectory = selectedInstallDirectory;
      _jrePath = configuredPaths.jrePath;
      _extensionServerPath = configuredPaths.extensionServerPath;
      _installedVersion = fileState.installedVersion;
      _latestVersion = releaseState.latestVersion;
      _latestRelease = releaseState.latestRelease;
      _releaseCheckMessage = releaseState.releaseCheckMessage;
      _jreExists = fileState.jreExists;
      _serverExists = fileState.serverExists;
      _isChecking = false;
    });
  }

  ExtensionServerRelease? _validateDownloadAction(dynamic l10n) {
    final release = _latestRelease;
    if (release == null) {
      botToast(l10n.no_extension_server_bundle_available_for_this_platform);
      return null;
    }
    if (_isInstalled && !_hasUpdateAvailable) {
      botToast(l10n.no_newer_proxy_server_release_available);
      return null;
    }
    return release;
  }

  Future<void> _installDownloadedBundle(
    File bundleZip,
    Directory installDir,
    dynamic l10n,
  ) async {
    await _prepareInstallDirectory(installDir);
    await ExtensionServerReleaseService.extractArchive(bundleZip, installDir);
    final resolvedPaths = await _resolvePathsInDirectory(installDir);
    if (!_hasResolvedPaths(resolvedPaths)) {
      throw Exception(l10n.downloaded_bundle_missing_expected_files);
    }
    await _persistResolvedPaths(resolvedPaths, installDir.path);
  }

  Future<void> _prepareInstallDirectory(Directory installDir) async {
    if (await installDir.exists()) {
      await ExtensionServerReleaseService.deleteDirectoryWithRetry(installDir);
    }
    await installDir.create(recursive: true);
  }

  Future<_ResolvedPaths> _resolvePathsInDirectory(Directory installDir) async {
    return _ResolvedPaths(
      jrePath: await findExtensionServerJavaExecutable(installDir),
      extensionServerPath: await findExtensionServerJar(installDir),
    );
  }

  bool _hasResolvedPaths(_ResolvedPaths paths) {
    return (!_requiresJre || paths.jrePath != null) &&
        paths.extensionServerPath != null;
  }

  Future<void> _persistResolvedPaths(
    _ResolvedPaths paths,
    String installDirectory,
  ) async {
    if (_requiresJre && !Platform.isWindows) {
      await Process.run('chmod', ['+x', paths.jrePath!]);
    }
    await _saveResolvedPaths(
      jrePath: _requiresJre ? paths.jrePath : '',
      extensionServerPath: paths.extensionServerPath!,
      installDirectory: installDirectory,
    );
  }

  Future<void> _restartServerAndRefresh() async {
    await MExtensionServerPlatform(ref).stopServer();
    await _startServerAndRefresh();
  }

  Future<void> _startServerAndRefresh() async {
    await MExtensionServerPlatform(ref).startServer();
    await _refreshStatus();
  }

  Future<Directory?> _selectedInstallDirectoryOrNull() async {
    if (_selectedInstallDirectory.isEmpty) {
      return null;
    }
    return Directory(_selectedInstallDirectory);
  }

  Future<File?> _pickIosJarFile(dynamic l10n) async {
    final file = await FilePicker.pickFile(
      dialogTitle: l10n.select_extension_server_jar,
      type: FileType.custom,
      allowedExtensions: const ['jar'],
    );
    final filePath = file?.path;
    if (filePath == null || filePath.isEmpty) {
      return null;
    }
    return File(filePath);
  }
}

class _ConfiguredPaths {
  final String jrePath;
  final String extensionServerPath;

  const _ConfiguredPaths({
    required this.jrePath,
    required this.extensionServerPath,
  });
}

class _ResolvedFileState {
  final bool jreExists;
  final bool serverExists;
  final String installedVersion;

  const _ResolvedFileState({
    required this.jreExists,
    required this.serverExists,
    required this.installedVersion,
  });

  bool get isInstalled => serverExists && jreExists;
}

class _LatestReleaseState {
  final ExtensionServerRelease? latestRelease;
  final String latestVersion;
  final String releaseCheckMessage;

  const _LatestReleaseState({
    required this.latestRelease,
    required this.latestVersion,
    required this.releaseCheckMessage,
  });
}

class _ResolvedPaths {
  final String? jrePath;
  final String? extensionServerPath;

  const _ResolvedPaths({
    required this.jrePath,
    required this.extensionServerPath,
  });
}
