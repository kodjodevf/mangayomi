// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addDownloadToQueueHash() =>
    r'35e8e724755be265a9bf167e4641336630a465d2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [addDownloadToQueue].
@ProviderFor(addDownloadToQueue)
const addDownloadToQueueProvider = AddDownloadToQueueFamily();

/// See also [addDownloadToQueue].
class AddDownloadToQueueFamily extends Family<AsyncValue<void>> {
  /// See also [addDownloadToQueue].
  const AddDownloadToQueueFamily();

  /// See also [addDownloadToQueue].
  AddDownloadToQueueProvider call({
    required Chapter chapter,
  }) {
    return AddDownloadToQueueProvider(
      chapter: chapter,
    );
  }

  @override
  AddDownloadToQueueProvider getProviderOverride(
    covariant AddDownloadToQueueProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addDownloadToQueueProvider';
}

/// See also [addDownloadToQueue].
class AddDownloadToQueueProvider extends AutoDisposeFutureProvider<void> {
  /// See also [addDownloadToQueue].
  AddDownloadToQueueProvider({
    required Chapter chapter,
  }) : this._internal(
          (ref) => addDownloadToQueue(
            ref as AddDownloadToQueueRef,
            chapter: chapter,
          ),
          from: addDownloadToQueueProvider,
          name: r'addDownloadToQueueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addDownloadToQueueHash,
          dependencies: AddDownloadToQueueFamily._dependencies,
          allTransitiveDependencies:
              AddDownloadToQueueFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  AddDownloadToQueueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  Override overrideWith(
    FutureOr<void> Function(AddDownloadToQueueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddDownloadToQueueProvider._internal(
        (ref) => create(ref as AddDownloadToQueueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddDownloadToQueueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddDownloadToQueueProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddDownloadToQueueRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _AddDownloadToQueueProviderElement
    extends AutoDisposeFutureProviderElement<void> with AddDownloadToQueueRef {
  _AddDownloadToQueueProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as AddDownloadToQueueProvider).chapter;
}

String _$downloadChapterHash() => r'4d008f26f03bf21010742b73cf83643c61f66c2b';

/// See also [downloadChapter].
@ProviderFor(downloadChapter)
const downloadChapterProvider = DownloadChapterFamily();

/// See also [downloadChapter].
class DownloadChapterFamily extends Family<AsyncValue<void>> {
  /// See also [downloadChapter].
  const DownloadChapterFamily();

  /// See also [downloadChapter].
  DownloadChapterProvider call({
    required Chapter chapter,
    bool? useWifi,
    void Function()? callback,
  }) {
    return DownloadChapterProvider(
      chapter: chapter,
      useWifi: useWifi,
      callback: callback,
    );
  }

  @override
  DownloadChapterProvider getProviderOverride(
    covariant DownloadChapterProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
      useWifi: provider.useWifi,
      callback: provider.callback,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'downloadChapterProvider';
}

/// See also [downloadChapter].
class DownloadChapterProvider extends AutoDisposeFutureProvider<void> {
  /// See also [downloadChapter].
  DownloadChapterProvider({
    required Chapter chapter,
    bool? useWifi,
    void Function()? callback,
  }) : this._internal(
          (ref) => downloadChapter(
            ref as DownloadChapterRef,
            chapter: chapter,
            useWifi: useWifi,
            callback: callback,
          ),
          from: downloadChapterProvider,
          name: r'downloadChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$downloadChapterHash,
          dependencies: DownloadChapterFamily._dependencies,
          allTransitiveDependencies:
              DownloadChapterFamily._allTransitiveDependencies,
          chapter: chapter,
          useWifi: useWifi,
          callback: callback,
        );

  DownloadChapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
    required this.useWifi,
    required this.callback,
  }) : super.internal();

  final Chapter chapter;
  final bool? useWifi;
  final void Function()? callback;

  @override
  Override overrideWith(
    FutureOr<void> Function(DownloadChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DownloadChapterProvider._internal(
        (ref) => create(ref as DownloadChapterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
        useWifi: useWifi,
        callback: callback,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DownloadChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadChapterProvider &&
        other.chapter == chapter &&
        other.useWifi == useWifi &&
        other.callback == callback;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);
    hash = _SystemHash.combine(hash, useWifi.hashCode);
    hash = _SystemHash.combine(hash, callback.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DownloadChapterRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;

  /// The parameter `useWifi` of this provider.
  bool? get useWifi;

  /// The parameter `callback` of this provider.
  void Function()? get callback;
}

class _DownloadChapterProviderElement
    extends AutoDisposeFutureProviderElement<void> with DownloadChapterRef {
  _DownloadChapterProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as DownloadChapterProvider).chapter;
  @override
  bool? get useWifi => (origin as DownloadChapterProvider).useWifi;
  @override
  void Function()? get callback => (origin as DownloadChapterProvider).callback;
}

String _$processDownloadsHash() => r'ef5107f9674f2175a7aa18b8e4fc4555f3b6b584';

/// See also [processDownloads].
@ProviderFor(processDownloads)
const processDownloadsProvider = ProcessDownloadsFamily();

/// See also [processDownloads].
class ProcessDownloadsFamily extends Family<AsyncValue<void>> {
  /// See also [processDownloads].
  const ProcessDownloadsFamily();

  /// See also [processDownloads].
  ProcessDownloadsProvider call({
    bool? useWifi,
  }) {
    return ProcessDownloadsProvider(
      useWifi: useWifi,
    );
  }

  @override
  ProcessDownloadsProvider getProviderOverride(
    covariant ProcessDownloadsProvider provider,
  ) {
    return call(
      useWifi: provider.useWifi,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'processDownloadsProvider';
}

/// See also [processDownloads].
class ProcessDownloadsProvider extends AutoDisposeFutureProvider<void> {
  /// See also [processDownloads].
  ProcessDownloadsProvider({
    bool? useWifi,
  }) : this._internal(
          (ref) => processDownloads(
            ref as ProcessDownloadsRef,
            useWifi: useWifi,
          ),
          from: processDownloadsProvider,
          name: r'processDownloadsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$processDownloadsHash,
          dependencies: ProcessDownloadsFamily._dependencies,
          allTransitiveDependencies:
              ProcessDownloadsFamily._allTransitiveDependencies,
          useWifi: useWifi,
        );

  ProcessDownloadsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.useWifi,
  }) : super.internal();

  final bool? useWifi;

  @override
  Override overrideWith(
    FutureOr<void> Function(ProcessDownloadsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProcessDownloadsProvider._internal(
        (ref) => create(ref as ProcessDownloadsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        useWifi: useWifi,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ProcessDownloadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProcessDownloadsProvider && other.useWifi == useWifi;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, useWifi.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProcessDownloadsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `useWifi` of this provider.
  bool? get useWifi;
}

class _ProcessDownloadsProviderElement
    extends AutoDisposeFutureProviderElement<void> with ProcessDownloadsRef {
  _ProcessDownloadsProviderElement(super.provider);

  @override
  bool? get useWifi => (origin as ProcessDownloadsProvider).useWifi;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
