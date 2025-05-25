import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/models/food_table.dart';
import 'package:food_snap/theme/app_colors.dart';

class RecentItem extends StatelessWidget {
  final FoodTable data;
  final VoidCallback onTap;
  const RecentItem({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: FileImage(File(data.path!)),
            ),
            const SizedBox(width: 24),
            Text(
              data.label!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
}
