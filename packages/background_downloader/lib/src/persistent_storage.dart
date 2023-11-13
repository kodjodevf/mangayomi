import 'dart:async';
import 'dart:io';

import 'package:background_downloader/src/base_downloader.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';
import 'localstore/localstore.dart';
import 'models.dart';

/// Interface for the persistent storage used to back the downloader
///
/// Defines 'store', 'retrieve', 'retrieveAll' and 'remove' methods for:
/// - [TaskRecord]s, keyed by taskId
/// - paused [Task]s, keyed by taskId
/// - modified [Task]s, keyed by taskId
/// - [ResumeData], keyed by taskId
///
/// Each of the objects has a toJsonMap method and can be created using
/// fromJsonMap (use .createFromJsonMap for [Task] objects)
///
/// Also defined methods to allow migration from one database version to another
abstract interface class PersistentStorage {
  /// Store a [TaskRecord], keyed by taskId
  Future<void> storeTaskRecord(TaskRecord record);

  /// Retrieve [TaskRecord] with [taskId], or null if not found
  Future<TaskRecord?> retrieveTaskRecord(String taskId);

  /// Retrieve all modified tasks
  Future<List<TaskRecord>> retrieveAllTaskRecords();

  /// Remove [TaskRecord] with [taskId] from storage. If null, remove all
  Future<void> removeTaskRecord(String? taskId);

  /// Store a paused [task], keyed by taskId
  Future<void> storePausedTask(Task task);

  /// Retrieve paused [Task] with [taskId], or null if not found
  Future<Task?> retrievePausedTask(String taskId);

  /// Retrieve all paused [Task]
  Future<List<Task>> retrieveAllPausedTasks();

  /// Remove paused [Task] with [taskId] from storage. If null, remove all
  Future<void> removePausedTask(String? taskId);

  /// Store a modified [task], keyed by taskId
  Future<void> storeModifiedTask(Task task);

  /// Retrieve modified [Task] with [taskId], or null if not found
  Future<Task?> retrieveModifiedTask(String taskId);

  /// Retrieve all modified [Task]
  Future<List<Task>> retrieveAllModifiedTasks();

  /// Remove modified [Task] with [taskId] from storage. If null, remove all
  Future<void> removeModifiedTask(String? taskId);

  /// Store [ResumeData], keyed by its taskId
  Future<void> storeResumeData(ResumeData resumeData);

  /// Retrieve [ResumeData] with [taskId], or null if not found
  Future<ResumeData?> retrieveResumeData(String taskId);

  /// Retrieve all [ResumeData]
  Future<List<ResumeData>> retrieveAllResumeData();

  /// Remove [ResumeData] with [taskId] from storage. If null, remove all
  Future<void> removeResumeData(String? taskId);

  /// Name and version number for this type of persistent storage
  ///
  /// Used for database migration: this is the version represented by the code
  (String, int) get currentDatabaseVersion;

  /// Name and version number for database as stored
  ///
  /// Used for database migration, may be 'older' than the code version
  Future<(String, int)> get storedDatabaseVersion;

  /// Initialize the database - only called when the [BaseDownloader]
  /// is created with this object, which happens when the [FileDownloader]
  /// singleton is instantiated, OR as part of a migration away from this
  /// database type.
  ///
  /// Migrates the data from stored name and version to the current
  /// name and version, if needed
  /// This call runs async with the rest of the initialization
  Future<void> initialize();
}

typedef JsonMap = Map<String, dynamic>;

/// Default implementation of [PersistentStorage] using Localstore package
class LocalStorePersistentStorage implements PersistentStorage {
  final log = Logger('LocalStorePersistentStorage');
  final _db = Localstore.instance;
  final _illegalPathCharacters = RegExp(r'[\\/:*?"<>|]');

  static const taskRecordsPath = 'backgroundDownloaderTaskRecords';
  static const resumeDataPath = 'backgroundDownloaderResumeData';
  static const pausedTasksPath = 'backgroundDownloaderPausedTasks';
  static const modifiedTasksPath = 'backgroundDownloaderModifiedTasks';
  static const metaDataCollection = 'backgroundDownloaderDatabase';

