import 'package:dio/dio.dart';
import 'package:food_snap/dtos/meal_dto.dart';

class ApiService {
  final Dio _dio = Dio();
  final baseURL = 'https://www.themealdb.com/api/json/v1/1';

  Future<MealDto> getMeal(String foodName) async {
    try {
      final response = await _dio.get('$baseURL/search.php?s=$foodName');
      return MealDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch meal: $e');
    }
  }
}
