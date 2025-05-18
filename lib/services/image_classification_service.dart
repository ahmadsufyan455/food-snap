import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:food_snap/dtos/classification_result_dto.dart';
import 'package:food_snap/services/isolate_inference.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final modelPath = 'assets/model/vision-classifier-food-v1.tflite';
  final labelsPath = 'assets/model/labels.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  Future<void> _loadModel() async {
    final options =
        InterpreterOptions()
          ..useNnApiForAndroid = true
          ..useMetalDelegateForIOS = true;
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    inputTensor = interpreter.getInputTensor(0);
    outputTensor = interpreter.getOutputTensor(0);
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    await _loadModel();
    await _loadLabels();

    isolateInference = IsolateInference();
    await isolateInference.start();
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

  Future<List<ClassificationResultDto>> runInferenceFromImagePath(
    String imagePath, {
    int topK = 1,
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
          return ClassificationResultDto(index: e.key, score: e.value / 255.0);
        }).toList();
    return topResults;
  }

  Future<List<ClassificationResultDto>> inferenceCameraFrame(
    CameraImage cameraImage,
  ) async {
    var isolateModel = InferenceModel(
      cameraImage,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      isolateModel..responsePort = responsePort.sendPort,
    );

    final resultMap = await responsePort.first as Map<String, double>;
    final results =
        resultMap.entries.map((entry) {
          final index = labels.indexOf(entry.key);
          return ClassificationResultDto(index: index, score: entry.value);
        }).toList();

    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }

  Future<void> close() async {
    await isolateInference.close();
  }
}
