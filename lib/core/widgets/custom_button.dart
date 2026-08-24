import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isSecondary
        ? (backgroundColor ?? AppColors.sageLight)
        : (backgroundColor ?? AppColors.primaryGreen);
    final effectiveFg = isSecondary
        ? (textColor ?? AppColors.primaryDark)
        : (textColor ?? Colors.white);

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: effectiveFg),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.buttonText.copyWith(color: effectiveFg),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final buttonWidget = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBg,
        foregroundColor: effectiveFg,
        elevation: isSecondary ? 0 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(
          isFullWidth ? double.infinity : 64,
          height ?? 50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isSecondary
              ? const BorderSide(color: AppColors.primaryGreen, width: 1.2)
              : BorderSide.none,
        ),
      ),
      child: content,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    }

    if (height != null) {
      return SizedBox(
        height: height,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
