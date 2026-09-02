// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_buttons_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getCustomButtonsStream)
final getCustomButtonsStreamProvider = GetCustomButtonsStreamProvider._();

final class GetCustomButtonsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CustomButton>>,
          List<CustomButton>,
          Stream<List<CustomButton>>
        >
    with
        $FutureModifier<List<CustomButton>>,
        $StreamProvider<List<CustomButton>> {
  GetCustomButtonsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCustomButtonsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCustomButtonsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<CustomButton>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CustomButton>> create(Ref ref) {
    return getCustomButtonsStream(ref);
  }
}

String _$getCustomButtonsStreamHash() =>
    r'bbebe5abc571aa9e046582aa34aafafaccb99eca';
