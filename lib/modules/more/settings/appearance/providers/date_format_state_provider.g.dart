// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_format_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live view of the single Settings row (id 227), shared by every provider
/// that only needs one field off it. Settings is a large row (several list
/// fields, some unbounded), so this exists to make sure it only gets
/// deserialized when it actually changes — once — instead of every reader
/// doing its own isar.settings.getSync() on every single read.

@ProviderFor(settingsStream)
final settingsStreamProvider = SettingsStreamProvider._();

/// Live view of the single Settings row (id 227), shared by every provider
/// that only needs one field off it. Settings is a large row (several list
/// fields, some unbounded), so this exists to make sure it only gets
/// deserialized when it actually changes — once — instead of every reader
/// doing its own isar.settings.getSync() on every single read.

final class SettingsStreamProvider
    extends
        $FunctionalProvider<AsyncValue<Settings>, Settings, Stream<Settings>>
    with $FutureModifier<Settings>, $StreamProvider<Settings> {
  /// Live view of the single Settings row (id 227), shared by every provider
  /// that only needs one field off it. Settings is a large row (several list
  /// fields, some unbounded), so this exists to make sure it only gets
  /// deserialized when it actually changes — once — instead of every reader
  /// doing its own isar.settings.getSync() on every single read.
  SettingsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStreamHash();

  @$internal
  @override
  $StreamProviderElement<Settings> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Settings> create(Ref ref) {
    return settingsStream(ref);
  }
}

String _$settingsStreamHash() => r'c868936fe474c9c77cd4709f4963526da39b625a';

@ProviderFor(DateFormatState)
final dateFormatStateProvider = DateFormatStateProvider._();

final class DateFormatStateProvider
    extends $NotifierProvider<DateFormatState, String> {
  DateFormatStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateFormatStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateFormatStateHash();

  @$internal
  @override
  DateFormatState create() => DateFormatState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$dateFormatStateHash() => r'c585f589b476358c657126e844ce496dea762f2d';

abstract class _$DateFormatState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(RelativeTimesTampsState)
final relativeTimesTampsStateProvider = RelativeTimesTampsStateProvider._();

final class RelativeTimesTampsStateProvider
    extends $NotifierProvider<RelativeTimesTampsState, int> {
  RelativeTimesTampsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'relativeTimesTampsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$relativeTimesTampsStateHash();

  @$internal
  @override
  RelativeTimesTampsState create() => RelativeTimesTampsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$relativeTimesTampsStateHash() =>
    r'b2246fed868512fdc44a3b403c766a02a1e646d7';

abstract class _$RelativeTimesTampsState extends $Notifier<int> {
  int build();
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
    element.handleCreate(ref, build);
  }
}
