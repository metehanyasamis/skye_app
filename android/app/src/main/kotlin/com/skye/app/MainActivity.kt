package com.skye.app

import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.skye.app/mapbox_config"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method == "getMapboxAccessToken") {
                val token = try {
                    val ai = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
                    ai.metaData?.getString("com.mapbox.token") ?: ""
                } catch (e: Exception) {
                    ""
                }
                result.success(token)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // FULL EDGE-TO-EDGE
        WindowCompat.setDecorFitsSystemWindows(window, false)

        android.util.Log.d("MainActivity", "WindowCompat.setDecorFitsSystemWindows(false) applied")
    }
}
