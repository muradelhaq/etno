import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class VirtualLabGameTab extends StatefulWidget {
  const VirtualLabGameTab({super.key});

  @override
  State<VirtualLabGameTab> createState() => _VirtualLabGameTabState();
}

class _VirtualLabGameTabState extends State<VirtualLabGameTab> {
  int _gameScore = 0;
  final Set<String> _scoredMicrobes = {};
  final Map<String, String?> _imageAnswers = {
    'rhizopus': null,
    'saccharomyces': null,
    'neurospora': null,
  };
  static const _imageOptionIds = [
    'rhizopus',
    'saccharomyces',
    'aspergillus_oryzae',
    'neurospora',
  ];
  final Map<String, String?> _microbeMatches = {
    'Rhizopus oligosporus': null,
    'Saccharomyces cerevisiae': null,
    'Aspergillus oryzae': null,
  };
  final Map<String, String> _correctMicrobe = {
    'Rhizopus oligosporus': 'Tempe Kedelai',
    'Saccharomyces cerevisiae': 'Tape Singkong',
    'Aspergillus oryzae': 'Tauco Cianjur',
  };

  MicroorganismModel _microbe(String id) =>
      MicroorganismData.microbes.firstWhere((microbe) => microbe.id == id);

  bool get _missionOneComplete => _microbeMatches.entries.every(
        (entry) => entry.value == _correctMicrobe[entry.key],
      );

  bool get _missionTwoComplete => _imageAnswers.entries.every(
        (entry) => entry.value == entry.key,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Header Score Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Game Interaktif Etnosains',
                        style: AppTextStyles.h3
                            .copyWith(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text('Kumpulkan poin dan selesaikan seluruh misi!',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.military_tech_rounded,
                          color: AppColors.goldenYellow, size: 24),
                      const SizedBox(width: 6),
                      Text('$_gameScore XP',
                          style: AppTextStyles.h2
                              .copyWith(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Misi 1: Cocokkan Mikroorganisme
          Text('Misi 1: Pasangkan Mikroba dengan Produk Fermentasi',
              style: AppTextStyles.h2.copyWith(fontSize: 15)),
          const SizedBox(height: 10),

          ..._microbeMatches.keys.map((microbe) {
            final selected = _microbeMatches[microbe];
            final isCorrect = selected == _correctMicrobe[microbe];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: EthnoCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔬 $microbe',
                        style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primaryDark)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        'Tempe Kedelai',
                        'Tape Singkong',
                        'Tauco Cianjur'
                      ].map((prod) {
                        final isThisSelected = selected == prod;
                        return ChoiceChip(
                          label:
                              Text(prod, style: const TextStyle(fontSize: 11)),
                          selected: isThisSelected,
                          selectedColor: isCorrect
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                          onSelected: (sel) {
                            if (sel) {
                              setState(() {
                                _microbeMatches[microbe] = prod;
                                if (prod == _correctMicrobe[microbe] &&
                                    _scoredMicrobes.add(microbe)) {
                                  _gameScore += 30;
                                }
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          Text('Misi 2: Tebak Gambar Mikroorganisme',
              style: AppTextStyles.h2.copyWith(fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            'Pilih gambar mikroskop yang sesuai dengan nama mikroorganisme pada setiap soal.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 10),
          ..._imageAnswers.keys.map((targetId) {
            final target = _microbe(targetId);
            final selected = _imageAnswers[targetId];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: EthnoCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mikroorganisme: ${target.scientificName}',
                        style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.primaryDark, fontSize: 13)),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.35,
                      children: _imageOptionIds.map((optionId) {
                        final option = _microbe(optionId);
                        final isSelected = selected == optionId;
                        final isCorrect = optionId == targetId;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _imageAnswers[targetId] = optionId;
                              if (isCorrect &&
                                  _scoredMicrobes.add('image:$targetId')) {
                                _gameScore += 30;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? (isCorrect
                                        ? AppColors.successGreen
                                        : AppColors.errorRed)
                                    : AppColors.borderSubtle,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: AppImage(
                              option.afterZoomImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 6),

          Consumer(
            builder: (context, ref, _) {
              return CustomButton(
                text: 'Simpan Poin Game & Lanjut',
                icon: Icons.check_circle_outline_rounded,
                isFullWidth: true,
                backgroundColor: AppColors.primaryGreen,
                onPressed: () {
                  if (!_missionOneComplete || !_missionTwoComplete) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Selesaikan semua pasangan Misi 1 dan semua tebak gambar Misi 2 terlebih dahulu.'),
                        backgroundColor: AppColors.warmTerracotta,
                      ),
                    );
                    return;
                  }
                  ref.read(userProgressProvider.notifier).markModuleCompleted(
                        'virtual_lab_game',
                        xpBonus: _gameScore,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Mini games selesai. Poin game ($_gameScore XP) tersimpan di profil belajarmu!'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
