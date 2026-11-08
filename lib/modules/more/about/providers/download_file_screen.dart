import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/release_notes.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mangayomi/services/external_browser.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// Offers [update]. A tap beside the dialog does not close it: that would
/// stop a download running in it.
Future<void> showUpdateDialog(BuildContext context, UpdateInfo update) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => DownloadFileScreen(updateAvailable: update),
  );
}

class DownloadFileScreen extends ConsumerStatefulWidget {
  final UpdateInfo updateAvailable;

  /// The version running, and the ABIs of an Android device, read from the
  /// platform unless given.
  @visibleForTesting
  final String? currentVersion;
  @visibleForTesting
  final List<String>? androidAbis;

  const DownloadFileScreen({
    required this.updateAvailable,
    this.currentVersion,
    this.androidAbis,
    super.key,
  });

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen> {
  int _total = 0;
  int _received = 0;
  bool _isDownloading = false;
  bool _isInstalling = false;
  String? _errorMessage;
  String _currentVersion = '';
  UpdateAsset? _apk;

  http.StreamedResponse? _response;
  final List<int> _bytes = [];
  StreamSubscription<List<int>>? _subscription;
  final ScrollController _changelogScrollController = ScrollController();

  /// Whether the update is downloaded and installed from here; otherwise the
  /// release page opens in the browser.
  bool get _installsHere =>
      (Platform.isAndroid || widget.androidAbis != null) && _apk != null;

  @override
  void initState() {
    super.initState();
    _currentVersion = widget.currentVersion ?? '';
    if (widget.currentVersion == null) _loadCurrentVersion();
    _apk = pickApk(
      widget.updateAvailable.assets,
      widget.androidAbis ?? const [],
      tv: isTv,
    );
    if (Platform.isAndroid && widget.androidAbis == null) _loadApk();
  }

  Future<void> _loadCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _currentVersion = info.version;
        });
      }
    } catch (error, stackTrace) {
      recordError(error, stack: stackTrace, source: 'download_file_screen');
    }
  }

  /// The APK depends on the device, and so does the size on the button.
  Future<void> _loadApk() async {
    try {
      final apk = await _apkForDevice();
      if (mounted) setState(() => _apk = apk);
    } catch (error, stackTrace) {
      recordError(error, stack: stackTrace, source: 'download_file_screen');
    }
  }

  Future<UpdateAsset?> _apkForDevice() async {
    final abis =
        widget.androidAbis ??
        (await DeviceInfoPlugin().androidInfo).supportedAbis;
    return pickApk(widget.updateAvailable.assets, abis, tv: isTv);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _changelogScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final update = widget.updateAvailable;
    final notes = _notes(context, update.notes);
    Widget content(Widget notes) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ShioriSpace.s12,
      children: [
        _versions(context, update),
        notes,
        if (_isDownloading)
          _progress(context)
        else if (_errorMessage != null)
          _error(context)
        else
          _whatHappensNext(context),
      ],
    );
    // On a phone on its side, nothing would be left for the notes: the whole
    // content scrolls instead.
    final short = MediaQuery.sizeOf(context).height < 480;
    return ShioriDialog(
      title: l10n.new_update_available,
      // As wide as a comfortable line of notes, narrower on a phone.
      content: SizedBox(
        width: 440,
        child: short
            ? SingleChildScrollView(child: content(notes))
            : content(Flexible(child: notes)),
      ),
      actions: [
        ShioriButton.quiet(
          label: _isDownloading ? l10n.cancel : l10n.update_later,
          onPressed: () async {
            if (_isDownloading) {
              try {
                await _subscription?.cancel();
              } catch (error, stackTrace) {
                recordError(
                  error,
                  stack: stackTrace,
                  source: 'download_file_screen',
                );
              }
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        if (!_isDownloading)
          ShioriButton(
            icon: _errorMessage != null
                ? Symbols.refresh_rounded
                : _installsHere
                ? Symbols.download_rounded
                : Symbols.open_in_browser_rounded,
            label: _actionLabel(context),
            onPressed: _handleDownloadOrOpen,
          ),
      ],
    );
  }

  String _actionLabel(BuildContext context) {
    final l10n = context.l10n;
    if (_errorMessage != null) return l10n.retry;
    return _installsHere ? l10n.download : l10n.open_in_browser;
  }

  String _megabytes(int bytes) => '${(bytes / 1048576).round()} MB';

  /// The version installed and the one on offer, side by side, with when it
  /// came out and, when it is downloaded here, what it weighs.
  Widget _versions(BuildContext context, UpdateInfo update) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    final published = update.publishedAt;
    final size = _installsHere ? (_apk?.size ?? 0) : 0;
    final details = [
      if (published != null)
        l10n.update_published(
          DateFormat.yMMMd(currentLocale(context).toLanguageTag())
              .format(published),
        ),
      if (size > 0) _megabytes(size),
    ].join(' · ');
    final arrow = Directionality.of(context) == TextDirection.rtl
        ? Symbols.arrow_back_rounded
        : Symbols.arrow_forward_rounded;
    return Container(
      padding: const EdgeInsets.all(ShioriSpace.s12),
      decoration: BoxDecoration(
        color: tokens.color.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: ShioriSpace.s8,
        children: [
          Row(
            spacing: ShioriSpace.s12,
            children: [
              if (_currentVersion.isNotEmpty) ...[
                Expanded(
                  child: _version(
                    context,
                    label: l10n.update_installed_version,
                    version: _currentVersion,
                    color: tokens.color.fgMuted,
                  ),
                ),
                Icon(arrow, size: 20, color: tokens.color.fgMuted),
              ],
              Expanded(
                child: _version(
                  context,
                  label: l10n.update_new_version,
                  version: update.version,
                  color: tokens.color.accentInk,
                ),
              ),
            ],
          ),
          if (details.isNotEmpty || update.isPreRelease)
            Row(
              spacing: ShioriSpace.s8,
              children: [
                if (details.isNotEmpty)
                  Expanded(child: Text(details, style: tokens.caption))
                else
                  const Spacer(),
                if (update.isPreRelease)
                  ShioriStatusChip(
                    kind: ShioriStatusKind.newChapter,
                    label: l10n.update_pre_release,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _version(
    BuildContext context, {
    required String label,
    required String version,
    required Color color,
  }) {
    final tokens = context.shiori;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s4,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.caption,
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'v$version',
            maxLines: 1,
            style: tokens.text.section.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }

  /// The release notes, sorted and without their Markdown, scrolling past a
  /// part of the screen. Up to a phone on its side, they keep some room.
  Widget _notes(BuildContext context, String changelog) {
    final tokens = context.shiori;
    final sections = parseReleaseNotes(changelog);
    final screenHeight = MediaQuery.sizeOf(context).height;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: math.max(96, math.min(260, screenHeight * 0.32)),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: tokens.color.hairline),
          borderRadius: BorderRadius.circular(ShioriShape.card),
        ),
        child: Scrollbar(
          controller: _changelogScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _changelogScrollController,
            padding: const EdgeInsets.all(ShioriSpace.s12),
            child: SelectionArea(
              child: sections.isEmpty
                  ? Text(context.l10n.update_no_notes, style: tokens.caption)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: ShioriSpace.s12,
                      children: [
                        for (final section in sections)
                          _section(context, section),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, ReleaseNotesSection section) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    final title = switch (section.group) {
      ReleaseNotesGroup.features => l10n.update_notes_features,
      ReleaseNotesGroup.fixes => l10n.update_notes_fixes,
      ReleaseNotesGroup.other => l10n.update_notes_other,
      null => section.title,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ShioriSpace.s4,
      children: [
        if (title != null) Text(title, style: tokens.groupLabel),
        for (final note in section.notes) _note(context, note),
      ],
    );
  }

  Widget _note(BuildContext context, ReleaseNote note) {
    final tokens = context.shiori;
    final style = tokens.text.meta.copyWith(
      color: tokens.color.fg,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );
    final text = Text.rich(_withBold(note.text), style: style);
    if (!note.isBullet) return text;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: note.indent * ShioriSpace.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ShioriSpace.s8,
        children: [
          Text('•', style: style.copyWith(color: tokens.color.fgMuted)),
          Expanded(child: text),
        ],
      ),
    );
  }

  /// What is between `**` is bold.
  TextSpan _withBold(String text) {
    final parts = text.split('**');
    return TextSpan(
      children: [
        for (var i = 0; i < parts.length; i++)
          if (parts[i].isNotEmpty)
            TextSpan(
              text: parts[i],
              style: i.isOdd
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
      ],
    );
  }

  /// What pressing the button is going to do, which depends on the platform.
  Widget _whatHappensNext(BuildContext context) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s8,
      children: [
        Icon(Symbols.info_rounded, size: 16, color: tokens.color.fgMuted),
        Expanded(
          child: Text(
            _installsHere ? l10n.update_hint_install : l10n.update_hint_browser,
            style: tokens.caption,
          ),
        ),
      ],
    );
  }

  /// How far the download has come: the step, the share and the megabytes
  /// over a bar, which runs on its own while the package installs.
  Widget _progress(BuildContext context) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    final progress = _total > 0 ? (_received / _total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ShioriSpace.s8,
      children: [
        DefaultTextStyle.merge(
          style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          child: Row(
            spacing: ShioriSpace.s8,
            children: [
              Expanded(
                child: Text(
                  _isInstalling
                      ? l10n.update_installing
                      : l10n.update_downloading,
                  style: tokens.text.meta.copyWith(
                    color: tokens.color.fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_total > 0 && !_isInstalling)
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%  ·  ${(_received / 1048576.0).toStringAsFixed(1)} / ${(_total / 1048576.0).toStringAsFixed(1)} MB',
                  style: tokens.caption,
                ),
            ],
          ),
        ),
        ShioriProgressBar(
          value: _isInstalling ? null : (_total > 0 ? progress : null),
        ),
      ],
    );
  }

  /// What went wrong, in the error tone, where the progress was.
  Widget _error(BuildContext context) {
    final tokens = context.shiori;
    final tone = tokens.color.error.foreground;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s8,
      children: [
        Icon(Symbols.error_rounded, fill: 1, color: tone, size: 20),
        Expanded(
          child: Text(
            _errorMessage ?? '',
            style: tokens.text.meta.copyWith(color: tone),
          ),
        ),
      ],
    );
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _isDownloading = false;
      _isInstalling = false;
      _errorMessage = message;
    });
  }

  Future<void> _handleDownloadOrOpen() async {
    final l10n = context.l10n;
    if (!_installsHere) {
      try {
        await _launchInBrowser(Uri.parse(widget.updateAvailable.pageUrl));
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e, stackTrace) {
        recordError(e, stack: stackTrace, source: 'download_file_screen');
        _fail(l10n.update_browser_failed);
      }
      return;
    }

    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });
    try {
      final apk = await _apkForDevice();
      if (apk == null) {
        throw StateError('No APK in ${widget.updateAvailable.pageUrl}');
      }
      await _downloadApk(apk.url);
    } catch (e, stackTrace) {
      recordError(e, stack: stackTrace, source: 'download_file_screen');
      _fail(l10n.update_download_failed('$e'));
    }
  }

  Future<void> _downloadApk(String url) async {
    final l10n = context.l10n;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory? dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) dir = await getExternalStorageDirectory();
    final file = File(
      '${dir!.path}/${url.split("/").lastOrNull ?? "Mangayomi.apk"}',
    );

    // If a file already exists, verify its integrity by comparing its size
    // against the server's Content-Length. A corrupt or incomplete download
    // would have a smaller size — delete it and re-download in that case.
    if (await file.exists()) {
      bool fileIsValid = false;
      try {
        final headResponse = await http.head(Uri.parse(url));
        final contentLength = int.tryParse(
          headResponse.headers['content-length'] ?? '',
        );
        final localSize = await file.length();
        if (contentLength != null && localSize == contentLength) {
          fileIsValid = true;
        }
      } catch (error, stackTrace) {
        // Network unavailable: fall back to assuming the file is valid so the
        // user can at least attempt installation while offline.
        recordError(error, stack: stackTrace, source: 'download_file_screen');
        fileIsValid = true;
      }

      if (fileIsValid) {
        if (!mounted) return;
        setState(() {
          _isInstalling = true;
        });
        await _install(file);
        return;
      } else {
        // File is corrupted or incomplete — delete and re-download.
        try {
          await file.delete();
        } catch (error, stackTrace) {
          recordError(error, stack: stackTrace, source: 'download_file_screen');
        }
      }
    }

    _bytes.clear();
    _received = 0;

    _response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    // The body of an error page is not an APK.
    if (_response!.statusCode != HttpStatus.ok) {
      throw HttpException('HTTP ${_response!.statusCode}', uri: Uri.parse(url));
    }
    if (!mounted) return;
    setState(() {
      _total = _response?.contentLength ?? 0;
    });
    _subscription = _response?.stream.listen(
      (value) {
        setState(() {
          _bytes.addAll(value);
          _received += value.length;
        });
      },
      onError: (Object e, StackTrace stackTrace) {
        recordError(e, stack: stackTrace, source: 'download_file_screen');
        _fail(l10n.update_network_error);
      },
      cancelOnError: true,
    );
    _subscription?.onDone(() async {
      if (mounted) {
        setState(() {
          _isInstalling = true;
        });
      }
      try {
        await file.writeAsBytes(_bytes);
      } catch (e, stackTrace) {
        recordError(e, stack: stackTrace, source: 'download_file_screen');
        _fail(l10n.update_write_failed);
        return;
      }
      await _install(file);
    });
  }

  /// Hands [file] to the installer and closes the dialog, or says why not.
  Future<void> _install(File file) async {
    final l10n = context.l10n;
    try {
      var status = await Permission.requestInstallPackages.status;
      if (!status.isGranted) {
        await Permission.requestInstallPackages.request();
      }
      await ApkInstaller.installApk(file.path);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      recordError(e, stack: stackTrace, source: 'download_file_screen');
      _fail(l10n.update_install_failed);
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await ExternalBrowser.open(url.toString())) {
      throw 'Could not launch $url';
    }
  }
}

class ApkInstaller {
  static const _platform = MethodChannel('com.kodjodevf.mangayomi.apk_install');
  static Future<void> installApk(String filePath) async {
    await _platform.invokeMethod('installApk', {'filePath': filePath});
  }
}
