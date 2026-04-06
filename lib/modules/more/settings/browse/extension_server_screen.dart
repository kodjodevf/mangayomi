import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/android_proxy_server_dialog.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_release.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_tiles.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_utils.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/m_extension_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/storage_provider.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStatus();
    });
  }

  bool get _requiresJre => !Platform.isIOS;

  bool get _showExtensionServerSection =>
      !Platform.isAndroid && !Platform.isIOS;

  bool get _showAndroidProxyServerSection =>
      Platform.isAndroid || Platform.isIOS;

  bool get _showDesktopAdvancedApkBridgeSection =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
    final l10n = l10nLocalizations(context)!;
    final androidProxyServer = ref.watch(androidProxyServerStateProvider);
    final actionLabel = !_isInstalled
        ? l10n.download
        : (_hasUpdateAvailable ? l10n.update_files : l10n.up_to_date);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showExtensionServerSection
              ? l10n.android_proxy_server_mihon
              : l10n.android_proxy_server,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showExtensionServerSection) ...[
              Text(
                _requiresJre
                    ? l10n.extension_server_intro_with_jre
                    : l10n.extension_server_intro_ios,
                style: TextStyle(color: context.secondaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.mihon_proxy_server,
                style: TextStyle(fontSize: 13, color: context.primaryColor),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isDownloading ? null : _refreshStatus,
                      icon: Icon(
                        _isChecking
                            ? Icons.sync_outlined
                            : (_isInstalled
                            ? Icons.check_circle_outline
                            : Icons.error_outline),
                      ),
                      label: Text(
                        _isChecking
                            ? l10n.checking_files
                            : (_isInstalled
                            ? l10n.files_installed
                            : l10n.files_missing),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _canDownloadOrUpdate
                          ? _downloadOrUpdate
                          : null,
                      icon: Icon(
                        _isInstalled && _hasUpdateAvailable
                            ? Icons.system_update_alt_outlined
                            : (_isInstalled
                            ? Icons.check_circle_outline
                            : Icons.download_outlined),
                      ),
                      label: Text(actionLabel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (_requiresJre)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isDownloading
                            ? null
                            : _chooseInstallDirectory,
                        icon: const Icon(Icons.folder_open_outlined),
                        label: Text(l10n.choose_location),
                      ),
                    ),
                  if (_requiresJre) const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                      _isDownloading || !_canDetectFilesInSelectedFolder
                          ? null
                          : _useExistingLocation,
                      icon: const Icon(Icons.link_outlined),
                      label: Text(
                        Platform.isIOS
                            ? l10n.import_existing_jar
                            : l10n.detect_files_in_selected_folder,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isDownloading) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _totalBytes > 0 ? _receivedBytes / _totalBytes : null,
                ),
                const SizedBox(height: 8),
                Text(
                  _totalBytes > 0
                      ? '${(_receivedBytes / 1048576).toStringAsFixed(2)}/${(_totalBytes / 1048576).toStringAsFixed(2)} MB'
                      : l10n.preparing_download,
                  style: TextStyle(color: context.secondaryColor),
                ),
              ],
              const SizedBox(height: 24),
              ExtensionServerStatusTile(
                label: Platform.isIOS
                    ? l10n.app_install_location
                    : l10n.install_location,
                value: _selectedInstallDirectory,
                exists:
                _selectedInstallDirectory.isNotEmpty &&
                    Directory(_selectedInstallDirectory).existsSync(),
              ),
              const SizedBox(height: 12),
              if (_requiresJre) ...[
                ExtensionServerStatusTile(
                  label: l10n.jre_executable,
                  value: _jrePath,
                  exists: _jreExists,
                ),
                const SizedBox(height: 12),
              ],
              ExtensionServerStatusTile(
                label: l10n.extension_server_jar,
                value: _extensionServerPath,
                exists: _serverExists,
              ),
              const SizedBox(height: 12),
              ExtensionServerInfoTile(
                label: l10n.installed_version,
                value: _installedVersion,
              ),
              const SizedBox(height: 12),
              ExtensionServerInfoTile(
                label: l10n.latest_version,
                value: _latestVersion,
              ),
              if (_releaseCheckMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _releaseCheckMessage,
                  style: TextStyle(color: context.secondaryColor),
                ),
              ],
            ],
            if (_showAndroidProxyServerSection) ...[
              if (_showExtensionServerSection) const SizedBox(height: 24),
              Text(
                l10n.android_proxy_server,
                style: TextStyle(fontSize: 13, color: context.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.apkbridge_description,
                style: TextStyle(color: context.secondaryColor),
              ),
              const SizedBox(height: 12),
              ExtensionServerStatusTile(
                label: l10n.android_proxy_server,
                value: androidProxyServer,
                exists: androidProxyServer.isNotEmpty,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => showAndroidProxyServerDialog(
                        context,
                        proxyServer: androidProxyServer,
                        onConfirm: (server) {
                          ref
                              .read(androidProxyServerStateProvider.notifier)
                              .set(server);
                        },
                      ),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.set_proxy_address),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openApkBridgeRelease,
                      icon: const Icon(Icons.download_outlined),
                      label: Text(l10n.get_apk_bridge),
                    ),
                  ),
                ],
              ),
            ],
            if (_showDesktopAdvancedApkBridgeSection) ...[
              const SizedBox(height: 24),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  title: Text(
                    l10n.advanced,
                    style: TextStyle(fontSize: 13, color: context.primaryColor),
                  ),
                  children: [
                    Text(
                      l10n.android_proxy_server,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.apkbridge_description,
                      style: TextStyle(color: context.secondaryColor),
                    ),
                    const SizedBox(height: 12),
                    ExtensionServerStatusTile(
                      label: l10n.android_proxy_server,
                      value: androidProxyServer,
                      exists: androidProxyServer.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => showAndroidProxyServerDialog(
                              context,
                              proxyServer: androidProxyServer,
                              onConfirm: (server) {
                                ref
                                    .read(
                                  androidProxyServerStateProvider.notifier,
                                )
                                    .set(server);
                              },
                            ),
                            icon: const Icon(Icons.edit_outlined),
                            label: Text(l10n.set_proxy_address),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _openApkBridgeRelease,
                            icon: const Icon(Icons.download_outlined),
                            label: Text(l10n.get_apk_bridge),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _refreshStatus() async {
    if (!_showExtensionServerSection) {
      _setCheckingState(false);
      return;
    }
    final l10n = l10nLocalizations(context)!;
    _setCheckingState(true);
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
      await _downloadReleaseBundle(release, bundleZip, l10n);
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
      await _cleanupTempDirectory(tempDir);
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
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10n.select_extension_server_folder,
      initialDirectory: initialDirectory,
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

  Future<void> _extractArchive(File archiveFile, Directory installDir) async {
    final bytes = await archiveFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive.files) {
      final outputPath = path.normalize(path.join(installDir.path, file.name));
      if (!path.isWithin(installDir.path, outputPath) &&
          outputPath != installDir.path) {
        continue;
      }
      if (file.isFile) {
        final extractedFile = File(outputPath);
        await extractedFile.parent.create(recursive: true);
        await extractedFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(outputPath).create(recursive: true);
      }
    }
  }

  Future<void> _saveResolvedPaths({
    required String? jrePath,
    required String extensionServerPath,
    required String installDirectory,
  }) async {
    final settings = isar.settings.getSync(227);
    isar.writeTxnSync(
          () => isar.settings.putSync(
        settings!
          ..jrePath = jrePath
          ..extensionServerPath = extensionServerPath
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
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
    final serverDirectory = await provider.getExtensionServerDirectory();
    return serverDirectory!;
  }

  Future<ExtensionServerRelease?> _fetchLatestRelease() async {
    final assetName = extensionServerAssetNameForCurrentPlatform();
    if (assetName == null) return null;
    final client = http.Client();
    try {
      final response = await _fetchReleaseResponse(client);
      final releases = jsonDecode(response.body) as List;
      return _matchReleaseForAsset(releases, assetName);
    } finally {
      client.close();
    }
  }

  Future<void> _openApkBridgeRelease() async {
    final l10n = l10nLocalizations(context)!;
    if (!await launchUrl(
      Uri.parse(apkBridgeReleaseUrl),
      mode: LaunchMode.externalApplication,
    )) {
      botToast(l10n.could_not_launch_apk_bridge_page);
    }
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
    final settings = isar.settings.getSync(227);
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
      final latestRelease = await _fetchLatestRelease();
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

  Future<void> _downloadReleaseBundle(
      ExtensionServerRelease release,
      File bundleZip,
      dynamic l10n,
      ) async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(release.downloadUrl));
      final response = await client.send(request);
      _throwIfDownloadFailed(response, l10n);
      _updateTotalBytes(response.contentLength ?? 0);
      await _writeBundleToFile(response, bundleZip);
    } finally {
      client.close();
    }
  }

  void _throwIfDownloadFailed(http.StreamedResponse response, dynamic l10n) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw HttpException(l10n.failed_to_download_bundle(response.statusCode));
  }

  void _updateTotalBytes(int totalBytes) {
    _totalBytes = totalBytes;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _writeBundleToFile(
      http.StreamedResponse response,
      File bundleZip,
      ) async {
    final sink = bundleZip.openWrite();
    await for (final chunk in response.stream) {
      sink.add(chunk);
      _incrementReceivedBytes(chunk.length);
    }
    await sink.flush();
    await sink.close();
  }

  void _incrementReceivedBytes(int chunkLength) {
    if (!mounted) return;
    setState(() {
      _receivedBytes += chunkLength;
    });
  }

  Future<void> _installDownloadedBundle(
      File bundleZip,
      Directory installDir,
      dynamic l10n,
      ) async {
    await _prepareInstallDirectory(installDir);
    await _extractArchive(bundleZip, installDir);
    final resolvedPaths = await _resolvePathsInDirectory(installDir);
    if (!_hasResolvedPaths(resolvedPaths)) {
      throw Exception(l10n.downloaded_bundle_missing_expected_files);
    }
    await _persistResolvedPaths(resolvedPaths, installDir.path);
  }

  Future<void> _prepareInstallDirectory(Directory installDir) async {
    if (await installDir.exists()) {
      await _deleteDirectoryWithRetry(installDir);
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

  Future<void> _deleteDirectoryWithRetry(Directory directory) async {
    const retryCount = 5;
    for (var attempt = 0; attempt < retryCount; attempt++) {
      try {
        await directory.delete(recursive: true);
        break;
      } catch (e) {
        if (!Platform.isWindows || attempt == retryCount - 1) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
  }

  Future<void> _cleanupTempDirectory(Directory tempDir) async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  }

  Future<Directory?> _selectedInstallDirectoryOrNull() async {
    if (_selectedInstallDirectory.isEmpty) {
      return null;
    }
    return Directory(_selectedInstallDirectory);
  }

  Future<File?> _pickIosJarFile(dynamic l10n) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: l10n.select_extension_server_jar,
      type: FileType.custom,
      allowedExtensions: const ['jar'],
      allowMultiple: false,
      withData: false,
    );
    final filePath = result?.files.single.path;
    if (filePath == null || filePath.isEmpty) {
      return null;
    }
    return File(filePath);
  }

  Future<http.Response> _fetchReleaseResponse(http.Client client) async {
    final response = await client.get(
      Uri.parse(extensionServerReleaseApiUrl),
      headers: const {'Accept': 'application/vnd.github+json'},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw HttpException(
      'Failed to check extension server releases (${response.statusCode}).',
    );
  }

  ExtensionServerRelease? _matchReleaseForAsset(
      List releases,
      String assetName,
      ) {
    for (final item in releases) {
      final release = item as Map<String, dynamic>;
      if (_isDraftOrPrerelease(release)) {
        continue;
      }
      final matchedRelease = _releaseForAsset(release, assetName);
      if (matchedRelease != null) {
        return matchedRelease;
      }
    }
    return null;
  }

  bool _isDraftOrPrerelease(Map<String, dynamic> release) {
    return (release['draft'] as bool? ?? false) ||
        (release['prerelease'] as bool? ?? false);
  }

  ExtensionServerRelease? _releaseForAsset(
      Map<String, dynamic> release,
      String assetName,
      ) {
    final assets = (release['assets'] as List?) ?? const [];
    for (final assetItem in assets) {
      final asset = assetItem as Map<String, dynamic>;
      if (asset['name'] == assetName) {
        return ExtensionServerRelease(
          version: resolveExtensionServerReleaseVersion(release),
          assetName: assetName,
          downloadUrl: asset['browser_download_url'].toString(),
        );
      }
    }
    return null;
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
