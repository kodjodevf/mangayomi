part of 'localstore.dart';

/// The interface that other Localstore must extend.
abstract class LocalstoreImpl {
  /// Gets a [CollectionRef] for the specified Localstore path.
  CollectionRef collection(String path);
}
