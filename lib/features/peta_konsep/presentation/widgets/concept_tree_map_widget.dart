import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'tree/cards/tree_child_node_card.dart';
import 'tree/cards/tree_parent_node_card.dart';
import 'tree/dialogs/concept_tree_detail_dialog.dart';
import 'tree/models/tree_concept_node.dart';
import 'tree/painters/concept_tree_connector_painter.dart';

class ConceptTreeMapWidget extends StatelessWidget {
  const ConceptTreeMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7EE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (ctx, innerConstraints) {
              final innerWidth = innerConstraints.maxWidth;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isLandscape ? 10 : 7),

                  // Top instruction
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      'Klik setiap produk untuk melihat informasi!',
                      style: AppTextStyles.tagText.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isLandscape ? 11 : 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 8 : 5),

                  // Root Badge: PRODUK FERMENTASI
                  GestureDetector(
                    onTap: () => ConceptTreeDialogs.showRootInfoDialog(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 18 : 12,
                        vertical: isLandscape ? 6 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D5A3C),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2D5A3C)
                                .withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'PRODUK FERMENTASI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isLandscape ? 12.5 : 10.5,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Full-Width Tree Hierarchy Diagram
                  _buildTreeHierarchy(context, innerWidth, isLandscape),

                  SizedBox(height: isLandscape ? 8 : 5),

                  // Bottom hint
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: isLandscape ? 13 : 11,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Ketuk kartu untuk melihat detail materi & mikroba',
                            style: AppTextStyles.tagText.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: isLandscape ? 10 : 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isLandscape ? 10 : 7),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTreeHierarchy(
      BuildContext context, double totalWidth, bool isLandscape) {
    const horizontalMargin = 4.0;
    final usableWidth = totalWidth - (horizontalMargin * 2);
    final branchWidth = usableWidth / 4;

    final branches = getConceptTreeData();

    return SizedBox(
      width: totalWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Connector from Root to 4 Parent Columns
          SizedBox(
            height: isLandscape ? 20 : 15,
            width: totalWidth,
            child: CustomPaint(
              painter: RootToParentsConnectorPainter(
                branchCount: 4,
                totalWidth: totalWidth,
                paddingLeft: horizontalMargin,
                branchWidth: branchWidth,
              ),
            ),
          ),

          // 4 Columns Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: branches.map((branch) {
                return SizedBox(
                  width: branchWidth,
                  child: _buildBranchColumn(
                      context, branch, branchWidth, isLandscape),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchColumn(BuildContext context, TreeBranch branch,
      double branchWidth, bool isLandscape) {
    final parentCardWidth = (branchWidth - 3).clamp(58.0, 140.0);
    final childCount = branch.children.length;

    return SizedBox(
      width: branchWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Parent Card (Top Tier)
          TreeParentNodeCard(
            branch: branch,
            width: parentCardWidth,
            isLandscape: isLandscape,
          ),

          // Branch connector lines to children
          SizedBox(
            height: isLandscape ? 18 : 14,
            width: branchWidth,
            child: CustomPaint(
              painter: BranchToChildrenConnectorPainter(
                childCount: childCount,
                branchWidth: branchWidth,
              ),
            ),
          ),

          // Children Cards Row (Bottom Tier)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: branch.children.map((child) {
              final childWidth = childCount == 2
                  ? ((branchWidth - 4) / 2).clamp(26.0, 68.0)
                  : (branchWidth - 6).clamp(46.0, 95.0);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: TreeChildNodeCard(
                  child: child,
                  width: childWidth,
                  totalSiblings: childCount,
                  isLandscape: isLandscape,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
