class FoodTable {
  final int? id;
  final String? path;
  final String? label;
  final double? confidenceScore;
  final String? calories;
  final String? carbohydrates;
  final String? fat;
  final String? fiber;
  final String? protein;

  FoodTable({
    this.id,
    this.path,
    this.label,
    this.confidenceScore,
    this.calories,
    this.carbohydrates,
    this.fat,
    this.fiber,
    this.protein,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'label': label,
      'confidenceScore': confidenceScore,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'protein': protein,
    };
  }

  factory FoodTable.fromMap(Map<String, dynamic> map) {
    return FoodTable(
      id: map['id'],
      path: map['path'],
      label: map['label'],
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
      calories: map['calories'],
      carbohydrates: map['carbohydrates'],
      fat: map['fat'],
      fiber: map['fiber'],
      protein: map['protein'],
    );
  }
}
