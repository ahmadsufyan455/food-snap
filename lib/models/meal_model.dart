class MealModel {
  final String name;
  final String image;
  final String instructions;
  final List<String> ingredients;
  final List<String> measures;

  MealModel({
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    required this.measures,
  });
}
