// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_html_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getHtmlContent)
final getHtmlContentProvider = GetHtmlContentFamily._();

final class GetHtmlContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<(String, EpubNovel?)>,
          (String, EpubNovel?),
          FutureOr<(String, EpubNovel?)>
        >
    with
        $FutureModifier<(String, EpubNovel?)>,
        $FutureProvider<(String, EpubNovel?)> {
  GetHtmlContentProvider._({
    required GetHtmlContentFamily super.from,
    required Chapter super.argument,
  }) : super(
         retry: null,
         name: r'getHtmlContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getHtmlContentHash();

  @override
  String toString() {
    return r'getHtmlContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<(String, EpubNovel?)> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<(String, EpubNovel?)> create(Ref ref) {
    final argument = this.argument as Chapter;
    return getHtmlContent(ref, chapter: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHtmlContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getHtmlContentHash() => r'ef15133ac4066d556a03b42addf01be916e529bc';

final class GetHtmlContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<(String, EpubNovel?)>, Chapter> {
  GetHtmlContentFamily._()
    : super(
        retry: null,
        name: r'getHtmlContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetHtmlContentProvider call({required Chapter chapter}) =>
      GetHtmlContentProvider._(argument: chapter, from: this);

  @override
  String toString() => r'getHtmlContentProvider';
}
