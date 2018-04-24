# tensorflow_lite

[![pub package](https://img.shields.io/pub/v/tensorflow_lite.svg)](https://pub.dartlang.org/packages/tensorflow_lite)


A Flutter plugin to access TensorFlow Lite apis.
[TensorFlow Lite](https://www.tensorflow.org/mobile/tflite/) is TensorFlow’s lightweight solution for mobile and embedded devices.
With TensorFlow Lite you can deploy machine learning models on phones in your Android/iOS app.

## Usage
Add `tensorflow_lite` to your [pubspec.yaml](https://flutter.io/platform-plugins/)

Copy your models to an asset dir like `assets/mobilenet_quant_v1_224.tflite`
And add it to your pubspec.yaml

```yaml
   assets:
     - assets/mobilenet_quant_v1_224.tflite
```

Import tensorflow_lite in your app

```dart
import 'package:tensorflow_lite/tensorflow_lite.dart';
```

Create a new Interpreter instance based on your tflite model file

```dart
Interpreter model = await Interpreter.createInstance(modelFilePath: modelPath);
```

Pass some bytes to the model to get the output

```dart
dynamic result = await _interpreter.run(imageToByteList(image), new Uint8List(_labelList.length));
```

# Image Classification example

`tensorflow_lite` also includes a wrapper for image classification models which can be easily loaded
without much of boilerplate code.

```dart
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
```

Please check the example for full usage.

## Note
- Works only on Android
- Tested only on image classification

## Contributing
I am new to Flutter and I haven't worked on iOS yet.
So if you are an iOS developer, i'd be glad to receive some contribution.
Just send a PR or open up an issue!
