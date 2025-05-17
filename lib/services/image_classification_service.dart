import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:logger/web.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final modelPath = 'assets/model/vision-classifier-food-v1.tflite';
  final labelsPath = 'assets/model/labels.txt';
  final logger = Logger();

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;

  Future<void> _loadModel() async {
    final options =
        InterpreterOptions()
          ..useNnApiForAndroid = true
          ..useMetalDelegateForIOS = true;
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    inputTensor = interpreter.getInputTensor(0);
    outputTensor = interpreter.getOutputTensor(0);

    logger.i(inputTensor.shape); // [1, 192, 192, 3]
    logger.i(outputTensor.shape); // [1, 2024]
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    await _loadLabels();
    await _loadModel();
  }

  static Future<List<List<List<List<num>>>>> _imagePreProcessing(
    String imagePath,
    List<int> inputShape,
  ) async {
    image_lib.Image? img;
    if (imagePath.startsWith('assets/')) {
      final byteData = await rootBundle.load(imagePath);
      final buffer = byteData.buffer.asUint8List();
      img = image_lib.decodeImage(buffer);
    } else {
      img = await image_lib.decodeImageFile(imagePath);
    }
    if (img == null) throw Exception("Failed to decode image");

    image_lib.Image imageInput = image_lib.copyResize(
      img,
      width: inputShape[1],
      height: inputShape[2],
    );

    if (Platform.isAndroid) {
      imageInput = image_lib.copyRotate(imageInput, angle: 90);
    }

    final imageMatrix = [
      List.generate(
        imageInput.height,
        (y) => List.generate(imageInput.width, (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        }),
      ),
    ];

    return imageMatrix;
  }

  Future<List<Map<String, dynamic>>> runInferenceFromImagePath(
    String imagePath, {
    int topK = 5,
  }) async {
    final input = await _imagePreProcessing(imagePath, inputTensor.shape);
    final output = List.filled(
      1 * labels.length,
      0.0,
    ).reshape([1, labels.length]);

    interpreter.run(input, output);

    final scores = output[0];
    final indexedScores = List.generate(
      scores.length,
      (i) => MapEntry(i, scores[i]),
    );
    indexedScores.sort((a, b) => b.value.compareTo(a.value));
    final topResults =
        indexedScores.take(topK).map((e) {
          return {'index': e.key, 'score': e.value / 225.0};
        }).toList();
    return topResults;
  }
}
