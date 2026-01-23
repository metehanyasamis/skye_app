package com.skye.app

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // FULL EDGE-TO-EDGE
        WindowCompat.setDecorFitsSystemWindows(window, false)

        android.util.Log.d("MainActivity", "WindowCompat.setDecorFitsSystemWindows(false) applied")
    }
}
