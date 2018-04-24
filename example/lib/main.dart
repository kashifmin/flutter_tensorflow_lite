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
  List<Recognition> _recognitions;

  @override
  void initState() {
    super.initState();
    loadRecognitions();
  }

  Future<Null> loadRecognitions() async {
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
    _recognitions = await classifier.recognizeImage(image);
    setState(() {});

    await classifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "TFLite",
      theme: new ThemeData.light(),
      home: new Scaffold(
          appBar: new AppBar(title: new Text("TFLite Flutter"),),
          body: _recognitions == null ? new Center(
            child: new CircularProgressIndicator(),)
              : new ListView.builder(
            itemCount: _recognitions.length,
            itemBuilder: (BuildContext ctx, int index) {
              var item = _recognitions[index];
              return new ListTile(
                leading: new Text(item.id),
                title: new Text(item.title),
                trailing: new Text(item.confidence.toString()),
              );
            },
          )
      ),
    );
  }

}