  /// Stores [JsonMap] formatted [document] in [collection] keyed under [identifier]
  Future<void> store(
      JsonMap document, String collection, String identifier) async {
    await _db.collection(collection).doc(identifier).set(document);
  }

  /// Returns [document] stored in [collection] under key [identifier]
  /// as a [JsonMap], or null if not found
  Future<JsonMap?> retrieve(String collection, String identifier) =>
      _db.collection(collection).doc(identifier).get();

  /// Returns all documents in collection as a [JsonMap] keyed by the
  /// document identifier, with the value a [JsonMap] representing the document
  Future<JsonMap> retrieveAll(String collection) async {
    return await _db.collection(collection).get() ?? {};
  }

  /// Removes document with [identifier] from [collection]
  ///
  /// If [identifier] is null, removes all documents in the [collection]
  Future<void> remove(String collection, [String? identifier]) async {
    if (identifier == null) {
      await _db.collection(collection).delete();
    } else {
      await _db.collection(collection).doc(identifier).delete();
    }
  }

  /// Returns possibly modified id, safe for storing in the localStore
  String _safeId(String id) => id.replaceAll(_illegalPathCharacters, '_');

  /// Returns possibly modified id, safe for storing in the localStore, or null
  /// if [id] is null
  String? _safeIdOrNull(String? id) =>
      id?.replaceAll(_illegalPathCharacters, '_');

  @override
  Future<void> removeModifiedTask(String? taskId) =>
      remove(modifiedTasksPath, _safeIdOrNull(taskId));

  @override
  Future<void> removePausedTask(String? taskId) =>
      remove(pausedTasksPath, _safeIdOrNull(taskId));

  @override
  Future<void> removeResumeData(String? taskId) =>
      remove(resumeDataPath, _safeIdOrNull(taskId));

  @override
  Future<void> removeTaskRecord(String? taskId) =>
      remove(taskRecordsPath, _safeIdOrNull(taskId));

  @override
  Future<List<Task>> retrieveAllModifiedTasks() async {
    final jsonMaps = await retrieveAll(modifiedTasksPath);
    return jsonMaps.values
        .map((e) => Task.createFromJsonMap(e))
        .toList(growable: false);
  }

  @override
  Future<List<Task>> retrieveAllPausedTasks() async {
    final jsonMaps = await retrieveAll(pausedTasksPath);
    return jsonMaps.values
        .map((e) => Task.createFromJsonMap(e))
        .toList(growable: false);
  }

  @override
  Future<List<ResumeData>> retrieveAllResumeData() async {
    final jsonMaps = await retrieveAll(resumeDataPath);
    return jsonMaps.values
        .map((e) => ResumeData.fromJsonMap(e))
        .toList(growable: false);
  }

  @override
  Future<List<TaskRecord>> retrieveAllTaskRecords() async {
    final jsonMaps = await retrieveAll(taskRecordsPath);
    return jsonMaps.values
        .map((e) => TaskRecord.fromJsonMap(e))
        .toList(growable: false);
  }

  @override
  Future<Task?> retrieveModifiedTask(String taskId) async {
    return switch (await retrieve(modifiedTasksPath, _safeId(taskId))) {
      var jsonMap? => Task.createFromJsonMap(jsonMap),
      _ => null
    };
  }

  @override
  Future<Task?> retrievePausedTask(String taskId) async {
    return switch (await retrieve(pausedTasksPath, _safeId(taskId))) {
      var jsonMap? => Task.createFromJsonMap(jsonMap),
      _ => null
    };
  }

  @override
  Future<ResumeData?> retrieveResumeData(String taskId) async {
    return switch (await retrieve(resumeDataPath, _safeId(taskId))) {
      var jsonMap? => ResumeData.fromJsonMap(jsonMap),
      _ => null
    };
  }

  @override
  Future<TaskRecord?> retrieveTaskRecord(String taskId) async {
    return switch (await retrieve(taskRecordsPath, _safeId(taskId))) {
      var jsonMap? => TaskRecord.fromJsonMap(jsonMap),
      _ => null
    };
  }

