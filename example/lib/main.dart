import 'dart:async';

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
    Interpreter.createInstance(modelFilePath: "assets/mobilenet_v1_0.50_224.tflite");
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
