// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addDownloadToQueue)
final addDownloadToQueueProvider = AddDownloadToQueueFamily._();

final class AddDownloadToQueueProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  AddDownloadToQueueProvider._({
    required AddDownloadToQueueFamily super.from,
    required Chapter super.argument,
  }) : super(
         retry: null,
         name: r'addDownloadToQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addDownloadToQueueHash();

  @override
  String toString() {
    return r'addDownloadToQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as Chapter;
    return addDownloadToQueue(ref, chapter: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddDownloadToQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addDownloadToQueueHash() =>
    r'35e8e724755be265a9bf167e4641336630a465d2';

final class AddDownloadToQueueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, Chapter> {
  AddDownloadToQueueFamily._()
    : super(
        retry: null,
        name: r'addDownloadToQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddDownloadToQueueProvider call({required Chapter chapter}) =>
      AddDownloadToQueueProvider._(argument: chapter, from: this);

  @override
  String toString() => r'addDownloadToQueueProvider';
}

@ProviderFor(downloadChapter)
final downloadChapterProvider = DownloadChapterFamily._();

final class DownloadChapterProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  DownloadChapterProvider._({
    required DownloadChapterFamily super.from,
    required ({
      Chapter chapter,
      bool? useWifi,
      LocalFolder? localFolder,
      VoidCallback? callback,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'downloadChapterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadChapterHash();

  @override
  String toString() {
    return r'downloadChapterProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument
            as ({
              Chapter chapter,
              bool? useWifi,
              LocalFolder? localFolder,
              VoidCallback? callback,
            });
    return downloadChapter(
      ref,
      chapter: argument.chapter,
      useWifi: argument.useWifi,
      localFolder: argument.localFolder,
      callback: argument.callback,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadChapterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadChapterHash() => r'36aa5c68bfe64281d4c485ba67958e8412eea1e6';

final class DownloadChapterFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({
            Chapter chapter,
            bool? useWifi,
            LocalFolder? localFolder,
            VoidCallback? callback,
          })
        > {
  DownloadChapterFamily._()
    : super(
        retry: null,
        name: r'downloadChapterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadChapterProvider call({
    required Chapter chapter,
    bool? useWifi,
    LocalFolder? localFolder,
    VoidCallback? callback,
  }) => DownloadChapterProvider._(
    argument: (
      chapter: chapter,
      useWifi: useWifi,
      localFolder: localFolder,
      callback: callback,
    ),
    from: this,
  );

  @override
  String toString() => r'downloadChapterProvider';
}

@ProviderFor(processDownloads)
final processDownloadsProvider = ProcessDownloadsFamily._();

final class ProcessDownloadsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  ProcessDownloadsProvider._({
    required ProcessDownloadsFamily super.from,
    required ({bool? useWifi, LocalFolder? localFolder}) super.argument,
  }) : super(
         retry: null,
         name: r'processDownloadsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$processDownloadsHash();

  @override
  String toString() {
    return r'processDownloadsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({bool? useWifi, LocalFolder? localFolder});
    return processDownloads(
      ref,
      useWifi: argument.useWifi,
      localFolder: argument.localFolder,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProcessDownloadsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$processDownloadsHash() => r'0f351dc857d3bf528c68b4eda1582b0f79b48157';

final class ProcessDownloadsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({bool? useWifi, LocalFolder? localFolder})
        > {
  ProcessDownloadsFamily._()
    : super(
        retry: null,
        name: r'processDownloadsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProcessDownloadsProvider call({bool? useWifi, LocalFolder? localFolder}) =>
      ProcessDownloadsProvider._(
        argument: (useWifi: useWifi, localFolder: localFolder),
        from: this,
      );

  @override
  String toString() => r'processDownloadsProvider';
}
