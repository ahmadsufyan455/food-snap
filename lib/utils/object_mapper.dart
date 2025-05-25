import 'package:food_snap/dtos/classification_result_dto.dart';
import 'package:food_snap/dtos/meal_dto.dart';
import 'package:food_snap/dtos/nutrition_dto.dart';
import 'package:food_snap/models/classification_model.dart';
import 'package:food_snap/models/meal_model.dart';
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

extension MealToModel on MealDto {
  MealModel? toModel() {
    if (meals != null) {
      return MealModel(
        name: meals?.first.strMeal ?? '',
        image: meals?.first.strMealThumb ?? '',
        instructions: meals?.first.strInstructions ?? '',
        ingredients: [
          meals?.first.strIngredient1 ?? '',
          meals?.first.strIngredient2 ?? '',
          meals?.first.strIngredient3 ?? '',
          meals?.first.strIngredient4 ?? '',
          meals?.first.strIngredient5 ?? '',
          meals?.first.strIngredient6 ?? '',
          meals?.first.strIngredient7 ?? '',
          meals?.first.strIngredient8 ?? '',
          meals?.first.strIngredient9 ?? '',
          meals?.first.strIngredient10 ?? '',
          meals?.first.strIngredient11 ?? '',
          meals?.first.strIngredient12 ?? '',
          meals?.first.strIngredient13 ?? '',
          meals?.first.strIngredient14 ?? '',
          meals?.first.strIngredient15 ?? '',
          meals?.first.strIngredient16 ?? '',
          meals?.first.strIngredient17 ?? '',
          meals?.first.strIngredient18 ?? '',
          meals?.first.strIngredient19 ?? '',
          meals?.first.strIngredient20 ?? '',
        ],
        measures: [
          meals?.first.strMeasure1 ?? '',
          meals?.first.strMeasure2 ?? '',
          meals?.first.strMeasure3 ?? '',
          meals?.first.strMeasure4 ?? '',
          meals?.first.strMeasure5 ?? '',
          meals?.first.strMeasure6 ?? '',
          meals?.first.strMeasure7 ?? '',
          meals?.first.strMeasure8 ?? '',
          meals?.first.strMeasure9 ?? '',
          meals?.first.strMeasure10 ?? '',
          meals?.first.strMeasure11 ?? '',
          meals?.first.strMeasure12 ?? '',
          meals?.first.strMeasure13 ?? '',
          meals?.first.strMeasure14 ?? '',
          meals?.first.strMeasure15 ?? '',
          meals?.first.strMeasure16 ?? '',
          meals?.first.strMeasure17 ?? '',
          meals?.first.strMeasure18 ?? '',
          meals?.first.strMeasure19 ?? '',
          meals?.first.strMeasure20 ?? '',
        ],
      );
    }
    return null;
  }
}
