import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:food_snap/models/classification_model.dart';
import 'package:food_snap/services/image_classification_service.dart';
import 'package:food_snap/utils/object_mapper.dart';

class ImageClassificationViewmodel extends ChangeNotifier {
  final ImageClassificationService _service;

  ImageClassificationViewmodel(this._service);

  bool _isInitialized = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClassificationModel? _classification;
  ClassificationModel? get classification => _classification;

  Future<void> runClassificationFromFile(String imagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      await initializeIfNeeded();

      final imageBytes = await File(imagePath).readAsBytes();
      final results = await _service.inferenceObject(imageBytes, null);

      final classifications =
          results.map((e) => e.toModel(_service.labels)).toList();

      if (classifications.isNotEmpty) {
        _classification = classifications[0];
      }
    } catch (e) {
      debugPrint('Error during classification: $e');
      _classification = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> runClassificationFromCamera(CameraImage camera) async {
    await initializeIfNeeded();

    final results = await _service.inferenceObject(null, camera);
    final classifications =
        results.map((e) => e.toModel(_service.labels)).toList();
    _classification = classifications[0];
    notifyListeners();
  }

  Future<void> initializeIfNeeded() async {
    if (!_isInitialized) {
      await _service.initHelper();
      _isInitialized = true;
    }
  }

  Future<void> close() async {
    await _service.close();
  }
}
