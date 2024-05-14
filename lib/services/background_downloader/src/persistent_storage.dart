// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:mangayomi/services/background_downloader/src/base_downloader.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';
import 'localstore/localstore.dart';
import 'models.dart';
import 'task.dart';

/// Interface for the persistent storage used to back the downloader
///
/// Defines 'store', 'retrieve', 'retrieveAll' and 'remove' methods for:
/// - [TaskRecord]s, keyed by taskId
/// - paused [Task]s, keyed by taskId
/// - [ResumeData], keyed by taskId
///
/// Each of the objects has a toJson method and can be created using
/// fromJson (use .createFromJson for [Task] objects)
///
/// Also defined methods to allow migration from one database version to another
abstract interface class PersistentStorage {
  /// Store a [TaskRecord], keyed by taskId
  Future<void> storeTaskRecord(TaskRecord record);

  /// Retrieve [TaskRecord] with [taskId], or null if not found
  Future<TaskRecord?> retrieveTaskRecord(String taskId);

  /// Retrieve all [TaskRecord]
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

/// Default implementation of [PersistentStorage] using Localstore package
class LocalStorePersistentStorage implements PersistentStorage {
  final log = Logger('LocalStorePersistentStorage');
  final _db = Localstore.instance;
  final _illegalPathCharacters = RegExp(r'[\\/:*?"<>|]');

  static const taskRecordsPath = 'backgroundDownloaderTaskRecords';
  static const resumeDataPath = 'backgroundDownloaderResumeData';
  static const pausedTasksPath = 'backgroundDownloaderPausedTasks';
  static const metaDataCollection = 'backgroundDownloaderDatabase';

  /// Stores [Map<String, dynamic>] formatted [document] in [collection] keyed under [identifier]
  Future<void> store(Map<String, dynamic> document, String collection,
      String identifier) async {
    await _db.collection(collection).doc(identifier).set(document);
  }

  /// Returns [document] stored in [collection] under key [identifier]
  /// as a [Map<String, dynamic>], or null if not found
  Future<Map<String, dynamic>?> retrieve(
          String collection, String identifier) =>
      _db.collection(collection).doc(identifier).get();

