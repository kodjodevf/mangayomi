part of 'localstore.dart';

/// A [CollectionRef] object can be used for adding documents, getting
/// [DocumentRef]s, and querying for documents.
final class CollectionRef implements CollectionRefImpl {
  String _id;

  /// A string representing the path of the referenced document (relative to the
  /// root of the database).
  String get path => _path;

  String _path = '';

  DocumentRef? _delegate;

  CollectionRef? _parent;

  List<List>? _conditions;

  static final pathSeparatorRegEx = RegExp(r'[/\\]');

  /// The parent [CollectionRef] of this document.
  CollectionRef? get parent => _parent;

  CollectionRef._(this._id, [this._parent, this._delegate, this._conditions]) {
    _path = _buildPath(_parent?.path, _id, _delegate?.id);
  }
  static final _cache = <String, CollectionRef>{};

  /// Returns an instance using the default [CollectionRef].
  factory CollectionRef(
    String id, [
    CollectionRef? parent,
    DocumentRef? delegate,
    List<List>? conditions,
  ]) {
    final key = _buildPath(parent?.path, id, delegate?.id);
    final collectionRef = _cache.putIfAbsent(
        key, () => CollectionRef._(id, parent, delegate, conditions));
    collectionRef._conditions = conditions;
    return collectionRef;
  }

  static String _buildPath(String? parentPath, String path, String? docId) {
    final docPath =
        ((docId != null && parentPath != null) ? '$docId.collection' : '');
    final pathSep = p.separator;
    return '${parentPath ?? ''}$docPath$pathSep$path$pathSep';
  }

  final _utils = Utils.instance;

  @override
  Stream<Map<String, dynamic>> get stream => _utils.stream(path, _conditions);

  @override
  Future<Map<String, dynamic>?> get() async {
    return await _utils.get(path, true, _conditions);
  }

  @override
  DocumentRef doc([String? id]) {
    id ??= int.parse(
            '${Random().nextInt(1000000000)}${Random().nextInt(1000000000)}')
        .toRadixString(35)
        .substring(0, 9);
    return DocumentRef(id, this);
  }

  @override
  CollectionRef where(
    field, {
    isEqualTo,
  }) {
    final conditions = <List>[];
    void addCondition(dynamic field, String operator, dynamic value) {
      List<dynamic> condition;

      condition = <dynamic>[field, operator, value];
      conditions.add(condition);
    }

    if (isEqualTo != null) addCondition(field, '==', isEqualTo);

    _conditions = conditions;

    return this;
  }

  @override
  Future<void> delete() async {
    final docs = await _utils.get(path, true, _conditions);
    if (docs != null) {
      for (var key in docs.keys) {
        final id = key.split(pathSeparatorRegEx).last;
        DocumentRef(id, this)._data.clear();
      }
    }

    await _utils.delete(path);
  }
}
