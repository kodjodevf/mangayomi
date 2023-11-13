# Migration

Two types of migration to discuss:
1. Migration from Flutter Downloader
2. Migration of the persistent storage used in background_downloader

## Migration from Flutter Downloader

Key differences with Flutter Downloader:
* Every download or upload task is an object (e.g. `DownloadTask`) that defines how the task needs to be executed. The object is passed back to you when you receive status and progress updates, and is the key object in the downloader
* When you define a task, a few things are quite different:
  - You set your filepath **not** as an absolute path, but as a combination of a `baseDirectory` (an enum), a `subdirectory` (a String) and a `filename` (a String)
  - If you want the filename to be provided by the server, call `withSuggestedFilename` on the task you define, before starting the download. Alternatively, set the `filename` field of the task to `DownloadTask.suggestedFilename`, but you'll have to get the _actual_ filename from the task provided to you in status or progress updates. Task fields are final, so the task where you set the filename to `DownloadTask.suggestedFilename` will never change.
  - By default, a task only generates status updates, not progress updates. If you want both, set the task's `updates` field to `Updates.statusAndProgress`
  - You can only download to an app-specific directory (one of the `BaseDirectory` values). _After_ download completes, you can move a file to shared storage, such as the Android Downloads directory, using `moveToSharedStorage`
* Callbacks _can_ be registered, just like with Flutter Downloader, but prefer using `FileDownloader().updates.listen` and listen to updates in a more Flutter-like way. Note that you should only listen to this updates stream once, so you need to create a singleton object (or BLOC) where this happens. If you try to listen only on certain pages/screens in your app you will miss updates, leading to inconsistent state
* You can `enqueue` a task, like with Flutter Downloader, but you can also call `result = await FileDownloader().download(task)` and wait for a download to complete with a result
* Notifications work very differently. You have to configure notifications (for all tasks, a group, or one specific task) before calling `enqueue` or `download`
* By default, there is no database where task status is maintained, as you get status updates along the way. If you do want to track tasks, call `trackTasks`, and use the `database` field to query the database. There are different options for the backing database, and migration from the Flutter Downloader database is partially supported, see [below](#sqlite-persistent-storage).
* On Android, you can choose to use external storage instead of the default internal storage. This is a configuration, and can only be set at the application level, so you either use internal or external storage for all downloads and uploads. See the [configuration document](https://github.com/781flyingdutchman/background_downloader/blob/main/CONFIG.md) for important details and limitations.
* 

## Migration of the persistent storage used in background_downloader

The downloader uses persistent storage to store things like paused tasks and resume data. If you invoke `trackTasks`, then `TaskRecord` objects are also stored in this persistent storage.  The `database` object serves as an interface to this persistent storage, but you can change the type of persistent storage that 'backs' the `database`. 

The default persistent storage is a modified version of the Localstore package - a simple filesystem based storage solution that is available on all platforms.
You can use a different persistent storage by passing an alternative (that implements the `PersistentStorage` interface) as the `persistentStorage` argument to your very first call to `FileDownloader`.

### SQLite persistent storage

One such alternative, `SqlitePersistentStorage`, is included in the package (and adds a dependency to the sqflite package). This storage supports migrations from Localstore and from the Flutter Downloader SQLite database. To activate migration, pass the desired migrations to the constructor of the `SqlitePersistentStorage`, then pass the object to the `FileDownloader`:
```agsl
final sqlStorage = SqlitePersistentStorage(migrationOptions: ['local_store', 'flutter_downloader']);
FileDownloader(persistentStorage: sqlStorage);
// start using the FileDownloader
```

When used this way, the downloader will attempt to migrate data from either Localstore or Flutter Downloader to the new SQLite database, when it is created. 

Only Flutter Downloader entries that are `complete`, `failed` or `canceled` will be migrated to the background downloader, and only the fields `taskId`, `url`, `filename`, `headers` and `time_created` migrate. We attempt to reconstruct the file destination (stored in `savedDir`), provided it points to an app-specific location. If the location is external (e.g. Downloads) then the record will be skipped and not migrated. The migration is experimental, so please test thoroughly before relying on this for your existing app.

The SQLite database has an additional method `retrieveTaskRecords` that takes SQL-like `where` and `whereArgs` arguments, allowing you to query the SQLite database with TaskRecords directly. Supported columns:
* taskId
* url
* filename
* group
* metaData
* creationTime (as an integer representing _seconds_ since the epoch - not milliseconds)
* status (as an integer, the index into the `TaskStatus` enum)
* progress

You only use these fields to query - the returned value is a list of `TaskRecord` objects.  The `retrieveTaskRecords` method is _only_ available on the `SqlitePersistentStorage` object that you created and passed to the `FileDownloader`. It is not part of the `FileDownloader().database` functionality (because not all backing databases allow a query like this), and you should continue to use the `database` object wherever possible, to ensure compatibility with future upgrades.  Future changes to `SqlitePersistentStorage` may not be considered breaking changes, as they do not affect the default.

### Other storage and migration

If you already have an SQLite database that you use to keep track of things, you may want to use that to also store the downloader's data. You can extend `SqlitePersistentStorage` or implement the `PersistentStorage` interface in the class you already have.  Likewise, if you want to implement storage in Hive or some other solution, make sure to implement `PersistentStorage` and perhaps share your solution with the community!

If you want to add migration capability to your own `PersistentStorage` class, then use the `PersistentStorageMigrator` and/or extend that with functionality beyond Localstore and Flutter Downloader. The documentation shows you how this can be done.
