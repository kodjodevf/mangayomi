// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_font_family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides both the raw and resolved font family.
///
/// Returns a tuple `(raw, resolved)`:
/// - `raw`      -> the original font name stored in Isar (e.g. "Roboto")
/// - `resolved` -> the actual font family used by Flutter/GoogleFonts (e.g. "Roboto-Regular")

@ProviderFor(AppFontFamily)
final appFontFamilyProvider = AppFontFamilyProvider._();

/// Provides both the raw and resolved font family.
///
/// Returns a tuple `(raw, resolved)`:
/// - `raw`      -> the original font name stored in Isar (e.g. "Roboto")
/// - `resolved` -> the actual font family used by Flutter/GoogleFonts (e.g. "Roboto-Regular")
final class AppFontFamilyProvider
    extends $NotifierProvider<AppFontFamily, (String?, String?)> {
  /// Provides both the raw and resolved font family.
  ///
  /// Returns a tuple `(raw, resolved)`:
  /// - `raw`      -> the original font name stored in Isar (e.g. "Roboto")
  /// - `resolved` -> the actual font family used by Flutter/GoogleFonts (e.g. "Roboto-Regular")
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
  Override overrideWithValue((String?, String?) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(String?, String?)>(value),
    );
  }
}

String _$appFontFamilyHash() => r'a0dd3e81d43047e1f8b9d126c59ebbb0bdd4f727';

/// Provides both the raw and resolved font family.
///
/// Returns a tuple `(raw, resolved)`:
/// - `raw`      -> the original font name stored in Isar (e.g. "Roboto")
/// - `resolved` -> the actual font family used by Flutter/GoogleFonts (e.g. "Roboto-Regular")

abstract class _$AppFontFamily extends $Notifier<(String?, String?)> {
  (String?, String?) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<(String?, String?), (String?, String?)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(String?, String?), (String?, String?)>,
              (String?, String?),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
