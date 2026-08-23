import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

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
                    onTap: () => _showRootInfoDialog(context),
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
                            color:
                                const Color(0xFF2D5A3C).withValues(alpha: 0.3),
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

                  // Full-Width Tree Hierarchy Diagram (Calculated from innerWidth)
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

    final branches = _getTreeData();

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
              painter: _RootToParentsConnectorPainter(
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

  Widget _buildBranchColumn(BuildContext context, _TreeBranch branch,
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
          _buildParentCard(context, branch, parentCardWidth, isLandscape),

          // Branch connector lines to children
          SizedBox(
            height: isLandscape ? 18 : 14,
            width: branchWidth,
            child: CustomPaint(
              painter: _BranchToChildrenConnectorPainter(
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
                child: _buildChildCard(
                    context, child, childWidth, childCount, isLandscape),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildParentCard(BuildContext context, _TreeBranch branch,
      double width, bool isLandscape) {
    return GestureDetector(
      onTap: () => _showDetailDialog(
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
            // Title
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
            // Image
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
                    child: Icon(Icons.rice_bowl_rounded,
                        color: AppColors.primaryGreen, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, _TreeChild child, double width,
      int totalSiblings, bool isLandscape) {
    return GestureDetector(
      onTap: () => _showDetailDialog(
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(isLandscape ? 5 : 3),
              child: Image.asset(
                child.imageAsset,
                height: isLandscape
                    ? 36
                    : (totalSiblings == 2 ? 23 : 25),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: isLandscape ? 36 : 23,
                  color: AppColors.warmCream,
                  child: const Center(
                    child: Icon(Icons.fastfood_rounded,
                        color: AppColors.warmTerracotta, size: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            // Title
            Text(
              child.title,
              style: TextStyle(
                color: const Color(0xFF2C3E50),
                fontWeight: FontWeight.w700,
                fontSize: isLandscape
                    ? 8.5
                    : (totalSiblings == 2 ? 6.2 : 6.8),
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

  void _showRootInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.account_tree_rounded, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Text('Produk Fermentasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Peta konsep ini merangkum 4 pilar produk fermentasi tradisional Indonesia (Tempe, Tape Singkong, Tape Ketan, dan Tauco) beserta ragam kuliner turunannya. Setiap produk memanfaatkan mikroorganisme spesifik yang mengubah cita rasa, tekstur, dan nilai gizi bahan pangan.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog({
    required BuildContext context,
    required String title,
    required String category,
    required String microbe,
    required String imageAsset,
    required String description,
    required String? route,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imageAsset,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: AppColors.warmCream,
                    child: const Center(
                      child: Icon(Icons.rice_bowl_rounded,
                          size: 40, color: AppColors.primaryGreen),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(title, style: AppTextStyles.h3),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.sageLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primaryGreen),
                            ),
                            child: Text(
                              category,
                              style: AppTextStyles.tagText.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agens Mikroba / Basis:',
                        style: AppTextStyles.tagText.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        microbe,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 12.5,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(description,
                          style:
                              AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          if (route != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(route);
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Buka Modul'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  List<_TreeBranch> _getTreeData() {
    return const [
      _TreeBranch(
        id: 'tempe',
        title: 'Tempe',
        imageAsset: 'assets/images/food_tempe.jpg',
        microbe: 'Rhizopus oligosporus & R. oryzae',
        description:
            'Fermentasi biji kedelai oleh miselium kapang Rhizopus yang menghasilkan struktur padat, enzim protease, dan vitamin B12.',
        route: '/produk/tempe',
        children: [
          _TreeChild(
            id: 'orek_tempe',
            title: 'Orek Tempe',
            imageAsset: 'assets/images/food_tempe.jpg',
            parentProduct: 'Tempe Kedelai (Rhizopus)',
            description:
                'Potongan tempe yang ditumis gurih manis dengan kecap dan bumbu rempah aromatik.',
            route: '/produk/tempe',
          ),
          _TreeChild(
            id: 'mendoan',
            title: 'Mendoan',
            imageAsset: 'assets/images/food_tempe.jpg',
            parentProduct: 'Tempe Kedelai (Rhizopus)',
            description:
                'Tempe tipis khas Banyumas dibalut adonan tepung berbumbu dan digoreng mendo (setengah matang).',
            route: '/produk/tempe',
          ),
        ],
      ),
      _TreeBranch(
        id: 'tape_singkong',
        title: 'Tape Singkong',
        imageAsset: 'assets/images/food_tape_singkong.jpg',
        microbe: 'Saccharomyces cerevisiae & Aspergillus',
        description:
            'Fermentasi umbi singkong kukus dengan ragi yang mengubah pati menjadi glukosa manis beraroma alkohol lembut.',
        route: '/produk/tape',
        children: [
          _TreeChild(
            id: 'goyobod',
            title: 'Goyobod',
            imageAsset: 'assets/images/food_tape_singkong.jpg',
            parentProduct: 'Tape Singkong / Peuyeum',
            description:
                'Minuman es tradisional khas Sunda Jawa Barat berisi potongan peuyeum legit, santan, dan serutan es segar.',
            route: '/produk/tape',
          ),
        ],
      ),
      _TreeBranch(
        id: 'tape_ketan',
        title: 'Tape Ketan',
        imageAsset: 'assets/images/food_tape_ketan.jpg',
        microbe: 'Amylomyces rouxii & S. cerevisiae',
        description:
            'Fermentasi beras ketan putih atau hitam menghasilkan rasa manis berair yang khas kaya senyawa antioksidan antosianin.',
        route: '/produk/tape-ketan',
        children: [
          _TreeChild(
            id: 'es_tape_ketan',
            title: 'Es Tape Ketan',
            imageAsset: 'assets/images/food_tape_ketan.jpg',
            parentProduct: 'Tape Ketan (Amylomyces)',
            description:
                'Sajian es pelepas dahaga dari paduan sari manis tape ketan hijau, santan, dan es serut.',
            route: '/produk/tape-ketan',
          ),
          _TreeChild(
            id: 'martabak_ketan',
            title: 'Martabak Ketan',
            imageAsset: 'assets/images/food_tape_ketan.jpg',
            parentProduct: 'Tape Ketan (Amylomyces)',
            description:
                'Martabak manis legit dengan isian tape ketan hitam/hijau yang lembut harum.',
            route: '/produk/tape-ketan',
          ),
        ],
      ),
      _TreeBranch(
        id: 'tauco',
        title: 'Tauco',
        imageAsset: 'assets/images/food_tauco.jpg',
        microbe: 'Aspergillus oryzae & Tetragenococcus',
        description:
            'Bumbu fermentasi kedelai kuning khas Cianjur melalui dua tahap fermentasi: kapang (koji) dan larutan garam pekat.',
        route: '/produk/tauco',
        children: [
          _TreeChild(
            id: 'sayur_tauco',
            title: 'Sayur Ikan Tauco',
            imageAsset: 'assets/images/food_tauco.jpg',
            parentProduct: 'Tauco Cianjur (A. oryzae)',
            description:
                'Olahan sayur kuah ikan gurih khas dengan aroma dan cita rasa tauco fermentasi kedelai yang khas.',
            route: '/produk/tauco',
          ),
        ],
      ),
    ];
  }
}

class _TreeBranch {
  final String id;
  final String title;
  final String imageAsset;
  final String microbe;
  final String description;
  final String? route;
  final List<_TreeChild> children;

  const _TreeBranch({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.microbe,
    required this.description,
    this.route,
    required this.children,
  });
}

class _TreeChild {
  final String id;
  final String title;
  final String imageAsset;
  final String parentProduct;
  final String description;
  final String? route;

  const _TreeChild({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.parentProduct,
    required this.description,
    this.route,
  });
}

/// CustomPainter for Root Node to the 4 Main Branches
class _RootToParentsConnectorPainter extends CustomPainter {
  final int branchCount;
  final double totalWidth;
  final double paddingLeft;
  final double branchWidth;

  _RootToParentsConnectorPainter({
    required this.branchCount,
    required this.totalWidth,
    required this.paddingLeft,
    required this.branchWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    final rootCenterX = size.width / 2;
    final midY = size.height * 0.50;

    // Line from root bottom to mid horizontal bar
    canvas.drawLine(
        Offset(rootCenterX, 0), Offset(rootCenterX, midY), linePaint);

    // Calculate center X of each branch column
    final branchCenters = <double>[];
    for (int i = 0; i < branchCount; i++) {
      final cx = paddingLeft + (i * branchWidth) + (branchWidth / 2);
      branchCenters.add(cx);
    }

    if (branchCenters.isEmpty) return;

    // Horizontal bar connecting all branch centers
    canvas.drawLine(
      Offset(branchCenters.first, midY),
      Offset(branchCenters.last, midY),
      linePaint,
    );

    // Vertical lines down to each branch with arrow
    for (final cx in branchCenters) {
      canvas.drawLine(Offset(cx, midY), Offset(cx, size.height), linePaint);

      // Downward arrow
      final arrow = Path()
        ..moveTo(cx - 2.5, size.height - 4.0)
        ..lineTo(cx + 2.5, size.height - 4.0)
        ..lineTo(cx, size.height)
        ..close();
      canvas.drawPath(arrow, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RootToParentsConnectorPainter oldDelegate) =>
      oldDelegate.totalWidth != totalWidth ||
      oldDelegate.branchWidth != branchWidth;
}

/// CustomPainter for Branch Parent to Child Nodes
class _BranchToChildrenConnectorPainter extends CustomPainter {
  final int childCount;
  final double branchWidth;

  _BranchToChildrenConnectorPainter({
    required this.childCount,
    required this.branchWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    if (childCount <= 1) {
      // Direct single line down with arrow
      canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), linePaint);

      final arrow = Path()
        ..moveTo(cx - 2.5, size.height - 4.0)
        ..lineTo(cx + 2.5, size.height - 4.0)
        ..lineTo(cx, size.height)
        ..close();
      canvas.drawPath(arrow, arrowPaint);
    } else {
      // Split into 2 children
      final midY = size.height * 0.48;
      final childWidth = ((branchWidth - 4) / 2).clamp(26.0, 68.0);
      const spacing = 2.0; // padding horizontal 1.0 * 2
      final halfDistance = (childWidth + spacing) / 2;

      final leftChildX = cx - halfDistance;
      final rightChildX = cx + halfDistance;

      // Stem from parent
      canvas.drawLine(Offset(cx, 0), Offset(cx, midY), linePaint);

      // Horizontal bar
      canvas.drawLine(
        Offset(leftChildX, midY),
        Offset(rightChildX, midY),
        linePaint,
      );

      // Left branch & arrow
      canvas.drawLine(
          Offset(leftChildX, midY), Offset(leftChildX, size.height), linePaint);
      final leftArrow = Path()
        ..moveTo(leftChildX - 2.5, size.height - 4.0)
        ..lineTo(leftChildX + 2.5, size.height - 4.0)
        ..lineTo(leftChildX, size.height)
        ..close();
      canvas.drawPath(leftArrow, arrowPaint);

      // Right branch & arrow
      canvas.drawLine(Offset(rightChildX, midY),
          Offset(rightChildX, size.height), linePaint);
      final rightArrow = Path()
        ..moveTo(rightChildX - 2.5, size.height - 4.0)
        ..lineTo(rightChildX + 2.5, size.height - 4.0)
        ..lineTo(rightChildX, size.height)
        ..close();
      canvas.drawPath(rightArrow, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BranchToChildrenConnectorPainter oldDelegate) =>
      oldDelegate.childCount != childCount ||
      oldDelegate.branchWidth != branchWidth;
}
