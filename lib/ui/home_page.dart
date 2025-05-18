import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/result_page.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/widgets/app_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String route = '/homePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeViewmodel = context.read<HomeViewmodel>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: 34,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
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
              onPressed: () => homeViewmodel.pickImage(ImageSource.camera),
              icon: Icons.photo_camera_rounded,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Upload From Gallery',
              onPressed: () => homeViewmodel.pickImage(ImageSource.gallery),
              isOutline: true,
              icon: Icons.image_search_rounded,
            ),
            const SizedBox(height: 30),
            _ImagePreview(),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewmodel>(
      builder: (_, homeVM, __) {
        final imagePath = homeVM.imagePath;
        if (imagePath == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            _AnalyzeButton(imagePath: imagePath),
            const SizedBox(height: 8),
            AppButton(
              label: 'Clear',
              onPressed: () => context.read<HomeViewmodel>().resetState(),
              isOutline: true,
              paddingSize: 8,
              fontSize: 18,
              icon: Icons.clear_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  final String imagePath;
  const _AnalyzeButton({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageClassificationViewmodel>(
      builder: (_, classificationVM, __) {
        if (classificationVM.isLoading) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
          );
        }

        return AppButton(
          label: 'Analyze',
          onPressed: () async {
            await classificationVM.runClassification(imagePath);
            if (!context.mounted) return;
            Navigator.pushNamed(context, ResultPage.route);
          },
          paddingSize: 8,
          fontSize: 18,
          icon: Icons.search_rounded,
        );
      },
    );
  }
}
