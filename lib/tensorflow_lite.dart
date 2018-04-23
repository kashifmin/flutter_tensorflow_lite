import 'dart:async';

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

  Future<List<ByteData>> run(ByteData inputBytes) async {
    await _channel.invokeMethod("Interpreter.run", [inputBytes]);
    return null;
  }
}

class TFLiteImageClassifier {
  static const MethodChannel _channel =
  const MethodChannel('tensorflow_lite');

  static Future<TFLiteImageClassifier> createInstance({
    @required String modelPath,
    @required String labelPath,
    @required int inputSize,
  }) async {
    return await _channel.invokeMethod("createTFLiteInstance", [modelPath, labelPath, inputSize])
    .catchError((error) {
      throw new Exception("Error: Could not load native instance of TFLiteImageClassifier");
    }).then((dynamic res) => new TFLiteImageClassifier());

  }

  Future<List<Recognition>> recognizeImage() async {
    dynamic response = await _channel.invokeMethod("recognizeImage");
    return response;
  }
}

class Recognition {
  String _id;
  String _title;
  String _confidence;

  String get id => _id;

  String get title => _title;

  String get confidence => _confidence;

  @override
  String toString() {
    return 'Recognition{_id: $_id, _title: $_title, _confidence: $_confidence}';
  }


}
