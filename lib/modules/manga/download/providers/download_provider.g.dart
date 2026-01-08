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
    required ({Chapter chapter, bool? useWifi, VoidCallback? callback})
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
            as ({Chapter chapter, bool? useWifi, VoidCallback? callback});
    return downloadChapter(
      ref,
      chapter: argument.chapter,
      useWifi: argument.useWifi,
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

String _$downloadChapterHash() => r'c503cef46aa7083316b023400f0aa470ae3a3bc4';

final class DownloadChapterFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({Chapter chapter, bool? useWifi, VoidCallback? callback})
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
    VoidCallback? callback,
  }) => DownloadChapterProvider._(
    argument: (chapter: chapter, useWifi: useWifi, callback: callback),
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
    required bool? super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as bool?;
    return processDownloads(ref, useWifi: argument);
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

String _$processDownloadsHash() => r'36903a1ca0140ef7d55aa68ee34d8c74573e8e71';

final class ProcessDownloadsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, bool?> {
  ProcessDownloadsFamily._()
    : super(
        retry: null,
        name: r'processDownloadsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProcessDownloadsProvider call({bool? useWifi}) =>
      ProcessDownloadsProvider._(argument: useWifi, from: this);

  @override
  String toString() => r'processDownloadsProvider';
}
