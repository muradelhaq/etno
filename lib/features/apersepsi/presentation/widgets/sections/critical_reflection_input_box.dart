import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

class CriticalReflectionInputBox extends StatefulWidget {
  const CriticalReflectionInputBox({super.key});

  @override
  State<CriticalReflectionInputBox> createState() => _CriticalReflectionInputBoxState();
}

class _CriticalReflectionInputBoxState extends State<CriticalReflectionInputBox> {
  late TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController();
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentReflect = ref.watch(userProgressProvider).apersepsiReflection;
        if (_reflectionController.text.isEmpty && currentReflect.isNotEmpty) {
          _reflectionController.text = currentReflect;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('3. Refleksi Kritis & Kolom Pendapat Siswa',
                style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.goldenYellow),
              ),
              child: Text(
                'Pertanyaan: "Mengapa banyak generasi muda saat ini lebih mengenal Pizza, Burger, atau Kimchi dibandingkan Colenak, Combro, dan Oncom? Menurutmu bagaimana cara membuatnya diminati kembali?"',
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.terracottaDark,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _reflectionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tuliskan pendapat atau analisis pribadimu di sini...',
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              onChanged: (val) {
                ref.read(userProgressProvider.notifier).saveApersepsiReflection(val);
              },
            ),

            const SizedBox(height: 14),

            CustomButton(
              text: 'Simpan Pendapat & Lanjut ke Peta Konsep',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () {
                ref
                    .read(userProgressProvider.notifier)
                    .saveApersepsiReflection(_reflectionController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendapatmu berhasil disimpan! (+30 XP)'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                context.go('/peta-konsep');
              },
            ),
          ],
        );
      },
    );
  }
}
