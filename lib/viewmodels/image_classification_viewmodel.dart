import 'package:flutter/foundation.dart';
import 'package:food_snap/services/image_classification_service.dart';

class ImageClassificationViewmodel extends ChangeNotifier {
  final ImageClassificationService _service;

  ImageClassificationViewmodel(this._service) {
    _service.initHelper();
  }

  List<Map<String, dynamic>> _classification = [];
  List<Map<String, dynamic>> get classification => _classification;

  Future<void> runClassification(String imagePath) async {
    _classification = await _service.runInferenceFromImagePath(imagePath);
    notifyListeners();
  }
}
