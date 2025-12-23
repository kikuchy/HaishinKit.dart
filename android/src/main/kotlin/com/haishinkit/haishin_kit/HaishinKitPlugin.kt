package com.haishinkit.haishin_kit

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.ConcurrentHashMap

class HaishinKitPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val CHANNEL_NAME = "com.haishinkit"
    }

    lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    val uiThreadHandler = Handler(Looper.getMainLooper())
    private lateinit var channel: MethodChannel
    private var handlers = ConcurrentHashMap<Int, MethodCallHandler>()

    fun onDispose(id: Int) {
        handlers.remove(id)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val memory = call.argument<Int>("memory")
        if (memory != null) {
            val handler = handlers[memory]
            if (handler != null) {
                handler.onMethodCall(call, result)
            } else {
                result.notImplemented()
            }
            return
        }
        when (call.method) {
            "newRtmpConnection" -> {
                val handler = RtmpConnectionHandler(this)
                handlers[handler.hashCode()] = handler
                result.success(handler.hashCode())
            }

            "newRtmpStream" -> {
                val connection = call.argument<Int>("connection")
                val handler =
                    RtmpStreamHandler(this, handlers[connection] as? RtmpConnectionHandler)
                handlers[handler.hashCode()] = handler
                result.success(handler.hashCode())
            }

            "getPlatformVersion" -> {
                result.success(com.haishinkit.BuildConfig.LIBRARY_PACKAGE_NAME)
            }

            "getVideoSources" -> {
                val context = flutterPluginBinding.applicationContext
                val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
                val idList = manager.getCameraIdList()
                result.success(idList.map {
                    val characteristics = manager.getCameraCharacteristics(it)
                    val position = when (characteristics.get(CameraCharacteristics.LENS_FACING)) {
                        CameraMetadata.LENS_FACING_BACK -> "back"
                        CameraMetadata.LENS_FACING_FRONT -> "front"
                        CameraMetadata.LENS_FACING_EXTERNAL -> "unspecified"
                        else -> "unspecified"
                    }
                    mapOf("id" to it, "position" to position)
                })
            }

            "getAudioSources" -> {
                val manager =
                    flutterPluginBinding.applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                val devices = manager.getDevices(AudioManager.GET_DEVICES_INPUTS)
                result.success(devices.map {
                    mapOf(
                        "id" to it.id.toString(),
                        "name" to it.productName.toString()
                    )
                })
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
