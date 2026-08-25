import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

class FoodMatchingChallengeCard extends StatefulWidget {
  const FoodMatchingChallengeCard({super.key});

  @override
  State<FoodMatchingChallengeCard> createState() => _FoodMatchingChallengeCardState();
}

class _FoodMatchingChallengeCardState extends State<FoodMatchingChallengeCard> {
  final Map<String, String?> _matchedAnswers = {
    'Orek Tempe': null,
    'Tempe Mendoan': null,
    'Es Goyobod Peuyeum': null,
    'Es Tape Ketan': null,
    'Martabak Tape Ketan': null,
    'Sayur Ikan Tauco': null,
  };

  final Map<String, String> _correctKeys = {
    'Orek Tempe': 'Tempe',
    'Tempe Mendoan': 'Tempe',
    'Es Goyobod Peuyeum': 'Tape Singkong',
    'Es Tape Ketan': 'Tape Ketan',
    'Martabak Tape Ketan': 'Tape Ketan',
    'Sayur Ikan Tauco': 'Tauco',
  };

  final List<String> _fermentationOptions = const [
    'Tempe',
    'Tape Singkong',
    'Tape Ketan',
    'Tauco',
    'Oncom',
  ];

  void _checkMatchingAnswers(WidgetRef ref) {
    int correctCount = 0;
    _matchedAnswers.forEach((food, selected) {
      if (selected == _correctKeys[food]) {
        correctCount++;
      }
    });

    if (correctCount == _matchedAnswers.length) {
      ref.read(userProgressProvider.notifier).addXP(50);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.successGreen),
              const SizedBox(width: 8),
              Text('Luar Biasa!', style: AppTextStyles.h3),
            ],
          ),
          content: const Text(
            'Semua makanan tradisional berhasil kamu pasangkan dengan tepat ke bahan dasar fermentasinya! (+50 XP)',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Lanjut Belajar'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Kamu berhasil mencocokkan $correctCount dari ${_matchedAnswers.length} makanan dengan benar. Periksa kembali pilihanmu!'),
          backgroundColor: AppColors.warmTerracotta,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('2. Tantangan: Cocokkan Makanan dengan Bahan Fermentasinya',
            style: AppTextStyles.h2.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          'Pilih produk fermentasi dasar yang sesuai untuk setiap hidangan tradisional di bawah ini:',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 14),

        EthnoCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: AppColors.warmCream.withValues(alpha: 0.4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;
              final itemWidth =
                  isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 6,
                children: _matchedAnswers.keys.map((foodName) {
                  final selected = _matchedAnswers[foodName];
                  final isCorrect = selected == _correctKeys[foodName];

                  return SizedBox(
                    width: itemWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Icon(
                                  selected == null
                                      ? Icons.radio_button_unchecked
                                      : (isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel),
                                  size: 18,
                                  color: selected == null
                                      ? Colors.grey
                                      : (isCorrect
                                          ? AppColors.successGreen
                                          : AppColors.errorRed),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    foodName,
                                    style: AppTextStyles.bodyBold
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 5,
                            child: DropdownButtonFormField<String>(
                              initialValue: selected,
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: selected == null
                                        ? AppColors.borderSubtle
                                        : (isCorrect
                                            ? AppColors.successGreen
                                            : AppColors.errorRed),
                                  ),
                                ),
                              ),
                              hint: Text('Pilih Produk...',
                                  style: AppTextStyles.bodySmall),
                              items: _fermentationOptions.map((opt) {
                                return DropdownMenuItem(
                                  value: opt,
                                  child: Text(opt,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _matchedAnswers[foodName] = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Consumer(
          builder: (context, ref, _) {
            return Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _checkMatchingAnswers(ref),
                icon: const Icon(Icons.task_alt_rounded, size: 18),
                label: const Text('Cek Jawaban Cocok'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
