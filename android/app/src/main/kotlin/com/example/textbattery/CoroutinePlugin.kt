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
                // ❌ Case 1: Main thread blocked (UI freezes)
                "heavyTaskMainThreadBlocked" -> {
                    val time = measureTimeMillis {
                        val output = performHeavyTaskMainThreadBlocked()
                        result.success(output)
                    }
                    println("Time taken (MTB): $time ms")
                }

                // ⚠️ Case 2: Heavy task in background thread (UI fine, worker thread blocked)
                "heavyTask" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val time = measureTimeMillis {
                            val output = performHeavyTask()
                            withContext(Dispatchers.Main) {
                                result.success(output)
                            }
                        }
                        println("Time taken (Thread blocked): $time ms")
                    }
                }

                // ✅ Case 3: Non-blocking (UI fine, thread reusable)
                "heavyTaskNonBlocking" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val time = measureTimeMillis {
                            val output = performHeavyTaskNonBlocking()
                            withContext(Dispatchers.Main) {
                                result.success(output)
                            }
                        }
                        println("Time taken (Non-blocking): $time ms")
                    }
                }

                // 🆕 Case 4: Async computation with real result
                "computeTask" -> {
                    CoroutineScope(Dispatchers.Default).launch {
                        val resultValue = computeFibonacci(40) // CPU heavy
                        withContext(Dispatchers.Main) {
                            result.success("Fibonacci(40) = $resultValue ✅")
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    // ❌ Blocks the MAIN thread
    private fun performHeavyTaskMainThreadBlocked(): String {
        Thread.sleep(2000) // UI frozen here
        return "Heavy task result (MAIN thread blocked ❌)"
    }

    // ⚠️ Blocks a worker thread (but not UI)
    private fun performHeavyTask(): String {
        Thread.sleep(2000)
        return "Heavy task result (worker thread blocked ⚠️)"
    }

    // ✅ Non-blocking with suspend
    private suspend fun performHeavyTaskNonBlocking(): String {
        delay(2000) // frees thread while waiting
        return "Heavy task result (non-blocking ✅)"
    }

    // 🆕 CPU heavy example (doesn’t use sleep/delay)
    private fun computeFibonacci(n: Int): Long {
        return if (n <= 1) n.toLong()
        else computeFibonacci(n - 1) + computeFibonacci(n - 2)
    }
}
