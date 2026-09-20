package com.example.dentisapp

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.dentisapp/settings"

    override fun configureFlutterEngine(
        flutterEngine: io.flutter.embedding.engine.FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "openAppSettings" -> {
                    abrirAjustesAplicacion()
                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun abrirAjustesAplicacion() {
        val intent = Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:$packageName")
        )

        startActivity(intent)
    }
}