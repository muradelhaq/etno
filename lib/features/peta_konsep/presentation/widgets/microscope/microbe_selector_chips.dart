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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MicroorganismData.microbes.map((m) {
        final isSelected = m.id == selectedMicrobeId;
        return ChoiceChip(
          label: Text(m.scientificName.split(' ').take(2).join(' ')),
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
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 11.5,
            fontStyle: FontStyle.italic,
          ),
          onSelected: (sel) {
            if (sel) {
              onSelected(m.id);
            }
          },
        );
      }).toList(),
    );
  }
}