  @override
  Future<void> storeModifiedTask(Task task) =>
      store(task.toJsonMap(), modifiedTasksPath, _safeId(task.taskId));

  @override
  Future<void> storePausedTask(Task task) =>
      store(task.toJsonMap(), pausedTasksPath, _safeId(task.taskId));

  @override
  Future<void> storeResumeData(ResumeData resumeData) =>
      store(resumeData.toJsonMap(), resumeDataPath, _safeId(resumeData.taskId));

  @override
  Future<void> storeTaskRecord(TaskRecord record) =>
      store(record.toJsonMap(), taskRecordsPath, _safeId(record.taskId));

  @override
  Future<(String, int)> get storedDatabaseVersion async {
    final metaData =
        await _db.collection(metaDataCollection).doc('metaData').get();
    return ('Localstore', (metaData?['version'] as num?)?.toInt() ?? 0);
  }

  @override
  (String, int) get currentDatabaseVersion => ('Localstore', 1);

  @override
  Future<void> initialize() async {
    final (currentName, currentVersion) = currentDatabaseVersion;
    final (storedName, storedVersion) = await storedDatabaseVersion;
    if (storedName != currentName) {
      log.warning('Cannot migrate from database name $storedName');
      return;
    }
    if (storedVersion == currentVersion) {
      return;
    }
    log.fine(
        'Migrating $currentName database from version $storedVersion to $currentVersion');
    switch (storedVersion) {
      case 0:
        // move files from docDir to supportDir
        final docDir = await getApplicationDocumentsDirectory();
        final supportDir = await getApplicationSupportDirectory();
        for (String path in [
          resumeDataPath,
          pausedTasksPath,
          modifiedTasksPath,
          taskRecordsPath
        ]) {
          try {
            final fromPath = join(docDir.path, path);
            if (await Directory(fromPath).exists()) {
              log.finest('Moving $path to support directory');
              final toPath = join(supportDir.path, path);
              await Directory(toPath).create(recursive: true);
              await Directory(fromPath).list().forEach((entity) {
                if (entity is File) {
                  entity.copySync(join(toPath, basename(entity.path)));
                }
              });
              await Directory(fromPath).delete(recursive: true);
            }
          } catch (e) {
            log.fine('Error migrating database for path $path: $e');
          }
        }

      default:
        log.warning('Illegal starting version: $storedVersion');
    }
    await _db
        .collection(metaDataCollection)
        .doc('metaData')
        .set({'version': currentVersion});
  }
}

/// Migrates from several possible persistent storage solutions to another
class PersistentStorageMigrator {
  final log = Logger('PersistentStorageMigrator');

  /// Create [PersistentStorageMigrator] object to migrate between persistent
  /// storage solutions
  ///
  /// Currently supported databases we can migrate from are:
  /// * local_store (the default implementation of the database in
  ///   background_downloader). Migration from local_store to
  ///   [SqlitePersistentStorage] is complete, i.e. all state is transferred.
  /// * flutter_downloader (a popular but now deprecated package for
  ///   downloading files). Migration from flutter_downloader is partial: only
  ///   tasks that were complete, failed or canceled are transferred, and
  ///   if the location of a file cannot be determined as a combination of
  ///   [BaseDirectory] and [directory] then the task's baseDirectory field
  ///   will be set to [BaseDirectory.applicationDocuments] and its
  ///   directory field will be set to the 'savedDir' field of the database
  ///   used by flutter_downloader. You will have to determine what that
  ///   directory resolves to (likely an external directory on Android)
  ///
  /// To add other migrations, extend this class and inject it in the
  /// [PersistentStorage] class that you want to migrate to, such as
  /// [SqlitePersistentStorage] or use it independently.
  PersistentStorageMigrator();

