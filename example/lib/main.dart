import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:tensorflow_lite/tensorflow_lite.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testStuff();
  }

  Future<Null> testStuff() async {
    var classifier = await TFLiteImageClassifier.createInstance(
      assets: rootBundle,
      modelPath: "assets/mobilenet_quant_v1_224.tflite",
      labelPath: "assets/labels.txt",
      inputSize: 224,
    );
    print('Classifier ready');
    var imageBytes = (await rootBundle.load("assets/cat500.png")).buffer;
    img.Image image = img.decodePng(imageBytes.asUint8List());
    image = img.copyResize(image, 224, 224);
    await classifier.recognizeImage(image);
    await classifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "TFLite",
      theme: new ThemeData.light(),
      home: new Scaffold(
        appBar: new AppBar(title: new Text("TFLite Flutter"),),
        body: new Center(child: new Text("Hello "),),
      ),
    );
  }

}
