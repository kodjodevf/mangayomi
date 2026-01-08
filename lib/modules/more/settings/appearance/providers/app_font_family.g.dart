// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_font_family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppFontFamily)
final appFontFamilyProvider = AppFontFamilyProvider._();

final class AppFontFamilyProvider
    extends $NotifierProvider<AppFontFamily, String?> {
  AppFontFamilyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appFontFamilyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appFontFamilyHash();

  @$internal
  @override
  AppFontFamily create() => AppFontFamily();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$appFontFamilyHash() => r'edc7d34d3b1aa149fdbd95fa0b07d9746b7279b1';

abstract class _$AppFontFamily extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
