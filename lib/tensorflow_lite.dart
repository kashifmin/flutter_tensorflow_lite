library tensorflow_lite;

import 'dart:async';
import 'package:flutter/services.dart';
export 'src/tflite_image_classifier.dart';
export 'src/interpreter.dart';
export 'src/classifier.dart';

class TensorflowLite {
  static const MethodChannel _channel = const MethodChannel('tensorflow_lite');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
