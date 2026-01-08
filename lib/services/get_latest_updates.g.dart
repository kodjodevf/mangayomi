// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_latest_updates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getLatestUpdates)
final getLatestUpdatesProvider = GetLatestUpdatesFamily._();

final class GetLatestUpdatesProvider
    extends $FunctionalProvider<AsyncValue<MPages?>, MPages?, FutureOr<MPages?>>
    with $FutureModifier<MPages?>, $FutureProvider<MPages?> {
  GetLatestUpdatesProvider._({
    required GetLatestUpdatesFamily super.from,
    required ({Source source, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'getLatestUpdatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getLatestUpdatesHash();

  @override
  String toString() {
    return r'getLatestUpdatesProvider'
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
    return getLatestUpdates(ref, source: argument.source, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLatestUpdatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getLatestUpdatesHash() => r'6f99dfe1d4aa950b6852110ec23f92b5c73c413c';

final class GetLatestUpdatesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MPages?>,
          ({Source source, int page})
        > {
  GetLatestUpdatesFamily._()
    : super(
        retry: null,
        name: r'getLatestUpdatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetLatestUpdatesProvider call({required Source source, required int page}) =>
      GetLatestUpdatesProvider._(
        argument: (source: source, page: page),
        from: this,
      );

  @override
  String toString() => r'getLatestUpdatesProvider';
}
