import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';

class RegionChipSelector extends StatelessWidget {
  final String selectedRegionId;
  final ValueChanged<String> onSelected;

  const RegionChipSelector({
    super.key,
    required this.selectedRegionId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: JelajahBudayaData.regions.map((r) {
          final isSelected = r.id == selectedRegionId;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.location_on_outlined,
                size: 14,
                color: isSelected ? Colors.white : AppColors.primaryGreen,
              ),
              label: Text(r.regionName),
              selected: isSelected,
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.borderSubtle,
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              onSelected: (sel) {
                if (sel) {
                  onSelected(r.id);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
