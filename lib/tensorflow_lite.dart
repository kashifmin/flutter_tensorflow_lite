library tensorflow_lite;

import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart';

part 'src/tflite_image_classifier.dart';

part 'src/classifier.dart';

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

  Future<dynamic> run(Uint8List inputBytes, Uint8List outputBytes) async {
    return _channel.invokeMethod("Interpreter.run", [inputBytes, outputBytes]);
  }

  Future<dynamic> close() {
    return _channel.invokeMethod("Interpreter.close");
  }
}
