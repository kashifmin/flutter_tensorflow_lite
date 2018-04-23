import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    var interpreter = await Interpreter.createInstance(modelFilePath: "assets/mobilenet_v1_0.50_224.tflite");
    var inputBytes = new Uint8List(224 * 224);
    var outputBytes = new Uint8List(10);
    print("calling run...");
    interpreter.run(inputBytes, outputBytes);
    return null;
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
