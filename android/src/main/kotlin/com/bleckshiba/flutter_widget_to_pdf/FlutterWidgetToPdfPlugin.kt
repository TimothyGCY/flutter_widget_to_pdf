package com.bleckshiba.flutter_widget_to_pdf

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Date

/** FlutterWidgetToPdfPlugin */
class FlutterWidgetToPdfPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_widget_to_pdf")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val imageBytes = call.argument<ByteArray?>("imageBytes")
        if (imageBytes == null) {
            result.error("Invalid argument", "imageBytes is null", null)
            return
        }
        when (Methods.valueOf(call.method)) {
            Methods.SAVE_PDF -> {
                val filename =
                    call.argument<String?>("filename") ?: String.format("%s.pdf", Date().time)
                val pdf = PdfUtil.imageToPdf(context, imageBytes)
                try {
                    PdfUtil.savePdf(context, filename, pdf)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }
            }

            Methods.SHARE_PDF -> {
                PdfUtil.sharePdf()
                result.success(true)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
