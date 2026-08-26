// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MangaHomeDisplayTypeState)
final mangaHomeDisplayTypeStateProvider = MangaHomeDisplayTypeStateProvider._();

final class MangaHomeDisplayTypeStateProvider
    extends $NotifierProvider<MangaHomeDisplayTypeState, DisplayType> {
  MangaHomeDisplayTypeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mangaHomeDisplayTypeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mangaHomeDisplayTypeStateHash();

  @$internal
  @override
  MangaHomeDisplayTypeState create() => MangaHomeDisplayTypeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayType>(value),
    );
  }
}

String _$mangaHomeDisplayTypeStateHash() =>
    r'c6de89a6e7b26ee7215fc9b7ce9b153220f4e8f2';

abstract class _$MangaHomeDisplayTypeState extends $Notifier<DisplayType> {
  DisplayType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DisplayType, DisplayType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DisplayType, DisplayType>,
              DisplayType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
