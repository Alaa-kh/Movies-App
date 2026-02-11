package com.example.movies


import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    WindowCompat.setDecorFitsSystemWindows(window, false)

    val controller = WindowInsetsControllerCompat(window, window.decorView)

    controller.show(WindowInsetsCompat.Type.statusBars())

    controller.hide(WindowInsetsCompat.Type.navigationBars())

    controller.systemBarsBehavior =
      WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

    window.navigationBarColor = 0xFF000000.toInt()
    controller.isAppearanceLightNavigationBars = false
  }
}

