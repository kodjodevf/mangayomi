package com.kodjodevf.mangayomi

import androidx.annotation.NonNull
import libmtorrentserver.Libmtorrentserver
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val taskQueue =
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.kodjodevf.mangayomi.libmtorrentserver",
            StandardMethodCodec.INSTANCE,
            taskQueue
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val config = call.argument<String>("config")
                    Libmtorrentserver.start(config)
                    result.success("ok")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