  /// Migrate data from one of the [migrationOptions] to the [toStorage]
  ///
  /// If migration took place, returns the name of the migration option,
  /// otherwise returns null
  Future<String?> migrate(
      List<String> migrationOptions, PersistentStorage toStorage) async {
    for (var persistentStorageName in migrationOptions) {
      try {
        if (await _migrateFrom(persistentStorageName, toStorage)) {
          return persistentStorageName;
        }
      } on Exception catch (e, stacktrace) {
        log.warning(
            'Error attempting to migrate from $persistentStorageName: $e\n$stacktrace');
      }
    }
    return null; // no migration
  }

  /// Attempt to migrate data from [persistentStorageName] to [toStorage]
  ///
  /// Returns true if the migration was successfully executed, false if it
  /// was not a viable migration
  ///
  /// If extending the class, add your mapping from a migration option String
  /// to a _migrateFrom... method that does your migration.
  Future<bool> _migrateFrom(
          String persistentStorageName, PersistentStorage toStorage) =>
      switch (persistentStorageName.toLowerCase().replaceAll('_', '')) {
        'localstore' => _migrateFromLocalStore(toStorage),
        'flutterdownloader' => _migrateFromFlutterDownloader(toStorage),
        _ => Future.value(false)
      };

  /// Migrate from a persistent storage to our database
  ///
  /// Returns true if this migration took place
  ///
  /// This is a generic migrator that copies from one storage to another, and
  /// is used by the _migrateFrom... methods
  Future<bool> _migrateFromPersistentStorage(
      PersistentStorage fromStorage, PersistentStorage toStorage) async {
    bool migratedSomething = false;
    await fromStorage.initialize();
    for (final pausedTask in await fromStorage.retrieveAllPausedTasks()) {
      await toStorage.storePausedTask(pausedTask);
      migratedSomething = true;
    }
    for (final modifiedTask in await fromStorage.retrieveAllModifiedTasks()) {
      await toStorage.storeModifiedTask(modifiedTask);
      migratedSomething = true;
    }
    for (final resumeData in await fromStorage.retrieveAllResumeData()) {
      await toStorage.storeResumeData(resumeData);
      migratedSomething = true;
    }
    for (final taskRecord in await fromStorage.retrieveAllTaskRecords()) {
      await toStorage.storeTaskRecord(taskRecord);
      migratedSomething = true;
    }
    return migratedSomething;
  }

  /// Attempt to migrate from [LocalStorePersistentStorage]
  ///
  /// Return true if successful. Successful migration removes the original
  /// data
  ///
  /// If extending this class, add a method like this that does the
  /// migration by:
  /// 1. Setting up the [PersistentStorage] object you want to migrate from
  /// 2. Call [_migrateFromPersistentStorage] to do the transfer from that
  ///    object to the new object, passed as [toStorage]
  /// 3. Remove all traces of the [PersistentStorage] object you want to migrate
  ///    from
  ///
  /// A second example is the [_migrateFromFlutterDownloader] method
  Future<bool> _migrateFromLocalStore(PersistentStorage toStorage) async {
    final localStore = LocalStorePersistentStorage();
    if (await _migrateFromPersistentStorage(localStore, toStorage)) {
      // delete all paths related to LocalStore
      final supportDir = await getApplicationSupportDirectory();
      for (String collectionPath in [
        LocalStorePersistentStorage.resumeDataPath,
        LocalStorePersistentStorage.pausedTasksPath,
        LocalStorePersistentStorage.modifiedTasksPath,
        LocalStorePersistentStorage.taskRecordsPath,
        LocalStorePersistentStorage.metaDataCollection
      ]) {
        try {
          final path = join(supportDir.path, collectionPath);
          if (await Directory(path).exists()) {
            log.finest('Removing directory $path for LocalStore');
            await Directory(path).delete(recursive: true);
          }
        } catch (e) {
          log.fine('Error deleting collection path $collectionPath: $e');
        }
      }
      return true; // we migrated a database
    }
    return false; // we did not migrate a database
  }

  /// Attempt to migrate from FlutterDownloader
  ///
  /// Return true if successful. Successful migration removes the original
  /// data
  Future<bool> _migrateFromFlutterDownloader(
      PersistentStorage toStorage) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return false;
    }

    return false; // we did not migrate a database
  }
}
