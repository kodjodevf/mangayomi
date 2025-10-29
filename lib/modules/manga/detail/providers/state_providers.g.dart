// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChaptersListState)
const chaptersListStateProvider = ChaptersListStateProvider._();

final class ChaptersListStateProvider
    extends $NotifierProvider<ChaptersListState, List<Chapter>> {
  const ChaptersListStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chaptersListStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chaptersListStateHash();

  @$internal
  @override
  ChaptersListState create() => ChaptersListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Chapter> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Chapter>>(value),
    );
  }
}

String _$chaptersListStateHash() => r'251609214d127964e84d4616d2c3a7afa4fd80b4';

abstract class _$ChaptersListState extends $Notifier<List<Chapter>> {
  List<Chapter> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Chapter>, List<Chapter>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Chapter>, List<Chapter>>,
              List<Chapter>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IsLongPressedState)
const isLongPressedStateProvider = IsLongPressedStateProvider._();

final class IsLongPressedStateProvider
    extends $NotifierProvider<IsLongPressedState, bool> {
  const IsLongPressedStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLongPressedStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLongPressedStateHash();

  @$internal
  @override
  IsLongPressedState create() => IsLongPressedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLongPressedStateHash() =>
    r'26fe435e8381046a30e3f6c4495303946aa3aaa7';

abstract class _$IsLongPressedState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IsExtendedState)
const isExtendedStateProvider = IsExtendedStateProvider._();

final class IsExtendedStateProvider
    extends $NotifierProvider<IsExtendedState, bool> {
  const IsExtendedStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isExtendedStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isExtendedStateHash();

  @$internal
  @override
  IsExtendedState create() => IsExtendedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isExtendedStateHash() => r'e386098118bdebf67d489a4a2f49b017e02b27bf';

abstract class _$IsExtendedState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SortChapterState)
const sortChapterStateProvider = SortChapterStateFamily._();

