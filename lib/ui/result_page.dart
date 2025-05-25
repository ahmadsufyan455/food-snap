import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/models/food_table.dart';
import 'package:food_snap/services/database_service.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/reference_page.dart';
import 'package:food_snap/utils/app_ext.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/viewmodels/nutrition_viewmodel.dart';
import 'package:food_snap/widgets/app_button.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  static const String route = '/resultPage';
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String foodName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recognition Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePreview(),
            const SizedBox(height: 24),
            _buildClassificationResult(),
            const SizedBox(height: 24),
            AppButton(
              label: 'View Reference',
              onPressed: () => Navigator.pushNamed(
                context,
                ReferencePage.route,
                arguments: {'foodName': foodName},
              ),
            ),
            const SizedBox(height: 8),
            _SaveResultButton(),
            const SizedBox(height: 34),
            _buildNutritionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Consumer<HomeViewmodel>(
      builder: (_, viewModel, __) {
        final imagePath = viewModel.imagePath;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath ?? ''),
            fit: BoxFit.cover,
            height: 250,
          ),
        );
      },
    );
  }

  Widget _buildClassificationResult() {
    return Consumer<ImageClassificationViewmodel>(
      builder: (_, viewModel, __) {
        final result = viewModel.classification;
        if (result == null) return const SizedBox.shrink();
        foodName = result.label;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NutritionViewmodel>().generateNutritionFacts(
            foodName: result.label,
          );
        });

        return Column(
          children: [
            Text(
              result.label,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(result.confidenceScore * 100).toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Facts / 100 g',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Consumer<NutritionViewmodel>(
          builder: (_, viewModel, __) {
            if (viewModel.isLoading) {
              return Center(
                child: const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (viewModel.errorMessage != null) {
              return Text(
                viewModel.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            final nutrition = viewModel.nutrition;
            if (nutrition == null) return const SizedBox.shrink();

            final data = {
              'Calories': nutrition.calories,
              'Carbohydrates': nutrition.carbohydrates,
              'Fat': nutrition.fat,
              'Fiber': nutrition.fiber,
              'Protein': nutrition.protein,
            };

            return Column(
              children: data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SaveResultButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Save Result',
      isOutline: true,
      onPressed: () async {
        final classification = context
            .read<ImageClassificationViewmodel>()
            .classification;
        final nutrition = context.read<NutritionViewmodel>().nutrition;
        final path = context.read<HomeViewmodel>().imagePath;

        if (classification != null && nutrition != null && path != null) {
          final food = FoodTable(
            path: path,
            label: classification.label,
            confidenceScore: classification.confidenceScore,
            calories: nutrition.calories,
            carbohydrates: nutrition.carbohydrates,
            fat: nutrition.fat,
            fiber: nutrition.fiber,
            protein: nutrition.protein,
          );

          await DatabaseService().insertFood(food);

          if (!context.mounted) return;
          context.showSnakbar('Result saved!');
        } else {
          context.showSnakbar('Classification or Nutrition not available');
        }
      },
    );
  }
}
