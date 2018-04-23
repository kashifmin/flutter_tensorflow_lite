import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_lite/tensorflow_lite.dart';
import 'package:tensorflow_lite_example/classifier.dart';

class TFLiteImageClassifier extends Classifier {

  static double thresholdConfidence = 0.3;

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
    print("Labels length: ${labels.length}");
    return new TFLiteImageClassifier.internal(inputSize, interpreter, labels);
  }

  static Future<List<String>> _loadLabels(AssetBundle assets, String labelPath) async {
    String labels = await assets.loadString(labelPath);

    return labels.trim().split("\n");
  }

  @override
  void close() {
    // TODO: implement close
    _interpreter.close();
    _interpreter = null;
  }

  @override
  Future<List<Recognition>>  recognizeImage(Image image) async {
    
    dynamic result = await _interpreter.run(imageToByteList(image), new Uint8List(_labelList.length));
    print("Output type: " + result.runtimeType.toString());
    Uint8List output = result as Uint8List;
    print("Output length ${output.length}");

    for(var i in output){
      var confidence = (i & 0xff) / 255.0;
      print("Output test ${confidence}");
    }
    var outs = processOutputs(output);
    print(outs.toString());
    return null;
  }

  Uint8List imageToByteList(Image image) {
    var convertedBytes = new Uint8List(1 * _inputSize * _inputSize * 3);
    var buffer = new ByteData.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for(var i=0; i<_inputSize; i++) {
      for(var j=0; j<_inputSize; j++) {
        var pixel = image.getPixel(i, j);
        buffer.setUint8(pixelIndex++, (pixel >> 16) & 0xFF);
        buffer.setUint8(pixelIndex++, (pixel >> 8) & 0xFF);
        buffer.setUint8(pixelIndex++, (pixel) & 0xFF);
      }
    }
    return convertedBytes;
  }

  List<Recognition> processOutputs(Uint8List output) {
    PriorityQueue<Recognition> pq = new PriorityQueue((Recognition r1, Recognition r2) {
      return r1.confidence.compareTo(r2.confidence);
    });

    for(int i=0; i<output.length; i++) {

      var confidence = (output[i] & 0xff) / 255.0;
      if(confidence >= thresholdConfidence) {
        pq.add(new Recognition(i.toString(), _labelList[i], confidence));
      }
    }

    return pq.toList();

  }
}