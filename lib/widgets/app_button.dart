import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutline;
  final double fontSize;
  final double paddingSize;
  final double borderRadius;
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutline = false,
    this.fontSize = 24,
    this.paddingSize = 24,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isOutline ? AppColors.primary : Colors.white;
    final buttonColor = isOutline ? Colors.white : AppColors.primary;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        side: BorderSide(color: AppColors.primary, width: 2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(paddingSize),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 34),
            const SizedBox(width: 8),
          ],
          Text(label, style: TextStyle(color: textColor, fontSize: fontSize)),
        ],
      ),
    );
  }
}