final class SortChapterStateProvider
    extends $NotifierProvider<SortChapterState, SortChapter> {
  const SortChapterStateProvider._({
    required SortChapterStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sortChapterStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sortChapterStateHash();

  @override
  String toString() {
    return r'sortChapterStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SortChapterState create() => SortChapterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortChapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortChapter>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SortChapterStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sortChapterStateHash() => r'a6e547fd4badfa14ecb9270054c7e166dfc6e238';

final class SortChapterStateFamily extends $Family
    with
        $ClassFamilyOverride<
          SortChapterState,
          SortChapter,
          SortChapter,
          SortChapter,
          int
        > {
  const SortChapterStateFamily._()
    : super(
        retry: null,
        name: r'sortChapterStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SortChapterStateProvider call({required int mangaId}) =>
      SortChapterStateProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'sortChapterStateProvider';
}

abstract class _$SortChapterState extends $Notifier<SortChapter> {
  late final _$args = ref.$arg as int;
  int get mangaId => _$args;

  SortChapter build({required int mangaId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(mangaId: _$args);
    final ref = this.ref as $Ref<SortChapter, SortChapter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortChapter, SortChapter>,
              SortChapter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChapterFilterDownloadedState)
const chapterFilterDownloadedStateProvider =
    ChapterFilterDownloadedStateFamily._();

final class ChapterFilterDownloadedStateProvider
    extends $NotifierProvider<ChapterFilterDownloadedState, int> {
  const ChapterFilterDownloadedStateProvider._({
    required ChapterFilterDownloadedStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chapterFilterDownloadedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterFilterDownloadedStateHash();

  @override
  String toString() {
    return r'chapterFilterDownloadedStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterFilterDownloadedState create() => ChapterFilterDownloadedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterDownloadedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterFilterDownloadedStateHash() =>
    r'1a4309b9dff1fd9d1dc0c09eab18629ee9fe8d66';

final class ChapterFilterDownloadedStateFamily extends $Family
    with
        $ClassFamilyOverride<ChapterFilterDownloadedState, int, int, int, int> {
  const ChapterFilterDownloadedStateFamily._()
    : super(
        retry: null,
        name: r'chapterFilterDownloadedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterFilterDownloadedStateProvider call({required int mangaId}) =>
      ChapterFilterDownloadedStateProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'chapterFilterDownloadedStateProvider';
}

abstract class _$ChapterFilterDownloadedState extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get mangaId => _$args;

  int build({required int mangaId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(mangaId: _$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChapterFilterUnreadState)
const chapterFilterUnreadStateProvider = ChapterFilterUnreadStateFamily._();

final class ChapterFilterUnreadStateProvider
    extends $NotifierProvider<ChapterFilterUnreadState, int> {
  const ChapterFilterUnreadStateProvider._({
    required ChapterFilterUnreadStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chapterFilterUnreadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterFilterUnreadStateHash();

  @override
  String toString() {
    return r'chapterFilterUnreadStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterFilterUnreadState create() => ChapterFilterUnreadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterUnreadStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterFilterUnreadStateHash() =>
    r'95b34a7b0fd3282f8a2c0626c06ac251585fffec';

final class ChapterFilterUnreadStateFamily extends $Family
    with $ClassFamilyOverride<ChapterFilterUnreadState, int, int, int, int> {
  const ChapterFilterUnreadStateFamily._()
    : super(
        retry: null,
        name: r'chapterFilterUnreadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterFilterUnreadStateProvider call({required int mangaId}) =>
      ChapterFilterUnreadStateProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'chapterFilterUnreadStateProvider';
}

abstract class _$ChapterFilterUnreadState extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get mangaId => _$args;

  int build({required int mangaId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(mangaId: _$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChapterFilterBookmarkedState)
const chapterFilterBookmarkedStateProvider =
    ChapterFilterBookmarkedStateFamily._();

final class ChapterFilterBookmarkedStateProvider
    extends $NotifierProvider<ChapterFilterBookmarkedState, int> {
  const ChapterFilterBookmarkedStateProvider._({
    required ChapterFilterBookmarkedStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chapterFilterBookmarkedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterFilterBookmarkedStateHash();

  @override
  String toString() {
    return r'chapterFilterBookmarkedStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterFilterBookmarkedState create() => ChapterFilterBookmarkedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterBookmarkedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterFilterBookmarkedStateHash() =>
    r'639c257c1a77766438abf3b19cb61aa0eb7a8db6';

final class ChapterFilterBookmarkedStateFamily extends $Family
    with
        $ClassFamilyOverride<ChapterFilterBookmarkedState, int, int, int, int> {
  const ChapterFilterBookmarkedStateFamily._()
    : super(
        retry: null,
        name: r'chapterFilterBookmarkedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterFilterBookmarkedStateProvider call({required int mangaId}) =>
      ChapterFilterBookmarkedStateProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'chapterFilterBookmarkedStateProvider';
}

abstract class _$ChapterFilterBookmarkedState extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get mangaId => _$args;

  int build({required int mangaId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(mangaId: _$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChapterFilterResultState)
const chapterFilterResultStateProvider = ChapterFilterResultStateFamily._();

final class ChapterFilterResultStateProvider
    extends $NotifierProvider<ChapterFilterResultState, bool> {
  const ChapterFilterResultStateProvider._({
    required ChapterFilterResultStateFamily super.from,
    required Manga super.argument,
  }) : super(
         retry: null,
         name: r'chapterFilterResultStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterFilterResultStateHash();

  @override
  String toString() {
    return r'chapterFilterResultStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterFilterResultState create() => ChapterFilterResultState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterResultStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterFilterResultStateHash() =>
    r'ed7adcf7a9d34c3614547735b48789bb004f49cd';

final class ChapterFilterResultStateFamily extends $Family
    with
        $ClassFamilyOverride<
          ChapterFilterResultState,
          bool,
          bool,
          bool,
          Manga
        > {
  const ChapterFilterResultStateFamily._()
    : super(
        retry: null,
        name: r'chapterFilterResultStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterFilterResultStateProvider call({required Manga manga}) =>
      ChapterFilterResultStateProvider._(argument: manga, from: this);

  @override
  String toString() => r'chapterFilterResultStateProvider';
}

abstract class _$ChapterFilterResultState extends $Notifier<bool> {
  late final _$args = ref.$arg as Manga;
  Manga get manga => _$args;

  bool build({required Manga manga});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(manga: _$args);
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChapterSetIsBookmarkState)
const chapterSetIsBookmarkStateProvider = ChapterSetIsBookmarkStateFamily._();

final class ChapterSetIsBookmarkStateProvider
    extends $NotifierProvider<ChapterSetIsBookmarkState, void> {
  const ChapterSetIsBookmarkStateProvider._({
    required ChapterSetIsBookmarkStateFamily super.from,
    required Manga super.argument,
  }) : super(
         retry: null,
         name: r'chapterSetIsBookmarkStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterSetIsBookmarkStateHash();

  @override
  String toString() {
    return r'chapterSetIsBookmarkStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterSetIsBookmarkState create() => ChapterSetIsBookmarkState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsBookmarkStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterSetIsBookmarkStateHash() =>
    r'091d86aebaef46d2e9f35ae9f98c12c3e423f5b3';

final class ChapterSetIsBookmarkStateFamily extends $Family
    with
        $ClassFamilyOverride<
          ChapterSetIsBookmarkState,
          void,
          void,
          void,
          Manga
        > {
  const ChapterSetIsBookmarkStateFamily._()
    : super(
        retry: null,
        name: r'chapterSetIsBookmarkStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterSetIsBookmarkStateProvider call({required Manga manga}) =>
      ChapterSetIsBookmarkStateProvider._(argument: manga, from: this);

  @override
  String toString() => r'chapterSetIsBookmarkStateProvider';
}

abstract class _$ChapterSetIsBookmarkState extends $Notifier<void> {
  late final _$args = ref.$arg as Manga;
  Manga get manga => _$args;

  void build({required Manga manga});
  @$mustCallSuper
  @override
  void runBuild() {
    build(manga: _$args);
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(ChapterSetIsReadState)
const chapterSetIsReadStateProvider = ChapterSetIsReadStateFamily._();

final class ChapterSetIsReadStateProvider
    extends $NotifierProvider<ChapterSetIsReadState, void> {
  const ChapterSetIsReadStateProvider._({
    required ChapterSetIsReadStateFamily super.from,
    required Manga super.argument,
  }) : super(
         retry: null,
         name: r'chapterSetIsReadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterSetIsReadStateHash();

  @override
  String toString() {
    return r'chapterSetIsReadStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterSetIsReadState create() => ChapterSetIsReadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsReadStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterSetIsReadStateHash() =>
    r'f5af852964964170905278d563fdb03eabed53b9';

final class ChapterSetIsReadStateFamily extends $Family
    with $ClassFamilyOverride<ChapterSetIsReadState, void, void, void, Manga> {
  const ChapterSetIsReadStateFamily._()
    : super(
        retry: null,
        name: r'chapterSetIsReadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterSetIsReadStateProvider call({required Manga manga}) =>
      ChapterSetIsReadStateProvider._(argument: manga, from: this);

  @override
  String toString() => r'chapterSetIsReadStateProvider';
}

abstract class _$ChapterSetIsReadState extends $Notifier<void> {
  late final _$args = ref.$arg as Manga;
  Manga get manga => _$args;

  void build({required Manga manga});
  @$mustCallSuper
  @override
  void runBuild() {
    build(manga: _$args);
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(ChapterSetDownloadState)
const chapterSetDownloadStateProvider = ChapterSetDownloadStateFamily._();

final class ChapterSetDownloadStateProvider
    extends $NotifierProvider<ChapterSetDownloadState, void> {
  const ChapterSetDownloadStateProvider._({
    required ChapterSetDownloadStateFamily super.from,
    required Manga super.argument,
  }) : super(
         retry: null,
         name: r'chapterSetDownloadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterSetDownloadStateHash();

  @override
  String toString() {
    return r'chapterSetDownloadStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterSetDownloadState create() => ChapterSetDownloadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetDownloadStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterSetDownloadStateHash() =>
    r'2f35d274b76e28376b0089b2f6ee6d9d7ebcbeec';

final class ChapterSetDownloadStateFamily extends $Family
    with
        $ClassFamilyOverride<ChapterSetDownloadState, void, void, void, Manga> {
  const ChapterSetDownloadStateFamily._()
    : super(
        retry: null,
        name: r'chapterSetDownloadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterSetDownloadStateProvider call({required Manga manga}) =>
      ChapterSetDownloadStateProvider._(argument: manga, from: this);

  @override
  String toString() => r'chapterSetDownloadStateProvider';
}

abstract class _$ChapterSetDownloadState extends $Notifier<void> {
  late final _$args = ref.$arg as Manga;
  Manga get manga => _$args;

  void build({required Manga manga});
  @$mustCallSuper
  @override
  void runBuild() {
    build(manga: _$args);
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(ChaptersListttState)
const chaptersListttStateProvider = ChaptersListttStateProvider._();

final class ChaptersListttStateProvider
    extends $NotifierProvider<ChaptersListttState, List<Chapter>> {
  const ChaptersListttStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chaptersListttStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chaptersListttStateHash();

  @$internal
  @override
  ChaptersListttState create() => ChaptersListttState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Chapter> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Chapter>>(value),
    );
  }
}

String _$chaptersListttStateHash() =>
    r'5f1b0d2be32fcb904c12c5735f1340c8b33400a9';

abstract class _$ChaptersListttState extends $Notifier<List<Chapter>> {
  List<Chapter> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Chapter>, List<Chapter>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Chapter>, List<Chapter>>,
              List<Chapter>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ScanlatorsFilterState)
const scanlatorsFilterStateProvider = ScanlatorsFilterStateFamily._();

final class ScanlatorsFilterStateProvider
    extends
        $NotifierProvider<
          ScanlatorsFilterState,
          (List<String>, List<String>, List<String>)
        > {
  const ScanlatorsFilterStateProvider._({
    required ScanlatorsFilterStateFamily super.from,
    required Manga super.argument,
  }) : super(
         retry: null,
         name: r'scanlatorsFilterStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scanlatorsFilterStateHash();

  @override
  String toString() {
    return r'scanlatorsFilterStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ScanlatorsFilterState create() => ScanlatorsFilterState();

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
    return other is ScanlatorsFilterStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scanlatorsFilterStateHash() =>
    r'8da89864801cd7620029d28cfb3f9bee3c67cba8';

final class ScanlatorsFilterStateFamily extends $Family
    with
        $ClassFamilyOverride<
          ScanlatorsFilterState,
          (List<String>, List<String>, List<String>),
          (List<String>, List<String>, List<String>),
          (List<String>, List<String>, List<String>),
          Manga
        > {
  const ScanlatorsFilterStateFamily._()
    : super(
        retry: null,
        name: r'scanlatorsFilterStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ScanlatorsFilterStateProvider call(Manga manga) =>
      ScanlatorsFilterStateProvider._(argument: manga, from: this);

  @override
  String toString() => r'scanlatorsFilterStateProvider';
}

abstract class _$ScanlatorsFilterState
    extends $Notifier<(List<String>, List<String>, List<String>)> {
  late final _$args = ref.$arg as Manga;
  Manga get manga => _$args;

  (List<String>, List<String>, List<String>) build(Manga manga);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
    element.handleValue(ref, created);
  }
}
