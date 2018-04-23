package me.kashifminhaj.tensorflowlite

import android.content.res.AssetManager
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.tensorflow.lite.Interpreter
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel

class TensorflowLitePlugin(): MethodCallHandler {


  init {
    android.util.Log.d("TFLite", "sup")
  }
  companion object {
    val TAG = "TensorflowLitePlugin"
    var assetManager: AssetManager? = null
    var registrar: Registrar? = null

    var interpreter: Interpreter? = null
    @JvmStatic
    fun registerWith(reg: Registrar): Unit {
      val channel = MethodChannel(reg.messenger(), "tensorflow_lite")
      channel.setMethodCallHandler(TensorflowLitePlugin())
      assetManager = reg.context().getAssets()
      registrar = reg
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    Log.d(TAG, "called : ${call.method.toString()}")
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "createTFLiteInstance" -> createTFLiteInstance(call.arguments, result)
      "createInterpreterInstance" -> createInterpreterInstance(call.arguments, result)
      "Interpreter.run" -> runInterpreter(call.arguments, result)
      "Interpreter.close" -> closeInterpreter(result)
      else -> result.notImplemented()
    }
  }

  fun createTFLiteInstance(args: Any, result: Result) {
    Log.d(TAG, "createTFLiteInstance called with args ${args.toString()}")
  }

  fun createInterpreterInstance(args: Any, result: Result) {
    val modelAssetFile: String = (args as List<Any>)[0].toString()
    val assetkey = registrar?.lookupKeyForAsset(modelAssetFile)
    Log.d(TAG, "Asset key is $assetkey")
    interpreter = Interpreter(loadModelFile(assetManager!!, assetkey!!))
    Log.d(TAG, "Interpreter instance ready")
    result.success("Interpreter instance ready")
    Log.d(TAG, "Result success")
  }

  fun runInterpreter(args: Any, result: Result) {
    val argList = args as List<Any>
    val inputBytes = args[0] as ByteArray
    val outputBytes = args[1] as ByteArray

    val inputBuffer = ByteBuffer.allocateDirect(inputBytes.size).put(inputBytes)
    inputBuffer.order(ByteOrder.nativeOrder())
    interpreter?.run(inputBuffer, arrayOf(outputBytes))
    Log.d(TAG, "inference ran")
    result.success(outputBytes)
  }

  fun closeInterpreter(result: Result) {
    interpreter?.close()
    interpreter = null
    result.success("Interpreter session closed.")
  }

  @Throws(IOException::class)
  private fun loadModelFile(assetManager: AssetManager, modelPath: String): MappedByteBuffer {
    val fileDescriptor = assetManager.openFd(modelPath)
    val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
    val fileChannel = inputStream.channel
    val startOffset = fileDescriptor.startOffset
    val declaredLength = fileDescriptor.declaredLength
    return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
  }
}
