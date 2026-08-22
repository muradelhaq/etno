import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';

class ModuleNavBar extends StatelessWidget {
  final int currentSlide;
  final int totalSlides;
  final String? prevRoute;
  final String? nextRoute;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const ModuleNavBar({
    super.key,
    required this.currentSlide,
    this.totalSlides = 12,
    this.prevRoute,
    this.nextRoute,
    this.onNext,
    this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home button
            IconButton(
              tooltip: 'Beranda',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.sageLight.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.home_rounded, color: AppColors.primaryDark),
              onPressed: () => context.go('/'),
            ),

            // Navigation Center (Prev, Slide #, Next)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Sebelumnya',
                  style: IconButton.styleFrom(
                    backgroundColor: currentSlide > 1
                        ? AppColors.warmCream
                        : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: currentSlide > 1
                        ? AppColors.primaryDark
                        : Colors.grey.shade400,
                  ),
                  onPressed: currentSlide > 1
                      ? () {
                          if (onPrev != null) {
                            onPrev!();
                          } else if (prevRoute != null) {
                            context.go(prevRoute!);
                          }
                        }
                      : null,
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.sageLight,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.primaryGreen, width: 1),
                  ),
                  child: Text(
                    '$currentSlide / $totalSlides',
                    style: AppTextStyles.tagText.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Selanjutnya',
                  style: IconButton.styleFrom(
                    backgroundColor: currentSlide < totalSlides
                        ? AppColors.primaryGreen
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: currentSlide < totalSlides
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                  onPressed: currentSlide < totalSlides
                      ? () {
                          if (onNext != null) {
                            onNext!();
                          } else if (nextRoute != null) {
                            context.go(nextRoute!);
                          }
                        }
                      : null,
                ),
              ],
            ),

            // Menu Drawer toggle
            Builder(
              builder: (ctx) => IconButton(
                tooltip: 'Daftar Modul',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.warmCream,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.menu_book_rounded,
                    color: AppColors.warmTerracotta),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
