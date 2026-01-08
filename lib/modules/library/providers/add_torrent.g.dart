// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_torrent.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addTorrentFromUrlOrFromFile)
final addTorrentFromUrlOrFromFileProvider =
    AddTorrentFromUrlOrFromFileFamily._();

final class AddTorrentFromUrlOrFromFileProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  AddTorrentFromUrlOrFromFileProvider._({
    required AddTorrentFromUrlOrFromFileFamily super.from,
    required (Manga?, {bool init, String? url}) super.argument,
  }) : super(
         retry: null,
         name: r'addTorrentFromUrlOrFromFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addTorrentFromUrlOrFromFileHash();

  @override
  String toString() {
    return r'addTorrentFromUrlOrFromFileProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    final argument = this.argument as (Manga?, {bool init, String? url});
    return addTorrentFromUrlOrFromFile(
      ref,
      argument.$1,
      init: argument.init,
      url: argument.url,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddTorrentFromUrlOrFromFileProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addTorrentFromUrlOrFromFileHash() =>
    r'a54f90b6708b13eeb8fed098691f9a79dbab50fd';

final class AddTorrentFromUrlOrFromFileFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<dynamic>,
          (Manga?, {bool init, String? url})
        > {
  AddTorrentFromUrlOrFromFileFamily._()
    : super(
        retry: null,
        name: r'addTorrentFromUrlOrFromFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddTorrentFromUrlOrFromFileProvider call(
    Manga? mManga, {
    required bool init,
    String? url,
  }) => AddTorrentFromUrlOrFromFileProvider._(
    argument: (mManga, init: init, url: url),
    from: this,
  );

  @override
  String toString() => r'addTorrentFromUrlOrFromFileProvider';
}
