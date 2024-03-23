part of 'localstore.dart';

/// The interface that other DocumentRef must extend.
abstract class DocumentRefImpl {
  /// Gets a [CollectionRef] for the specified Localstore path.
  CollectionRef collection(String path);

  /// Sets data on the document, overwriting any existing data. If the document
  /// does not yet exist, it will be created.
  ///
  /// If [SetOptions] are provided, the data will be merged into an existing
  /// document instead of overwriting.
  Future<dynamic> set(Map<String, dynamic> data, [SetOptions? options]);

  /// Reads the document referenced by this [DocumentRef].
  Future<Map<String, dynamic>?> get();

  /// Deletes the current document from the collection.
  Future delete();
}
