import 'package:flutter/material.dart';
import 'package:food_snap/models/meal_model.dart';
import 'package:food_snap/services/api_service.dart';
import 'package:food_snap/utils/object_mapper.dart';

class ReferenceViewmodel extends ChangeNotifier {
  final ApiService _apiService;
  ReferenceViewmodel(this._apiService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MealModel? _meal;
  MealModel? get meal => _meal;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getMeal(String foodName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final mealDto = await _apiService.getMeal(foodName);
      _meal = mealDto.toModel();
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = 'Failed to fetch meal';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
