// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CachedSettings)
final cachedSettingsProvider = CachedSettingsProvider._();

final class CachedSettingsProvider
    extends $NotifierProvider<CachedSettings, Settings> {
  CachedSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedSettingsHash();

  @$internal
  @override
  CachedSettings create() => CachedSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Settings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Settings>(value),
    );
  }
}

String _$cachedSettingsHash() => r'cca31a701908621a8cdc9b641bb2eb70225a2f7b';

abstract class _$CachedSettings extends $Notifier<Settings> {
  Settings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Settings, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Settings, Settings>,
              Settings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
