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
  final int? foodId;
  const ResultPage({super.key, this.foodId});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String foodName = '';
  bool _nutritionFetched = false;

  @override
  void initState() {
    if (widget.foodId != null) {
      Future.microtask(() {
        if (mounted) {
          context.read<HomeViewmodel>().getRecentById(widget.foodId!);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Recognition Result')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImagePreview(context),
          const SizedBox(height: 24),
          _buildClassificationResult(context),
          const SizedBox(height: 24),
          _buildReferenceButton(context),
          const SizedBox(height: 8),
          if (widget.foodId == null) const _SaveResultButton(),
          const SizedBox(height: 34),
          _buildNutritionSection(context),
        ],
      ),
    ),
  );

  Widget _buildImagePreview(BuildContext context) {
    final imagePath = context.watch<HomeViewmodel>().imagePath;
    final localData = context.watch<HomeViewmodel>().selectedFood;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(localData?.path ?? imagePath ?? ''),
        fit: BoxFit.cover,
        height: 250,
      ),
    );
  }

  Widget _buildClassificationResult(BuildContext context) {
    final localData = context.watch<HomeViewmodel>().selectedFood;
    if (localData != null) {
      foodName = localData.label!;
      return _buildLabelWithScore(localData.label!, localData.confidenceScore!);
    }

    final result = context.watch<ImageClassificationViewmodel>().classification;
    if (result == null) {
      return const SizedBox.shrink();
    }

    foodName = result.label;
    if (!_nutritionFetched) {
      _nutritionFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NutritionViewmodel>().generateNutritionFacts(
          foodName: foodName,
        );
      });
    }

    return _buildLabelWithScore(result.label, result.confidenceScore);
  }

  Widget _buildLabelWithScore(String label, double score) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '${(score * 100).toStringAsFixed(2)}%',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    ],
  );

  Widget _buildReferenceButton(BuildContext context) => AppButton(
    label: 'View Reference',
    onPressed: () =>
        Navigator.pushNamed(context, ReferencePage.route, arguments: foodName),
  );

  Widget _buildNutritionSection(BuildContext context) {
    final localData = context.watch<HomeViewmodel>().selectedFood;
    if (localData != null) {
      final data = {
        'Calories': localData.calories!,
        'Carbohydrates': localData.carbohydrates!,
        'Fat': localData.fat!,
        'Fiber': localData.fiber!,
        'Protein': localData.protein!,
      };
      return _buildNutritionTable(data);
    }

    final viewModel = context.watch<NutritionViewmodel>();

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
    if (nutrition == null) {
      return const SizedBox.shrink();
    }

    final data = {
      'Calories': nutrition.calories,
      'Carbohydrates': nutrition.carbohydrates,
      'Fat': nutrition.fat,
      'Fiber': nutrition.fiber,
      'Protein': nutrition.protein,
    };
    return _buildNutritionTable(data);
  }

  Widget _buildNutritionTable(Map<String, String> data) => Column(
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
      ...data.entries.map(
        (entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(fontSize: 16, color: AppColors.primary),
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
        ),
      ),
    ],
  );
}

class _SaveResultButton extends StatelessWidget {
  const _SaveResultButton();

  @override
  Widget build(BuildContext context) => AppButton(
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

        if (context.mounted) {
          context.showSnakbar('Result saved!');
        }
      } else {
        context.showSnakbar('Classification or Nutrition not available');
      }
    },
  );
}
