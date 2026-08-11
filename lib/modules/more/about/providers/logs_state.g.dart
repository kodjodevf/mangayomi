// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logs_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(logsState)
final logsStateProvider = LogsStateProvider._();

final class LogsStateProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
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
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return logsState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$logsStateHash() => r'680ab781a039e0441394dc0b376b8add0fb80910';