  /// Returns all documents in collection as a [Map<String, dynamic>] keyed by the
  /// document identifier, with the value a [Map<String, dynamic>] representing the document
  Future<Map<String, dynamic>> retrieveAll(String collection) async {
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
  Future<void> removePausedTask(String? taskId) =>
      remove(pausedTasksPath, _safeIdOrNull(taskId));

  @override
  Future<void> removeResumeData(String? taskId) =>
      remove(resumeDataPath, _safeIdOrNull(taskId));

  @override
  Future<void> removeTaskRecord(String? taskId) =>
      remove(taskRecordsPath, _safeIdOrNull(taskId));

  @override
  Future<List<Task>> retrieveAllPausedTasks() async {
    final jsonMaps = await retrieveAll(pausedTasksPath);
    return jsonMaps.values
        .map((e) => Task.createFromJson(e))
        .toList(growable: false);
  }

  @override
  Future<List<ResumeData>> retrieveAllResumeData() async {
    final jsonMaps = await retrieveAll(resumeDataPath);
    return jsonMaps.values
        .map((e) => ResumeData.fromJson(e))
        .toList(growable: false);
  }

  @override
  Future<List<TaskRecord>> retrieveAllTaskRecords() async {
    final jsonMaps = await retrieveAll(taskRecordsPath);
    return jsonMaps.values
        .map((e) => TaskRecord.fromJson(e))
        .toList(growable: false);
  }

  @override
  Future<Task?> retrievePausedTask(String taskId) async {
    return switch (await retrieve(pausedTasksPath, _safeId(taskId))) {
      var json? => Task.createFromJson(json),
      _ => null
    };
  }

  @override
  Future<ResumeData?> retrieveResumeData(String taskId) async {
    return switch (await retrieve(resumeDataPath, _safeId(taskId))) {
      var json? => ResumeData.fromJson(json),
      _ => null
    };
  }

  @override
  Future<TaskRecord?> retrieveTaskRecord(String taskId) async {
    return switch (await retrieve(taskRecordsPath, _safeId(taskId))) {
      var json? => TaskRecord.fromJson(json),
      _ => null
    };
  }

  @override
  Future<void> storePausedTask(Task task) =>
      store(task.toJson(), pausedTasksPath, _safeId(task.taskId));

  @override
  Future<void> storeResumeData(ResumeData resumeData) =>
      store(resumeData.toJson(), resumeDataPath, _safeId(resumeData.taskId));

  @override
  Future<void> storeTaskRecord(TaskRecord record) =>
      store(record.toJson(), taskRecordsPath, _safeId(record.taskId));

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

/// Interface to migrate from one persistent storage to another
abstract interface class PersistentStorageMigrator {
  /// Migrate data from one of the [migrationOptions] to the [toStorage]
  ///
  /// If migration took place, returns the name of the migration option,
  /// otherwise returns null
  Future<String?> migrate(
      List<String> migrationOptions, PersistentStorage toStorage);
}

/// Migrates from [LocalStorePersistentStorage] to another [PersistentStorage]
class BasePersistentStorageMigrator implements PersistentStorageMigrator {
  final log = Logger('PersistentStorageMigrator');

  /// Create [BasePersistentStorageMigrator] object to migrate between persistent
  /// storage solutions
  ///
  /// [BasePersistentStorageMigrator] only migrates from:
  /// * local_store (the default implementation of the database in
  ///   background_downloader).
  ///
  /// To add other migrations, extend this class and inject it in the
  /// [PersistentStorage] class that you want to migrate to.
  ///
  /// See package background_downloader_sql for an implementation
  /// that migrates to a SQLite based [PersistentStorage], including
  /// migration from Flutter Downloader
  BasePersistentStorageMigrator();

  /// Migrate data from one of the [migrationOptions] to the [toStorage]
  ///
  /// If migration took place, returns the name of the migration option,
  /// otherwise returns null
  ///
  /// This is the public interface to use in other [PersistentStorage]
  /// solutions.
  @override
  Future<String?> migrate(
      List<String> migrationOptions, PersistentStorage toStorage) async {
    for (var persistentStorageName in migrationOptions) {
      try {
        if (await migrateFrom(persistentStorageName, toStorage)) {
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
  Future<bool> migrateFrom(
          String persistentStorageName, PersistentStorage toStorage) =>
      switch (persistentStorageName.toLowerCase().replaceAll('_', '')) {
        'localstore' => migrateFromLocalStore(toStorage),
        _ => Future.value(false)
      };

  /// Migrate from a persistent storage to our database
  ///
  /// Returns true if this migration took place
  ///
  /// This is a generic migrator that copies from one storage to another, and
  /// is used by the _migrateFrom... methods
  Future<bool> migrateFromPersistentStorage(
      PersistentStorage fromStorage, PersistentStorage toStorage) async {
    bool migratedSomething = false;
    await fromStorage.initialize();
    for (final pausedTask in await fromStorage.retrieveAllPausedTasks()) {
      await toStorage.storePausedTask(pausedTask);
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
  /// 2. Call [migrateFromPersistentStorage] to do the transfer from that
  ///    object to the new object, passed as [toStorage]
  /// 3. Remove all traces of the [PersistentStorage] object you want to migrate
  ///    from
  Future<bool> migrateFromLocalStore(PersistentStorage toStorage) async {
    final localStore = LocalStorePersistentStorage();
    if (await migrateFromPersistentStorage(localStore, toStorage)) {
      // delete all paths related to LocalStore
      final supportDir = await getApplicationSupportDirectory();
      for (String collectionPath in [
        LocalStorePersistentStorage.resumeDataPath,
        LocalStorePersistentStorage.pausedTasksPath,
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
}
