import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_lite/tensorflow_lite.dart';
import 'package:tensorflow_lite_example/classifier.dart';

class TFLiteImageClassifier extends Classifier {

  int _inputSize;
  Interpreter _interpreter;
  List<String> _labelList;

  TFLiteImageClassifier.internal(this._inputSize, this._interpreter, this._labelList);

  static Future<TFLiteImageClassifier> createInstance({
    @required AssetBundle assets,
    @required String modelPath,
    @required String labelPath,
    @required int inputSize,
  }) async {
    Interpreter interpreter = await Interpreter.createInstance(modelFilePath: modelPath);
    List<String> labels = await _loadLabels(assets, labelPath);
    return new TFLiteImageClassifier.internal(inputSize, interpreter, labels);
  }

  static Future<List<String>> _loadLabels(AssetBundle assets, String labelPath) async {
    String labels = await assets.loadString(labelPath);
//    print("Labels: $labels");
    return labels.split("\n");
  }

  @override
  void close() {
    // TODO: implement close
  }

//  @override
//  List<Recognition> recognizeImage(Image image) {
//
//  }
}