// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_popular.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getPopular)
final getPopularProvider = GetPopularFamily._();

final class GetPopularProvider
    extends $FunctionalProvider<AsyncValue<MPages?>, MPages?, FutureOr<MPages?>>
    with $FutureModifier<MPages?>, $FutureProvider<MPages?> {
  GetPopularProvider._({
    required GetPopularFamily super.from,
    required ({Source source, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'getPopularProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getPopularHash();

  @override
  String toString() {
    return r'getPopularProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MPages?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MPages?> create(Ref ref) {
    final argument = this.argument as ({Source source, int page});
    return getPopular(ref, source: argument.source, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPopularProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getPopularHash() => r'7e1139bc0f6a3a495fa0dc59d450bc7fd70f36a8';

final class GetPopularFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MPages?>,
          ({Source source, int page})
        > {
  GetPopularFamily._()
    : super(
        retry: null,
        name: r'getPopularProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetPopularProvider call({required Source source, required int page}) =>
      GetPopularProvider._(argument: (source: source, page: page), from: this);

  @override
  String toString() => r'getPopularProvider';
}
