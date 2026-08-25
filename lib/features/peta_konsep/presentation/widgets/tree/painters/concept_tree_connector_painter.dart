import 'package:flutter/material.dart';

/// CustomPainter for Root Node to the 4 Main Branches
class RootToParentsConnectorPainter extends CustomPainter {
  final int branchCount;
  final double totalWidth;
  final double paddingLeft;
  final double branchWidth;

  RootToParentsConnectorPainter({
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
  bool shouldRepaint(covariant RootToParentsConnectorPainter oldDelegate) =>
      oldDelegate.totalWidth != totalWidth ||
      oldDelegate.branchWidth != branchWidth;
}

/// CustomPainter for Branch Parent to Child Nodes
class BranchToChildrenConnectorPainter extends CustomPainter {
  final int childCount;
  final double branchWidth;

  BranchToChildrenConnectorPainter({
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
  bool shouldRepaint(covariant BranchToChildrenConnectorPainter oldDelegate) =>
      oldDelegate.childCount != childCount ||
      oldDelegate.branchWidth != branchWidth;
}
