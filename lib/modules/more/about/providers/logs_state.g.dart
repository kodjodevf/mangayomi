// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logs_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogsState)
final logsStateProvider = LogsStateProvider._();

final class LogsStateProvider extends $NotifierProvider<LogsState, bool> {
  LogsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logsStateHash();

  @$internal
  @override
  LogsState create() => LogsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$logsStateHash() => r'9adc5721141c5972a7674a1a0d9ed6eacca72294';

abstract class _$LogsState extends $Notifier<bool> {
  bool build();
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
    element.handleCreate(ref, build);
  }
}
