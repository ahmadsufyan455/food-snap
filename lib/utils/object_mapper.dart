import 'package:food_snap/dtos/classification_result_dto.dart';
import 'package:food_snap/dtos/nutrition_dto.dart';
import 'package:food_snap/models/classification_model.dart';
import 'package:food_snap/models/nutrition_model.dart';

extension ClassificationResultToModel on ClassificationResultDto {
  ClassificationModel toModel(List<String> labels) {
    return ClassificationModel(label: labels[index], confidenceScore: score);
  }
}

extension NutritionToModel on NutritionDto {
  NutritionModel toModel() {
    return NutritionModel(
      calories: '${calories.toStringAsFixed(0)} kcal',
      carbohydrates: '${carbohydrates.toStringAsFixed(1)} g',
      fat: '${fat.toStringAsFixed(1)} g',
      fiber: '${fiber.toStringAsFixed(1)} g',
      protein: '${protein.toStringAsFixed(1)} g',
    );
  }
}
