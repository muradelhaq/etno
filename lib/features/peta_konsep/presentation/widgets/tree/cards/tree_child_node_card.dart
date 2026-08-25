import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../dialogs/concept_tree_detail_dialog.dart';
import '../models/tree_concept_node.dart';

class TreeChildNodeCard extends StatelessWidget {
  final TreeChild child;
  final double width;
  final int totalSiblings;
  final bool isLandscape;

  const TreeChildNodeCard({
    super.key,
    required this.child,
    required this.width,
    required this.totalSiblings,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ConceptTreeDialogs.showDetailDialog(
        context: context,
        title: child.title,
        category: 'Olahan Kuliner Nusantara',
        microbe: child.parentProduct,
        imageAsset: child.imageAsset,
        description: child.description,
        route: child.route,
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(isLandscape ? 8 : 5),
          border: Border.all(
            color: const Color(0xFF2D5A3C).withValues(alpha: 0.35),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(isLandscape ? 2.5 : 1.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isLandscape ? 5 : 3),
              child: AppImage(
                child.imageAsset,
                height: isLandscape ? 36 : (totalSiblings == 2 ? 23 : 25),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: isLandscape ? 36 : 23,
                  color: AppColors.warmCream,
                  child: const Center(
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: AppColors.warmTerracotta,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              child.title,
              style: TextStyle(
                color: const Color(0xFF2C3E50),
                fontWeight: FontWeight.w700,
                fontSize: isLandscape ? 8.5 : (totalSiblings == 2 ? 6.2 : 6.8),
                height: 1.05,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
