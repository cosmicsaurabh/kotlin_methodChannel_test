package com.example.textbattery // Make sure this matches your package name

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object BatteryPlugin {
    private const val CHANNEL = "samples.flutter.dev/battery"
    private var applicationContext: Context? = null

    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        applicationContext = context.applicationContext // Store context
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (applicationContext == null) {
                result.error("UNAVAILABLE", "Battery context not available.", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "getBatteryStatus" -> {
                    val batteryStatus = getBatteryStatus()
                    if (batteryStatus != -1) {
                        result.success(batteryStatus)
                    } else {
                        result.error("UNAVAILABLE", "Battery status not available.", null)
                    }
                }
                "getBatteryHealth" -> {
                    val batteryHealth = getBatteryHealth()
                    if (batteryHealth != -1) {
                        result.success(batteryHealth)
                    } else {
                        result.error("UNAVAILABLE", "Battery health not available.", null)
                    }
                }
                "isCharging" -> {
                    result.success(isCharging())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryManager(): BatteryManager? {
        return applicationContext?.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getBatteryManager()
        return batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) ?: -1
    }

    private fun getBatteryStatus(): Int {
        val batteryManager = getBatteryManager()
        // BATTERY_PROPERTY_STATUS can return unknown, charging, discharging, not charging, full
        // You might want to map these to more specific enums or values for Flutter
        return batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS) ?: -1
    }

    private fun getBatteryHealth(): Int {
        val batteryManager = getBatteryManager()
        // BATTERY_PROPERTY_HEALTH can return various health states
        return batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) ?: -1
    }

    private fun isCharging(): Boolean {
        val batteryManager = getBatteryManager()
        if (batteryManager != null) {
            val status = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
            return status == BatteryManager.BATTERY_STATUS_CHARGING ||
                    status == BatteryManager.BATTERY_STATUS_FULL // Often considered charging if full and plugged in
        }
        // Fallback for older Android versions if BATTERY_PROPERTY_STATUS is not available (though unlikely for modern usage)
        // Or if batteryManager is null for some reason
        val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatusIntent = applicationContext?.registerReceiver(null, intentFilter)
        val status = batteryStatusIntent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        return status == BatteryManager.BATTERY_STATUS_CHARGING ||
                status == BatteryManager.BATTERY_STATUS_FULL
    }
}
