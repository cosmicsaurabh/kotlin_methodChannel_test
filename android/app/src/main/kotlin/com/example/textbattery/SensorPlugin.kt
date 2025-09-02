package com.example.textbattery

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object SensorPlugin {
    private const val METHOD_CHANNEL = "samples.flutter.dev/sensor"
    private const val EVENT_CHANNEL = "samples.flutter.dev/sensorStream"
    private var applicationContext: Context? = null
    private var sensorManager: SensorManager? = null
    private var accelerometerSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        applicationContext = context.applicationContext
        sensorManager = applicationContext?.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        accelerometerSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "getSensorList" -> {
                    val sensorList = sensorManager?.getSensorList(Sensor.TYPE_ALL)?.map { it.name }
                    result.success(sensorList)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private val sensorEventListener = object : SensorEventListener {
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

                    override fun onSensorChanged(event: SensorEvent?) {
                        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
                            val acceleration = mapOf(
                                "x" to event.values[0],
                                "y" to event.values[1],
                                "z" to event.values[2]
                            )
                            eventSink?.success(acceleration)
                        }
                    }
                }

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventSink = sink
                    accelerometerSensor?.let {
                        sensorManager?.registerListener(sensorEventListener, it, SensorManager.SENSOR_DELAY_NORMAL)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(sensorEventListener)
                    eventSink = null
                }
            }
        )
    }
}
