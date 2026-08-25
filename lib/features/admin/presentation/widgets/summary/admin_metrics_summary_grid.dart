import 'package:flutter/material.dart';

class AdminMetricsSummaryGrid extends StatelessWidget {
  final bool isLandscape;
  final int totalStudents;
  final double avgPretest;
  final double avgPosttest;
  final double passingRate;

  const AdminMetricsSummaryGrid({
    super.key,
    required this.isLandscape,
    required this.totalStudents,
    required this.avgPretest,
    required this.avgPosttest,
    required this.passingRate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: isLandscape ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isLandscape ? 1.4 : 1.3,
      children: [
        _buildMetricCard(
          title: 'Total Siswa',
          value: '$totalStudents',
          unit: 'Siswa Terdaftar',
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF1E3A2B),
          bgColor: const Color(0xFFE8F5E9),
        ),
        _buildMetricCard(
          title: 'Rata-rata Pre-test',
          value: avgPretest.toStringAsFixed(1),
          unit: 'Skala 100',
          icon: Icons.assignment_outlined,
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
        ),
        _buildMetricCard(
          title: 'Rata-rata Post-test',
          value: avgPosttest.toStringAsFixed(1),
          unit: 'Skala 100',
          icon: Icons.verified_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
        ),
        _buildMetricCard(
          title: 'Kelulusan KKM',
          value: '${passingRate.toStringAsFixed(0)}%',
          unit: 'KKM ≥ 75.0',
          icon: Icons.military_tech_rounded,
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFDBEAFE),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                unit,
                style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
