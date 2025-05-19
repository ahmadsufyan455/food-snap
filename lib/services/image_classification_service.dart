import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:food_snap/dtos/classification_result_dto.dart';
import 'package:food_snap/services/firebase_ml_service.dart';
import 'package:food_snap/services/isolate_inference.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final FirebaseMlService _firebaseMlService;

  ImageClassificationService(this._firebaseMlService);

  final labelsPath = 'assets/model/labels.txt';

  late final File modelFile;
  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  Future<void> _loadModel() async {
    modelFile = await _firebaseMlService.loadModel();
    final options =
        InterpreterOptions()
          ..useNnApiForAndroid = true
          ..useMetalDelegateForIOS = true;
    interpreter = Interpreter.fromFile(modelFile, options: options);
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

  Future<List<ClassificationResultDto>> inferenceObject(
    Uint8List? imageBytes,
    CameraImage? cameraImage,
  ) async {
    var isolateModel = InferenceModel(
      imageBytes,
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
