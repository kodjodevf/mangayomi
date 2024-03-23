part of 'localstore.dart';

/// The interface that other CollectionRef must extend.
abstract class CollectionRefImpl {
  /// Returns a `DocumentRef` with the provided id.
  ///
  /// If no [id] is provided, an auto-generated ID is used.
  ///
  /// The unique key generated is prefixed with a client-generated timestamp
  /// so that the resulting list will be chronologically-sorted.
  DocumentRef doc([String? id]);

  /// Notifies of query results at this collection.
  Stream<Map<String, dynamic>> get stream;

  /// Fetch the documents for this collection
  Future<Map<String, dynamic>?> get();

  /// Creates and returns a new [CollectionRef] with additional filter on
  /// specified [field]. [field] refers to a field in a document.
  ///
  /// `where` is not implemented
  CollectionRef where(
    field, {
    isEqualTo,
  });

  /// Delete collection
  ///
  /// All collections and documents in this collection will be deleted.
  Future<void> delete();
}
