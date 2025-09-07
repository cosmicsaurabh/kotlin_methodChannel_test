package com.example.textbattery
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.system.measureTimeMillis

object CoroutinePlugin {
    private const val CHANNEL = "samples.flutter.dev/compute"

    fun registerWith(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "heavyTask" -> {
                   CoroutineScope(Dispatchers.IO).launch {
                       val time = measureTimeMillis {
                           val output = performHeavyTask();
                           withContext(Dispatchers.Main){
                               result.success(output)
                           }

                       }
                       println("Time taken: $time ms")
                   }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun performHeavyTask(): String {
        Thread.sleep(2000) // Simulate expensive work
        return "Heavy task result ✅"
    }
}
