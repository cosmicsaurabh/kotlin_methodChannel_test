package com.example.textbattery

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.textbattery.NetworkPlugin
import com.example.textbattery.SensorPlugin

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

       BatteryPlugin.registerWith(flutterEngine, this.applicationContext )
       NetworkPlugin.registerWith(flutterEngine, this.applicationContext )
       SensorPlugin.registerWith(flutterEngine, this.applicationContext )
        MsgPlugin.registerWith(flutterEngine)

    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
