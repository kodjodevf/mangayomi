// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_recap_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Statistics shows the recap instead of the classic screen.

@ProviderFor(StatisticsRecapState)
final statisticsRecapStateProvider = StatisticsRecapStateProvider._();

/// Whether Statistics shows the recap instead of the classic screen.
final class StatisticsRecapStateProvider
    extends $NotifierProvider<StatisticsRecapState, bool> {
  /// Whether Statistics shows the recap instead of the classic screen.
  StatisticsRecapStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsRecapStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsRecapStateHash();

  @$internal
  @override
  StatisticsRecapState create() => StatisticsRecapState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$statisticsRecapStateHash() =>
    r'ce2fc148f4ff6c0e9a058a60bcb22973ba63b938';

/// Whether Statistics shows the recap instead of the classic screen.

abstract class _$StatisticsRecapState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The name in the Status Window; null shows the default.

@ProviderFor(StatisticsReaderNameState)
final statisticsReaderNameStateProvider = StatisticsReaderNameStateProvider._();

/// The name in the Status Window; null shows the default.
final class StatisticsReaderNameStateProvider
    extends $NotifierProvider<StatisticsReaderNameState, String?> {
  /// The name in the Status Window; null shows the default.
  StatisticsReaderNameStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsReaderNameStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsReaderNameStateHash();

  @$internal
  @override
  StatisticsReaderNameState create() => StatisticsReaderNameState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$statisticsReaderNameStateHash() =>
    r'6add7b907b39d43538b10b22c638459dc8e5e47e';

/// The name in the Status Window; null shows the default.

abstract class _$StatisticsReaderNameState extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
