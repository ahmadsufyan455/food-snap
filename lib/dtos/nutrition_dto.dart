import 'dart:convert';

class NutritionDto {
  final double calories;
  final double carbohydrates;
  final double fat;
  final double fiber;
  final double protein;

  NutritionDto({
    required this.calories,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    required this.protein,
  });

  factory NutritionDto.fromMap(Map<String, dynamic> map) => NutritionDto(
      calories: (map['calories'] ?? 0).toDouble(),
      carbohydrates: (map['carbohydrates'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      fiber: (map['fiber'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
    );

  Map<String, dynamic> toMap() => {
      'calories': calories,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'protein': protein,
    };

  String toJson() => json.encode(toMap());

  factory NutritionDto.fromJson(String source) =>
      NutritionDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
