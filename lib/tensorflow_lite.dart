import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class TensorflowLite {
  static const MethodChannel _channel =
  const MethodChannel('tensorflow_lite');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class Interpreter {
  static const MethodChannel _channel =
  const MethodChannel('tensorflow_lite');

  Interpreter.internal();

  static Future<Interpreter> createInstance({
    @required String modelFilePath
  }) async {
    await _channel.invokeMethod("createInterpreterInstance", [modelFilePath]);
    return new Interpreter.internal();
  }

  Future<List<ByteData>> run(Uint8List inputBytes, Uint8List outputBytes) async {
    await _channel.invokeMethod("Interpreter.run", [inputBytes, outputBytes]);
    return null;
  }
}
