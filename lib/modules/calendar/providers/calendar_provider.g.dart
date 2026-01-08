// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getCalendarStream)
final getCalendarStreamProvider = GetCalendarStreamFamily._();

final class GetCalendarStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manga>>,
          List<Manga>,
          Stream<List<Manga>>
        >
    with $FutureModifier<List<Manga>>, $StreamProvider<List<Manga>> {
  GetCalendarStreamProvider._({
    required GetCalendarStreamFamily super.from,
    required ItemType? super.argument,
  }) : super(
         retry: null,
         name: r'getCalendarStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getCalendarStreamHash();

  @override
  String toString() {
    return r'getCalendarStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Manga>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Manga>> create(Ref ref) {
    final argument = this.argument as ItemType?;
    return getCalendarStream(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCalendarStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getCalendarStreamHash() => r'850d81742f8ac5ce88175732c0edf57a7a9295d4';

final class GetCalendarStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Manga>>, ItemType?> {
  GetCalendarStreamFamily._()
    : super(
        retry: null,
        name: r'getCalendarStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetCalendarStreamProvider call({ItemType? itemType}) =>
      GetCalendarStreamProvider._(argument: itemType, from: this);

  @override
  String toString() => r'getCalendarStreamProvider';
}
