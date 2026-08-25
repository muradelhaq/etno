import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../dialogs/concept_tree_detail_dialog.dart';
import '../models/tree_concept_node.dart';

class TreeParentNodeCard extends StatelessWidget {
  final TreeBranch branch;
  final double width;
  final bool isLandscape;

  const TreeParentNodeCard({
    super.key,
    required this.branch,
    required this.width,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ConceptTreeDialogs.showDetailDialog(
        context: context,
        title: branch.title,
        category: 'Produk Induk Fermentasi',
        microbe: branch.microbe,
        imageAsset: branch.imageAsset,
        description: branch.description,
        route: branch.route,
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(isLandscape ? 10 : 7),
          border: Border.all(
            color: const Color(0xFF2D5A3C).withValues(alpha: 0.45),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(isLandscape ? 3.0 : 1.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Text(
                branch.title.toUpperCase(),
                style: TextStyle(
                  color: const Color(0xFF1E3A2B),
                  fontWeight: FontWeight.w900,
                  fontSize: isLandscape ? 10.5 : 8.0,
                  letterSpacing: 0.2,
                  height: 1.05,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 1),
            ClipRRect(
              borderRadius: BorderRadius.circular(isLandscape ? 6 : 4),
              child: Image.asset(
                branch.imageAsset,
                height: isLandscape ? 52 : 36,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: isLandscape ? 52 : 36,
                  color: AppColors.warmCream,
                  child: const Center(
                    child: Icon(
                      Icons.rice_bowl_rounded,
                      color: AppColors.primaryGreen,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
