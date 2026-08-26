// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(L10nLocaleState)
final l10nLocaleStateProvider = L10nLocaleStateProvider._();

final class L10nLocaleStateProvider
    extends $NotifierProvider<L10nLocaleState, Locale> {
  L10nLocaleStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'l10nLocaleStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$l10nLocaleStateHash();

  @$internal
  @override
  L10nLocaleState create() => L10nLocaleState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$l10nLocaleStateHash() => r'88eafcec2dd0039018f12e8275d287c48d7dbae0';

abstract class _$L10nLocaleState extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
