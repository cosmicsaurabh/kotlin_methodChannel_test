package com.example.textbattery

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

object MsgPlugin {

    private const val CHANNEL = "samples.flutter.dev/basic"
    fun registerWith(flutterEngine: FlutterEngine){
        val channel = BasicMessageChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL,
            StringCodec.INSTANCE
        )

        channel.setMessageHandler { message, reply ->
            println("Native received: $message")
            reply.reply("Native says: Hi back 👋")
        }
        channel.send("Hello from Native!")

    }
}