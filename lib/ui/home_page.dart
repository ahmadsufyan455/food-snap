import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/result_page.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/widgets/app_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String route = '/homePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: 34,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FOOD RECOGNITION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              AppButton(
                label: 'Take Photo',
                onPressed: () {},
                icon: Icons.photo_camera_rounded,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Upload From Gallery',
                onPressed: () => context.read<HomeViewmodel>().openGallery(),
                isOutline: true,
                icon: Icons.image_search_rounded,
              ),
              const SizedBox(height: 30),
              _buildImagePreview(),
              // Text(
              //   'Recent',
              //   style: TextStyle(
              //     color: AppColors.primary,
              //     fontSize: 24,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Consumer<HomeViewmodel>(
      builder: (_, value, _) {
        imagePath = value.imagePath;
        return imagePath != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath.toString()),
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
                SizedBox(height: 16),
                Consumer<ImageClassificationViewmodel>(
                  builder: (context, value, _) {
                    if (value.isLoading) {
                      return Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: const CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    }
                    return AppButton(
                      label: 'Analyze',
                      onPressed: () {
                        context
                            .read<ImageClassificationViewmodel>()
                            .runClassification(imagePath!)
                            .then((_) {
                              if (!context.mounted) return;
                              Navigator.pushNamed(context, ResultPage.route);
                            });
                      },
                      paddingSize: 8,
                      fontSize: 18,
                      icon: Icons.search_rounded,
                    );
                  },
                ),
                SizedBox(height: 8),
                AppButton(
                  label: 'Clear',
                  onPressed: () => context.read<HomeViewmodel>().resetState(),
                  isOutline: true,
                  paddingSize: 8,
                  fontSize: 18,
                  icon: Icons.clear_rounded,
                ),
              ],
            )
            : SizedBox.shrink();
      },
    );
  }
}
