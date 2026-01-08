// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extensions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getExtensionsStream)
final getExtensionsStreamProvider = GetExtensionsStreamFamily._();

final class GetExtensionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Source>>,
          List<Source>,
          Stream<List<Source>>
        >
    with $FutureModifier<List<Source>>, $StreamProvider<List<Source>> {
  GetExtensionsStreamProvider._({
    required GetExtensionsStreamFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'getExtensionsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getExtensionsStreamHash();

  @override
  String toString() {
    return r'getExtensionsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Source>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Source>> create(Ref ref) {
    final argument = this.argument as ItemType;
    return getExtensionsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetExtensionsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getExtensionsStreamHash() =>
    r'18790d3d4a7f52e5e7239c8726dcd09bb51d803a';

final class GetExtensionsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Source>>, ItemType> {
  GetExtensionsStreamFamily._()
    : super(
        retry: null,
        name: r'getExtensionsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetExtensionsStreamProvider call(ItemType itemType) =>
      GetExtensionsStreamProvider._(argument: itemType, from: this);

  @override
  String toString() => r'getExtensionsStreamProvider';
}
