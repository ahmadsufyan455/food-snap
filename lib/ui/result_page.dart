import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/detail_page.dart';
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
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              label: 'View Details',
              onPressed: () => Navigator.pushNamed(context, DetailPage.route),
            ),
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
              children:
                  data.entries.map((entry) {
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
