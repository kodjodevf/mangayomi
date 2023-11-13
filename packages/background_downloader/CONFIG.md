# Configuration

The downloader can be configured by calling `FileDownloader().configure` before executing any downloads or uploads. Configurations can be set for Global, Android, iOS or Desktop separately, where only the `globalConfig` is applied to every platform, before the platform-specific configuration is applied. This can be used to 'override' the configuration for only one platform.

Configurations are platform-specific and support and behavior may change between platforms. At this moment, consider configuration experimental, and expect changes that will not be considered breaking (and will not trigger a major version increase).

A configuration can be a single config or a list of configs, and every config is a `Record` with the first element a `String` indicating what to configure (use the `Config.` variables to avoid typos), and the second element an argument (which itself can be a `Record` if more than one argument is needed).

The following configurations are supported:
* Timeouts
  - `(Config.requestTimeout, Duration? duration)` sets the requestTimeout, or if null resets to default. This is the time allowed to connect with the server
  - `(Config.resourceTimeout, Duration? duration)` sets the iOS resourceTimeout, or if null resets to default. This is the time allowed to complete the download/upload
* Checking available space
  - `(Config.checkAvailableSpace, int minMegabytes)` ensures a file download fails if less than `minMegabytes` space will be available after this download completes
  - `(Config.checkAvailableSpace, false)` or `(Config.checkAvailableSpace, Config.never)`turns off checking available space
* When to use the Android cache directory
  - `(Config.useCacheDir, String whenToUse)` with values 'never', 'always' or 'whenAble'. Default is `Config.whenAble`, which will use the cacheDir if the size of the file to download is less than half the cacheQuota given to your app buy Android. If you find that your app fails to download large files or cannot resume from pause, set this to `Config.never` and make sure to clear up the directory aligned with `BaseDirectory.applicationSupport` for stray temp files. Temp file names start with `com.bbflight.background_downloader`. Note that the use of cache or applicationSupport directories responds to the configuration `Config.useExternalStorage`: if set, the external cache and applicationSupport directories will be used
* HTTP Proxy
  - `(Config.proxy, (String address, int port))` sets the proxy to this address and port (note: address and port are contained in a record)
  - `(Config.proxy, false)` removes the proxy
* Bypassing HTTPS (TLS) certificate validation
  - `(Config.bypassTLSCertificateValidation, bool bypass)`  bypasses TLS certificate validation for HTTPS connections. This is insecure, and can not be used in release mode. It is meant to make it easier to use a local server with a self-signed certificate during development only. It is only supported on Android and Desktop. On Android, to turn the bypass off, restart your app with this configuration removed.
* Android: run task in foreground (removes 9 minute timeout and may improve chances of task surviving background). Note that for a task to run in foreground it _must_ have a `running` notification configured, otherwise it will execute normally regardless of this setting
  - `(Config.runInForeground, bool activate)` or `(Config.runInForeground, Config.always)` or `(Config.runInForeground, Config.never)` activates or de-activates foreground mode for all tasks
  - `(Config.runInForegroundIfFileLargerThan, int fileSize)` activates foreground mode for downloads/uploads that exceed this file size, expressed in MB
* Android: use external storage. Either your app runs in default (internal storage) mode, or in external storage. You cannot switch between internal and external, as the directory structure that - for example - `BaseDirectory.applicationDocuments` refers to is different in each mode
  - `(Config.useExternalStorage, String whenToUse)` with values 'never' or 'always'. Default is `Config.never`. See [here](#android-external-storage) for important details
* Localization
  - `(Config.localize, Map<String, String> translation)` localizes the words 'Cancel', 'Pause' and 'Resume' as used in notifications, presented as a map (iOS only, see docs for Android notifications)

On Android and iOS, most configurations are stored in native 'shared preferences' to ensure that background tasks have access to the configuration. This means that configuration persists across application restarts, and this can lead to some surprising results. For example, if during testing you set a proxy and then remove that configuration line, the proxy configuration is not removed from persistent storage on your test device. You need to explicitly set `('proxy', false)` to remove the stored configuration on that device.

A configuration can be called multiple times, and affects all tasks *running* after the configuration call. Tasks enqueued _before_ a call, that run _after_ the call (e.g. because they are waiting for other downloads to complete) will run under the newly set configuration, not the one that was active when they were enqueued. On iOS, configuration of requestTimeout, resourceTimeout and proxy can only be set once, before the first task is executed

# Android external storage

Android has a complex storage model, see [here](https://developer.android.com/training/data-storage), that allows you to store App-Specific files in internal or external storage, and also offers Shared Storage.  For Shared Storage you can use `FileDownloader().moveToSharedStorage` - this does not require configuration, and won't be covered here.

For App-specific storage you can configure the downloader to use either internal storage (the default) or external storage. Unlike other configurations, you cannot switch, so you have to choose which mode your app will use.

The configuration affects the path to the directories described by the `BaseDirectory` enum. For internal storage, the paths will look like this:
* BaseDirectory.applicationDocuments -> path is /data/user/0/com.bbflight.background_downloader_example/app_flutter/google.html
* BaseDirectory.applicationSupport -> path is /data/user/0/com.bbflight.background_downloader_example/files/google.html
* BaseDirectory.applicationLibrary -> path is /data/user/0/com.bbflight.background_downloader_example/files/Library/google.html
* BaseDirectory.temporary -> path is /data/user/0/com.bbflight.background_downloader_example/cache/google.html

Despite the somewhat strange `app_flutter` subdirectory, these paths line up with the directories you will get when using the `path_provider` package.

When configuring the downloader to use external storage, those same `BaseDirectory` entries will create a path like this:
* BaseDirectory.applicationDocuments -> path is /storage/emulated/0/Android/data/com.bbflight.background_downloader_example/files/google.html
* BaseDirectory.applicationSupport -> path is /storage/emulated/0/Android/data/com.bbflight.background_downloader_example/files/Support/google.html
* BaseDirectory.applicationLibrary -> path is /storage/emulated/0/Android/data/com.bbflight.background_downloader_example/files/Library/google.html
* BaseDirectory.temporary -> path is /storage/emulated/0/Android/data/com.bbflight.background_downloader_example/cache/google.html

Note the external `files` or `cache` directory is now a base, with subdirectories for 'Support' and 'Library'. Calls to `task.filePath` will return the correct path to these external directories - they cannot easily be constructed otherwise.

Never store absolute paths to these files, as the actual location may differ. Also note that using external storage can lead to errors, as the storage may not be available at the time it is requested. Therefore, `task.filePath` may throw a `FileSystemException` if using external storage. 