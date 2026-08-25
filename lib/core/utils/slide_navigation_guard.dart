import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/services/local_storage_service.dart';
import '../constants/app_colors.dart';

bool navigateToNextSlide(
  BuildContext context,
  WidgetRef ref, {
  required int currentSlide,
  required String route,
}) {
  final progress = ref.read(userProgressProvider);
  if (!progress.canProceedFromSlide(currentSlide)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(progress.requirementForSlide(currentSlide)),
        backgroundColor: AppColors.warmTerracotta,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }
  context.go(route);
  return true;
}
