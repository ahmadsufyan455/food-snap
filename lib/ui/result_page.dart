import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/detail_page.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/widgets/app_button.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  static const String route = '/resultPage';
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<HomeViewmodel>(
                builder: (_, value, _) {
                  final imagePath = value.imagePath;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagePath.toString()),
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Consumer<ImageClassificationViewmodel>(
                builder: (_, value, _) {
                  final result = value.classification;
                  if (result != null) {
                    final label = result.label;
                    final score = result.confidenceScore;
                    return Column(
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8),
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
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'View Details',
                onPressed: () => Navigator.pushNamed(context, DetailPage.route),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
