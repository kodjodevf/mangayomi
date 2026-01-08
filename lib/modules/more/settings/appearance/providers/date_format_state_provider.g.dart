// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_format_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: true,
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

String _$dateFormatStateHash() => r'9b11f72b8fa535b74873365618089dfca957e445';

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
        isAutoDispose: true,
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
    r'fc39b88871e857dcd363c01df59de9ca174cb1d6';

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
