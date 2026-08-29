// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryDisplayTypeState)
final libraryDisplayTypeStateProvider = LibraryDisplayTypeStateFamily._();

final class LibraryDisplayTypeStateProvider
    extends $NotifierProvider<LibraryDisplayTypeState, DisplayType> {
  LibraryDisplayTypeStateProvider._({
    required LibraryDisplayTypeStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryDisplayTypeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryDisplayTypeStateHash();

  @override
  String toString() {
    return r'libraryDisplayTypeStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryDisplayTypeState create() => LibraryDisplayTypeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayType>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDisplayTypeStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryDisplayTypeStateHash() =>
    r'521b4fe8fac01994cdcc2228070ebb60a7d68131';

final class LibraryDisplayTypeStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryDisplayTypeState,
          DisplayType,
          DisplayType,
          DisplayType,
          ({ItemType itemType, Settings settings})
        > {
  LibraryDisplayTypeStateFamily._()
    : super(
        retry: null,
        name: r'libraryDisplayTypeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryDisplayTypeStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryDisplayTypeStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryDisplayTypeStateProvider';
}

abstract class _$LibraryDisplayTypeState extends $Notifier<DisplayType> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  DisplayType build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DisplayType, DisplayType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DisplayType, DisplayType>,
              DisplayType,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryGridSizeState)
final libraryGridSizeStateProvider = LibraryGridSizeStateFamily._();

final class LibraryGridSizeStateProvider
    extends $NotifierProvider<LibraryGridSizeState, int?> {
  LibraryGridSizeStateProvider._({
    required LibraryGridSizeStateFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'libraryGridSizeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryGridSizeStateHash();

  @override
  String toString() {
    return r'libraryGridSizeStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LibraryGridSizeState create() => LibraryGridSizeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryGridSizeStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryGridSizeStateHash() =>
    r'348939cae58b2184c3cbec2dd35cfabc6d7ffcf2';

final class LibraryGridSizeStateFamily extends $Family
    with
        $ClassFamilyOverride<LibraryGridSizeState, int?, int?, int?, ItemType> {
  LibraryGridSizeStateFamily._()
    : super(
        retry: null,
        name: r'libraryGridSizeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryGridSizeStateProvider call({required ItemType itemType}) =>
      LibraryGridSizeStateProvider._(argument: itemType, from: this);

  @override
  String toString() => r'libraryGridSizeStateProvider';
}

abstract class _$LibraryGridSizeState extends $Notifier<int?> {
  late final _$args = ref.$arg as ItemType;
  ItemType get itemType => _$args;

  int? build({required ItemType itemType});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(itemType: _$args));
  }
}

@ProviderFor(MangaFilterDownloadedState)
final mangaFilterDownloadedStateProvider = MangaFilterDownloadedStateFamily._();

final class MangaFilterDownloadedStateProvider
    extends $NotifierProvider<MangaFilterDownloadedState, int> {
  MangaFilterDownloadedStateProvider._({
    required MangaFilterDownloadedStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterDownloadedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterDownloadedStateHash();

  @override
  String toString() {
    return r'mangaFilterDownloadedStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterDownloadedState create() => MangaFilterDownloadedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterDownloadedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterDownloadedStateHash() =>
    r'43ef8051ae6b2d1e32ca8fe2950e0a3c069d8de9';

final class MangaFilterDownloadedStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterDownloadedState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterDownloadedStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterDownloadedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterDownloadedStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterDownloadedStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterDownloadedStateProvider';
}

abstract class _$MangaFilterDownloadedState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterUnreadState)
final mangaFilterUnreadStateProvider = MangaFilterUnreadStateFamily._();

final class MangaFilterUnreadStateProvider
    extends $NotifierProvider<MangaFilterUnreadState, int> {
  MangaFilterUnreadStateProvider._({
    required MangaFilterUnreadStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterUnreadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterUnreadStateHash();

  @override
  String toString() {
    return r'mangaFilterUnreadStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterUnreadState create() => MangaFilterUnreadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterUnreadStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterUnreadStateHash() =>
    r'416ed3cf6a921cf9d53ee7b6d08c7171b76e032d';

final class MangaFilterUnreadStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterUnreadState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterUnreadStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterUnreadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterUnreadStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterUnreadStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterUnreadStateProvider';
}

abstract class _$MangaFilterUnreadState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterStartedState)
final mangaFilterStartedStateProvider = MangaFilterStartedStateFamily._();

final class MangaFilterStartedStateProvider
    extends $NotifierProvider<MangaFilterStartedState, int> {
  MangaFilterStartedStateProvider._({
    required MangaFilterStartedStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterStartedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterStartedStateHash();

  @override
  String toString() {
    return r'mangaFilterStartedStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterStartedState create() => MangaFilterStartedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterStartedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterStartedStateHash() =>
    r'169b7a91303ed2141835c7ed38efc9a482492dea';

final class MangaFilterStartedStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterStartedState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterStartedStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterStartedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterStartedStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterStartedStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterStartedStateProvider';
}

abstract class _$MangaFilterStartedState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterBookmarkedState)
final mangaFilterBookmarkedStateProvider = MangaFilterBookmarkedStateFamily._();

final class MangaFilterBookmarkedStateProvider
    extends $NotifierProvider<MangaFilterBookmarkedState, int> {
  MangaFilterBookmarkedStateProvider._({
    required MangaFilterBookmarkedStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterBookmarkedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterBookmarkedStateHash();

  @override
  String toString() {
    return r'mangaFilterBookmarkedStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterBookmarkedState create() => MangaFilterBookmarkedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterBookmarkedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterBookmarkedStateHash() =>
    r'b7003b8c6c6143a74fcfeb1624b1252d2cbd8499';

final class MangaFilterBookmarkedStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterBookmarkedState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterBookmarkedStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterBookmarkedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterBookmarkedStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterBookmarkedStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterBookmarkedStateProvider';
}

abstract class _$MangaFilterBookmarkedState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterCompletedState)
final mangaFilterCompletedStateProvider = MangaFilterCompletedStateFamily._();

final class MangaFilterCompletedStateProvider
    extends $NotifierProvider<MangaFilterCompletedState, int> {
  MangaFilterCompletedStateProvider._({
    required MangaFilterCompletedStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterCompletedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterCompletedStateHash();

  @override
  String toString() {
    return r'mangaFilterCompletedStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterCompletedState create() => MangaFilterCompletedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterCompletedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterCompletedStateHash() =>
    r'6bc325789efeeb57f8f33c85279e9cb9ac99dd42';

final class MangaFilterCompletedStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterCompletedState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterCompletedStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterCompletedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterCompletedStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterCompletedStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterCompletedStateProvider';
}

abstract class _$MangaFilterCompletedState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterTrackingState)
final mangaFilterTrackingStateProvider = MangaFilterTrackingStateFamily._();

final class MangaFilterTrackingStateProvider
    extends $NotifierProvider<MangaFilterTrackingState, int> {
  MangaFilterTrackingStateProvider._({
    required MangaFilterTrackingStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterTrackingStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterTrackingStateHash();

  @override
  String toString() {
    return r'mangaFilterTrackingStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterTrackingState create() => MangaFilterTrackingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterTrackingStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterTrackingStateHash() =>
    r'd05260918e5d0fffe08cfe29c14ef095b8285043';

final class MangaFilterTrackingStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterTrackingState,
          int,
          int,
          int,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterTrackingStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterTrackingStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterTrackingStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterTrackingStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterTrackingStateProvider';
}

abstract class _$MangaFilterTrackingState extends $Notifier<int> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangaFilterSourceState)
final mangaFilterSourceStateProvider = MangaFilterSourceStateFamily._();

final class MangaFilterSourceStateProvider
    extends
        $NotifierProvider<
          MangaFilterSourceState,
          (List<String>, List<String>, List<String>)
        > {
  MangaFilterSourceStateProvider._({
    required MangaFilterSourceStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangaFilterSourceStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFilterSourceStateHash();

  @override
  String toString() {
    return r'mangaFilterSourceStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFilterSourceState create() => MangaFilterSourceState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((List<String>, List<String>, List<String>) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<(List<String>, List<String>, List<String>)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterSourceStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFilterSourceStateHash() =>
    r'045578db4403b26946889e57243603c9f3196d4f';

final class MangaFilterSourceStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFilterSourceState,
          (List<String>, List<String>, List<String>),
          (List<String>, List<String>, List<String>),
          (List<String>, List<String>, List<String>),
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangaFilterSourceStateFamily._()
    : super(
        retry: null,
        name: r'mangaFilterSourceStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFilterSourceStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangaFilterSourceStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFilterSourceStateProvider';
}

abstract class _$MangaFilterSourceState
    extends $Notifier<(List<String>, List<String>, List<String>)> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  (List<String>, List<String>, List<String>) build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              (List<String>, List<String>, List<String>),
              (List<String>, List<String>, List<String>)
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                (List<String>, List<String>, List<String>),
                (List<String>, List<String>, List<String>)
              >,
              (List<String>, List<String>, List<String>),
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(MangasFilterResultState)
final mangasFilterResultStateProvider = MangasFilterResultStateFamily._();

final class MangasFilterResultStateProvider
    extends $NotifierProvider<MangasFilterResultState, bool> {
  MangasFilterResultStateProvider._({
    required MangasFilterResultStateFamily super.from,
    required ({List<Manga> mangaList, ItemType itemType, Settings settings})
    super.argument,
  }) : super(
         retry: null,
         name: r'mangasFilterResultStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangasFilterResultStateHash();

  @override
  String toString() {
    return r'mangasFilterResultStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangasFilterResultState create() => MangasFilterResultState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangasFilterResultStateHash() =>
    r'ad6d3e947f219ad87d0ed126b4b17331295599a5';

final class MangasFilterResultStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangasFilterResultState,
          bool,
          bool,
          bool,
          ({List<Manga> mangaList, ItemType itemType, Settings settings})
        > {
  MangasFilterResultStateFamily._()
    : super(
        retry: null,
        name: r'mangasFilterResultStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangasFilterResultStateProvider call({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) => MangasFilterResultStateProvider._(
    argument: (mangaList: mangaList, itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangasFilterResultStateProvider';
}

abstract class _$MangasFilterResultState extends $Notifier<bool> {
  late final _$args =
      ref.$arg
          as ({List<Manga> mangaList, ItemType itemType, Settings settings});
  List<Manga> get mangaList => _$args.mangaList;
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        mangaList: _$args.mangaList,
        itemType: _$args.itemType,
        settings: _$args.settings,
      ),
    );
  }
}

@ProviderFor(LibraryShowCategoryTabsState)
final libraryShowCategoryTabsStateProvider =
    LibraryShowCategoryTabsStateFamily._();

final class LibraryShowCategoryTabsStateProvider
    extends $NotifierProvider<LibraryShowCategoryTabsState, bool> {
  LibraryShowCategoryTabsStateProvider._({
    required LibraryShowCategoryTabsStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowCategoryTabsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryShowCategoryTabsStateHash();

  @override
  String toString() {
    return r'libraryShowCategoryTabsStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowCategoryTabsState create() => LibraryShowCategoryTabsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowCategoryTabsStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowCategoryTabsStateHash() =>
    r'9dd38f0826f7728db4f8aef1a24f9807d0af65aa';

final class LibraryShowCategoryTabsStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowCategoryTabsState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowCategoryTabsStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowCategoryTabsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowCategoryTabsStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowCategoryTabsStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowCategoryTabsStateProvider';
}

abstract class _$LibraryShowCategoryTabsState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryDownloadedChaptersState)
final libraryDownloadedChaptersStateProvider =
    LibraryDownloadedChaptersStateFamily._();

final class LibraryDownloadedChaptersStateProvider
    extends $NotifierProvider<LibraryDownloadedChaptersState, bool> {
  LibraryDownloadedChaptersStateProvider._({
    required LibraryDownloadedChaptersStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryDownloadedChaptersStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryDownloadedChaptersStateHash();

  @override
  String toString() {
    return r'libraryDownloadedChaptersStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryDownloadedChaptersState create() => LibraryDownloadedChaptersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadedChaptersStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryDownloadedChaptersStateHash() =>
    r'c58036a1f9c8efedb90766f3fc8a573741586578';

final class LibraryDownloadedChaptersStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryDownloadedChaptersState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryDownloadedChaptersStateFamily._()
    : super(
        retry: null,
        name: r'libraryDownloadedChaptersStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryDownloadedChaptersStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryDownloadedChaptersStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryDownloadedChaptersStateProvider';
}

abstract class _$LibraryDownloadedChaptersState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryLanguageState)
final libraryLanguageStateProvider = LibraryLanguageStateFamily._();

final class LibraryLanguageStateProvider
    extends $NotifierProvider<LibraryLanguageState, bool> {
  LibraryLanguageStateProvider._({
    required LibraryLanguageStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryLanguageStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryLanguageStateHash();

  @override
  String toString() {
    return r'libraryLanguageStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryLanguageState create() => LibraryLanguageState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLanguageStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryLanguageStateHash() =>
    r'629f7e7cb623327dfd86303001fce5470c9f6ddf';

final class LibraryLanguageStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryLanguageState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryLanguageStateFamily._()
    : super(
        retry: null,
        name: r'libraryLanguageStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryLanguageStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryLanguageStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryLanguageStateProvider';
}

abstract class _$LibraryLanguageState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryLocalSourceState)
final libraryLocalSourceStateProvider = LibraryLocalSourceStateFamily._();

final class LibraryLocalSourceStateProvider
    extends $NotifierProvider<LibraryLocalSourceState, bool> {
  LibraryLocalSourceStateProvider._({
    required LibraryLocalSourceStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryLocalSourceStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryLocalSourceStateHash();

  @override
  String toString() {
    return r'libraryLocalSourceStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryLocalSourceState create() => LibraryLocalSourceState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLocalSourceStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryLocalSourceStateHash() =>
    r'971613def73be4d0109a8e5d3f856a07b0dc5c2d';

final class LibraryLocalSourceStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryLocalSourceState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryLocalSourceStateFamily._()
    : super(
        retry: null,
        name: r'libraryLocalSourceStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryLocalSourceStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryLocalSourceStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryLocalSourceStateProvider';
}

abstract class _$LibraryLocalSourceState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryShowNumbersOfItemsState)
final libraryShowNumbersOfItemsStateProvider =
    LibraryShowNumbersOfItemsStateFamily._();

final class LibraryShowNumbersOfItemsStateProvider
    extends $NotifierProvider<LibraryShowNumbersOfItemsState, bool> {
  LibraryShowNumbersOfItemsStateProvider._({
    required LibraryShowNumbersOfItemsStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowNumbersOfItemsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryShowNumbersOfItemsStateHash();

  @override
  String toString() {
    return r'libraryShowNumbersOfItemsStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowNumbersOfItemsState create() => LibraryShowNumbersOfItemsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowNumbersOfItemsStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowNumbersOfItemsStateHash() =>
    r'9cbe0d59f776e530ef64b40a6e8bd288b67843d2';

final class LibraryShowNumbersOfItemsStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowNumbersOfItemsState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowNumbersOfItemsStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowNumbersOfItemsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowNumbersOfItemsStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowNumbersOfItemsStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowNumbersOfItemsStateProvider';
}

abstract class _$LibraryShowNumbersOfItemsState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryShowContinueReadingButtonState)
final libraryShowContinueReadingButtonStateProvider =
    LibraryShowContinueReadingButtonStateFamily._();

final class LibraryShowContinueReadingButtonStateProvider
    extends $NotifierProvider<LibraryShowContinueReadingButtonState, bool> {
  LibraryShowContinueReadingButtonStateProvider._({
    required LibraryShowContinueReadingButtonStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowContinueReadingButtonStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$libraryShowContinueReadingButtonStateHash();

  @override
  String toString() {
    return r'libraryShowContinueReadingButtonStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowContinueReadingButtonState create() =>
      LibraryShowContinueReadingButtonState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowContinueReadingButtonStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowContinueReadingButtonStateHash() =>
    r'55bbf3262837651eafc7a34cbaa4f1c24e587c82';

final class LibraryShowContinueReadingButtonStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowContinueReadingButtonState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowContinueReadingButtonStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowContinueReadingButtonStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowContinueReadingButtonStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowContinueReadingButtonStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowContinueReadingButtonStateProvider';
}

abstract class _$LibraryShowContinueReadingButtonState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(SortLibraryMangaState)
final sortLibraryMangaStateProvider = SortLibraryMangaStateFamily._();

final class SortLibraryMangaStateProvider
    extends $NotifierProvider<SortLibraryMangaState, SortLibraryManga> {
  SortLibraryMangaStateProvider._({
    required SortLibraryMangaStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'sortLibraryMangaStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sortLibraryMangaStateHash();

  @override
  String toString() {
    return r'sortLibraryMangaStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SortLibraryMangaState create() => SortLibraryMangaState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortLibraryManga value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortLibraryManga>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SortLibraryMangaStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sortLibraryMangaStateHash() =>
    r'abf901ae0407fc8fd5ef02ae05587a443e46be8a';

final class SortLibraryMangaStateFamily extends $Family
    with
        $ClassFamilyOverride<
          SortLibraryMangaState,
          SortLibraryManga,
          SortLibraryManga,
          SortLibraryManga,
          ({ItemType itemType, Settings settings})
        > {
  SortLibraryMangaStateFamily._()
    : super(
        retry: null,
        name: r'sortLibraryMangaStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SortLibraryMangaStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => SortLibraryMangaStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'sortLibraryMangaStateProvider';
}

abstract class _$SortLibraryMangaState extends $Notifier<SortLibraryManga> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  SortLibraryManga build({
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SortLibraryManga, SortLibraryManga>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortLibraryManga, SortLibraryManga>,
              SortLibraryManga,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(MangasListState)
final mangasListStateProvider = MangasListStateProvider._();

final class MangasListStateProvider
    extends $NotifierProvider<MangasListState, Set<int>> {
  MangasListStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mangasListStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mangasListStateHash();

  @$internal
  @override
  MangasListState create() => MangasListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$mangasListStateHash() => r'61c6477ea43c6113caa89ef13984cd4370d303ee';

abstract class _$MangasListState extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MangasSetIsReadState)
final mangasSetIsReadStateProvider = MangasSetIsReadStateFamily._();

final class MangasSetIsReadStateProvider
    extends $NotifierProvider<MangasSetIsReadState, void> {
  MangasSetIsReadStateProvider._({
    required MangasSetIsReadStateFamily super.from,
    required ({Set<int> mangaIds, bool markAsRead}) super.argument,
  }) : super(
         retry: null,
         name: r'mangasSetIsReadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangasSetIsReadStateHash();

  @override
  String toString() {
    return r'mangasSetIsReadStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangasSetIsReadState create() => MangasSetIsReadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetIsReadStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangasSetIsReadStateHash() =>
    r'7bd5ede4ee9932ca30740fda7b4ae5257f3bcdb0';

final class MangasSetIsReadStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangasSetIsReadState,
          void,
          void,
          void,
          ({Set<int> mangaIds, bool markAsRead})
        > {
  MangasSetIsReadStateFamily._()
    : super(
        retry: null,
        name: r'mangasSetIsReadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangasSetIsReadStateProvider call({
    required Set<int> mangaIds,
    required bool markAsRead,
  }) => MangasSetIsReadStateProvider._(
    argument: (mangaIds: mangaIds, markAsRead: markAsRead),
    from: this,
  );

  @override
  String toString() => r'mangasSetIsReadStateProvider';
}

abstract class _$MangasSetIsReadState extends $Notifier<void> {
  late final _$args = ref.$arg as ({Set<int> mangaIds, bool markAsRead});
  Set<int> get mangaIds => _$args.mangaIds;
  bool get markAsRead => _$args.markAsRead;

  void build({required Set<int> mangaIds, required bool markAsRead});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(mangaIds: _$args.mangaIds, markAsRead: _$args.markAsRead),
    );
  }
}
