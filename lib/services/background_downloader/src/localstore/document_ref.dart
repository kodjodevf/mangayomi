part of 'localstore.dart';

/// A [DocumentRef] refers to a document location in a [Localstore] database
/// and can be used to write, read, or listen to the location.
///
/// The document at the referenced location may or may not exist.
/// A [DocumentRef] can also be used to create a [CollectionRef]
/// to a subcollection.
final class DocumentRef implements DocumentRefImpl {
  String _id;

  /// This document's given ID within the collection.
  String get id => _id;

  CollectionRef? _delegate;

  DocumentRef._(this._id, [this._delegate]);

  static final _cache = <String, DocumentRef>{};

  /// Returns an instance using the default [DocumentRef].
  factory DocumentRef(String id, [CollectionRef? delegate]) {
    final key = '${delegate?.path ?? ''}$id';
    return _cache.putIfAbsent(key, () => DocumentRef._(id, delegate));
  }

  /// A string representing the path of the referenced document (relative to the
  /// root of the database).
  String get path => '${_delegate?.path}$id';

  final _utils = Utils.instance;

  final Map<String, dynamic> _data = {};

  @override
  Future<dynamic> set(Map<String, dynamic> data, [SetOptions? options]) async {
    options ??= SetOptions();
    if (options.merge) {
      final output = Map<String, dynamic>.from(data);
      Map<String, dynamic>? input = _data[id] ?? {};
      output.updateAll((key, value) {
        input![key] = value;
      });
      _data[id] = input;
    } else {
      _data[id] = data;
    }
    _utils.set(_data[id], path);
  }

  @override
  Future<Map<String, dynamic>?> get() async {
    return _data[id] ?? await _utils.get(path);
  }

  @override
  Future delete() async {
    await _utils.delete(path);
    _data.remove(id);
  }

  @override
  CollectionRef collection(String id) {
    return CollectionRef(id, _delegate, this);
  }

  @override
  String toString() {
    return _utils.toString();
  }
}
