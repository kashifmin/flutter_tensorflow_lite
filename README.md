# tensorflow_lite

A Flutter plugin to access TensorFlow Lite apis.
[TensorFlow Lite](https://www.tensorflow.org/mobile/tflite/) is TensorFlow’s lightweight solution for mobile and embedded devices.

## Usage
Add `tensorflow_lite` to your [pubspec.yaml](https://flutter.io/platform-plugins/)

Copy your models to an asset dir like `assets/mobilenet_quant_v1_224.tflite`
And add it to your pubspec.yaml

`  assets:
     - assets/mobilenet_quant_v1_224.tflite
`

Import tensorflow_lite in your app

`import 'package:tensorflow_lite/tensorflow_lite.dart';`

Create a new Interpreter instance based on your tflite model file

`Interpreter model = await Interpreter.createInstance(modelFilePath: modelPath);`

Pass some bytes to the model to get the output

`dynamic result = await _interpreter.run(imageToByteList(image), new Uint8List(_labelList.length));`


Please check the example for full usage.

## Note
- Works only on Android
- Tested only on image classification

## Contributing
I am new to Flutter and I haven't worked on iOS yet.
So if you are an iOS developer, i'd be glad to receive some contribution.
Just send a PR or open up an issue!