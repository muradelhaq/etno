import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';

class DynamicGlucoseLineChart extends StatelessWidget {
  final double yeastPercent;
  final int fermentationDays;
  final List<Map<String, dynamic>> trendData;

  const DynamicGlucoseLineChart({
    super.key,
    required this.yeastPercent,
    required this.fermentationDays,
    required this.trendData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perbandingan Kadar Glukosa Harian (Hari 1 - 5)',
            style: AppTextStyles.h2.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          'Visualisasi data empiris kadar glukosa hasil fermentasi pada dosis ragi ${yeastPercent.toStringAsFixed(1)}%:',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 12),

        // Custom High-Res Visual Bar Columns
        EthnoCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          child: Column(
            children: trendData.map((d) {
              final int day = d['day'] as int;
              final double gl = d['glucose'] as double;
              final bool isCurrentDay = day == fermentationDays;
              final bool isPeak = gl >= 50.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hari ke-$day ${isCurrentDay ? '📍 (Dipilih)' : ''}',
                          style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 12,
                            color: isCurrentDay
                                ? AppColors.primaryGreen
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${gl.toStringAsFixed(2)}%',
                          style: AppTextStyles.scientificData.copyWith(
                            fontSize: 13,
                            color: isPeak
                                ? AppColors.terracottaDark
                                : AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.sageLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (gl / 60.0).clamp(0.05, 1.0),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: isPeak
                                  ? AppColors.warmGradient
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Dynamic Line Chart (FL Chart)
        EthnoCard(
          padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 10,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}%',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (val, meta) => Text(
                        'H${val.toInt()}',
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                minX: 1,
                maxX: 5,
                minY: 10,
                maxY: 60,
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData.map((d) {
                      return FlSpot(
                          (d['day'] as int).toDouble(), d['glucose'] as double);
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primaryGreen,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
