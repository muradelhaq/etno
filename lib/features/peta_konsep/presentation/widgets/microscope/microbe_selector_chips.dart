import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class MicrobeSelectorChips extends StatelessWidget {
  final String selectedMicrobeId;
  final ValueChanged<String> onSelected;

  const MicrobeSelectorChips({
    super.key,
    required this.selectedMicrobeId,
    required this.onSelected,
  });

  Color _getKingdomColor(String kingdomType) {
    if (kingdomType.toLowerCase().contains('bakteri') ||
        kingdomType.toLowerCase().contains('bacteria')) {
      return const Color(0xFF0284C7); // Sky blue
    }
    if (kingdomType.toLowerCase().contains('khamir')) {
      return AppColors.warmTerracotta; // Amber/Warm
    }
    return AppColors.primaryGreen; // Emerald for Kapang
  }

  String _getKingdomShortLabel(String kingdomType) {
    if (kingdomType.toLowerCase().contains('bakteri') ||
        kingdomType.toLowerCase().contains('bacteria')) {
      return 'Bakteri';
    }
    if (kingdomType.toLowerCase().contains('khamir')) {
      return 'Khamir';
    }
    return 'Kapang';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: MicroorganismData.microbes.map((m) {
            final isSelected = m.id == selectedMicrobeId;
            final kingdomColor = _getKingdomColor(m.kingdomType);
            final kingdomLabel = _getKingdomShortLabel(m.kingdomType);
            final displayName = m.scientificName.split(' ').take(2).join(' ');

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelected(m.id),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.borderSubtle,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Kingdom Dot / Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.22)
                                : kingdomColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            kingdomLabel,
                            style: TextStyle(
                              color: isSelected ? Colors.white : kingdomColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        // Microbe Name
                        Text(
                          displayName,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
