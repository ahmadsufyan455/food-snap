import 'package:flutter/material.dart';
import 'package:food_snap/dtos/nutrition_dto.dart';
import 'package:food_snap/models/nutrition_model.dart';
import 'package:food_snap/services/gemini_service.dart';
import 'package:food_snap/utils/object_mapper.dart';

class NutritionViewmodel extends ChangeNotifier {
  final GeminiService service;
  NutritionViewmodel(this.service);

  NutritionModel? _nutrition;
  NutritionModel? get nutrition => _nutrition;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> generateNutritionFacts({required String foodName}) async {
    _nutrition = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await service.generateNutritionFacts(foodName: foodName);
      _nutrition = NutritionDto.fromJson(response).toModel();
    } catch (e) {
      _errorMessage = 'Failed to fetch nutrition data. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
