import 'package:food_snap/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;
  GeminiService() {
    final apiKey = Env.geminiApiKey;
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          requiredProperties: [
            "calories",
            "carbohydrates",
            "fat",
            "fiber",
            "protein",
          ],
          properties: {
            "calories": Schema(SchemaType.number),
            "carbohydrates": Schema(SchemaType.number),
            "fat": Schema(SchemaType.number),
            "fiber": Schema(SchemaType.number),
            "protein": Schema(SchemaType.number),
          },
        ),
      ),
    );
  }

  Future<String> generateNutritionFacts({required String foodName}) async {
    final prompt = '''
      Given a food item, return its estimated nutrition facts per 100 grams in strict JSON format. Use these keys:

      - "calories": number (kilocalories)
      - "carbohydrates": number (grams)
      - "fat": number (grams)
      - "fiber": number (grams)
      - "protein": number (grams)

      Respond with only a valid JSON object. No extra text.

      Food: $foodName
      ''';

    final response = await model.generateContent([Content.text(prompt)]);

    return response.text!;
  }
}
