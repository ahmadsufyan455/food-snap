class FoodTable {
  final int? id;
  final String? label;
  final double? confidenceScore;
  final String? calories;
  final String? carbohydrates;
  final String? fat;
  final String? fiber;
  final String? protein;

  FoodTable({
    this.id,
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
      label: map['label'],
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
      calories: map['calories'],
      carbohydrates: map['carbohydrates'],
      fat: map['fat'],
      fiber: map['fiber'],
      protein: map['protein'],
    );
  }

  FoodTable copyWith({
    int? id,
    String? label,
    double? confidenceScore,
    String? calories,
    String? carbohydrates,
    String? fat,
    String? fiber,
    String? protein,
  }) {
    return FoodTable(
      id: id ?? this.id,
      label: label ?? this.label,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      calories: calories ?? this.calories,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      protein: protein ?? this.protein,
    );
  }
}
