// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_to_cbz.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(convertToCBZ)
final convertToCBZProvider = ConvertToCBZFamily._();

final class ConvertToCBZProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  ConvertToCBZProvider._({
    required ConvertToCBZFamily super.from,
    required (String, String, String, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'convertToCBZProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$convertToCBZHash();

  @override
  String toString() {
    return r'convertToCBZProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as (String, String, String, List<String>);
    return convertToCBZ(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConvertToCBZProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$convertToCBZHash() => r'56f4320034ec2420c8c2c2b22a2522721181ab54';

final class ConvertToCBZFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<String>>,
          (String, String, String, List<String>)
        > {
  ConvertToCBZFamily._()
    : super(
        retry: null,
        name: r'convertToCBZProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConvertToCBZProvider call(
    String chapterDir,
    String mangaDir,
    String chapterName,
    List<String> pageList,
  ) => ConvertToCBZProvider._(
    argument: (chapterDir, mangaDir, chapterName, pageList),
    from: this,
  );

  @override
  String toString() => r'convertToCBZProvider';
}
