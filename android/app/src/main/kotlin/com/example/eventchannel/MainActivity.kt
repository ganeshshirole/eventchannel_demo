package com.example.eventchannel

import android.annotation.SuppressLint
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val networkEventChannel = "platform_channel_events/count"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, networkEventChannel)
                .setStreamHandler(CounterHandler)
    }
}

object CounterHandler : EventChannel.StreamHandler {
    // Handle event in main thread.
    private val handler = Handler(Looper.getMainLooper())

    // Declare our eventSink later it will be initialized
    private var eventSink: EventChannel.EventSink? = null

    @SuppressLint("SimpleDateFormat")
    override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        var count = 0
        // every 5 second send the time
        val r: Runnable = object : Runnable {
            override fun run() {
                handler.post {
                    count ++;
                    eventSink?.success(count)
                }
                handler.postDelayed(this, 1000)
            }
        }
        handler.postDelayed(r, 1000)
    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}
