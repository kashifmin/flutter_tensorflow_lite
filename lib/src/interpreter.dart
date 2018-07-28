import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Interpreter {
  static const MethodChannel _channel = const MethodChannel('tensorflow_lite');

  Interpreter.internal();

  static Future<Interpreter> createInstance(
      {@required String modelFilePath}) async {
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
