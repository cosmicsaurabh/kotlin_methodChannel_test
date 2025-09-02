package com.example.textbattery

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


object NetworkPlugin {
    private const val CHANNEL = "samples.flutter.dev/network"
    private var applicationContext: Context? = null

    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        applicationContext = context.applicationContext // Store context
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNetworkType" -> {
                    result.success(getNetworkType())
                }
                "getConnectivityStatus" -> {
                    result.success(getConnectivityStatus())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getNetworkType(): String {
        val connectivityManager = applicationContext?.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (connectivityManager != null) {
            val activeNetwork = connectivityManager.activeNetwork
            if (activeNetwork != null) {
                val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
                if (networkCapabilities != null) {
                    when {
                        networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> return "WiFi"
                        networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> return "Mobile"
                        else -> return "Other"
                    }
                }
            }
        }
        return "None"
    }

    private fun getConnectivityStatus(): Boolean {
        val connectivityManager = applicationContext?.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (connectivityManager != null) {
            val activeNetwork = connectivityManager.activeNetwork
            if (activeNetwork != null) {
                val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
                return networkCapabilities != null &&
                        (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET))
            }
        }
        return false
    }
}