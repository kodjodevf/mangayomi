import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

/// One repository's listing of an extension.
class ExtensionOffer {
  const ExtensionOffer(this.repo, this.listing);

  final Repo repo;
  final Source listing;
}

/// Whether [a] and [b] are the same repository, by the index they are read
/// from, spelled as the list of repositories tells them apart. A repository
/// without one is nobody's.
bool isSameRepo(Repo? a, Repo? b) {
  final key = _indexKey(a);
  return key.isNotEmpty && key == _indexKey(b);
}

String _indexKey(Repo? repo) {
  final url = (repo?.jsonUrl ?? '').trim().toLowerCase();
  return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}

/// The update to offer for [installed] among [offers], or null when none is
/// newer than what is installed.
///
/// The repository it was installed from comes first: its newest build is
/// the update whenever it has one, however new another repository's is.
/// Only when it has none does the newest build elsewhere count, and that one
/// is installed only on the reader's say (see [isForeignUpdate]): any
/// repository can list an extension under the same id, and nothing else
/// tells a fork from an impostor. An extension with no known origin takes
/// the newest build anywhere, as it always did.
ExtensionOffer? chooseUpdate(
  Source installed,
  Iterable<ExtensionOffer> offers,
) {
  final installedVersion = installed.version ?? '';
  final newer = [
    for (final offer in offers)
      if (compareVersions(installedVersion, offer.listing.version ?? '') < 0)
        offer,
  ];
  if (newer.isEmpty) return null;
  final origin = installed.repo;
  final fromOrigin = [
    for (final offer in newer)
      if (isSameRepo(offer.repo, origin)) offer,
  ];
  return _newest(fromOrigin.isNotEmpty ? fromOrigin : newer);
}

ExtensionOffer _newest(List<ExtensionOffer> offers) => offers.reduce(
  (a, b) =>
      compareVersions(a.listing.version ?? '', b.listing.version ?? '') < 0
      ? b
      : a,
);

/// Whether [source]'s pending update comes from another repository than the
/// one it was installed from: installing it moves the extension over to that
/// repository, which the reader decides.
bool isForeignUpdate(Source source) =>
    source.updateRepo != null &&
    source.repo != null &&
    !isSameRepo(source.updateRepo, source.repo);

/// A repository as the reader knows it: its name, or its address when it
/// has none or when [other] goes by the same name, since two repositories
/// with one name must not read as one.
String repoLabel(Repo? repo, Repo? other) {
  final name = repo?.name ?? '';
  if (name.isNotEmpty && name != other?.name) return name;
  return Uri.tryParse(repo?.jsonUrl ?? '')?.host ?? name;
}

/// The repositories to ask, in order, to update or reinstall [installed]
/// from [repos] (those added for its kind).
///
/// The update's own repository when one is known, as found on the last
/// refresh; otherwise the one it was installed from. Reinstalling an
/// extension whose code is missing ([anyVersion]) may then fall back on the
/// others, as installing does. With neither known, every repository is
/// asked.
List<Repo> reposForUpdate(
  List<Repo> repos,
  Source installed, {
  required bool anyVersion,
}) {
  final target = [
    for (final known in [installed.updateRepo, installed.repo])
      ...repos.where((r) => isSameRepo(r, known)),
  ].firstOrNull;
  if (target == null) return repos;
  if (!anyVersion) return [target];
  return [target, ...repos.where((r) => !isSameRepo(r, target))];
}

/// The addresses extensions were installed from that [repos] no longer has,
/// when it matters: another repository offers such an extension an update,
/// which would otherwise count as coming from elsewhere. A repository can
/// move, and its old address then still names the new one.
Set<String> movedOriginCandidates(
  Iterable<Source> installed,
  List<Repo> repos,
  Map<int, List<ExtensionOffer>> offers,
) {
  final candidates = <String>{};
  for (final source in installed) {
    final origin = source.repo;
    final url = origin?.jsonUrl ?? '';
    if (url.isEmpty || repos.any((r) => isSameRepo(r, origin))) continue;
    if (chooseUpdate(source, offers[source.id] ?? const []) != null) {
      candidates.add(url);
    }
  }
  return candidates;
}
