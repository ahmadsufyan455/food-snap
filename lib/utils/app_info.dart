import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';

void showAboutDialogInfo(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: 'Food Snap',
    applicationVersion: '1.0.0',
    applicationIcon: const Icon(
      Icons.fastfood_rounded,
      size: 40,
      color: AppColors.primary,
    ),
    children: [
      const SizedBox(height: 12),
      const Text(
        'Food Snap is a food recognition app that helps identify and analyze nutrition facts of food items using your camera or gallery images.',
        style: TextStyle(color: AppColors.primary, fontSize: 18),
      ),
    ],
  );
}
