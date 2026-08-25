import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';

class ProcedureGuideCard extends StatelessWidget {
  const ProcedureGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      borderColor: AppColors.primaryGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prosedur Praktikum Resmi:',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          Text(
            '1. Singkong (900 g) dipotong rapi dan dicuci bersih hingga getah hilang.\n'
            '2. Kukus singkong selama 30 menit hingga matang empuk.\n'
            '3. Dinginkan singkong secara merata di atas tampah hingga suhu kamar.\n'
            '4. Inokulasikan ragi tape halus sesuai perlakuan:\n'
            '   • Kelompok A (0,5%): Tambahkan 4,5 g ragi.\n'
            '   • Kelompok B (1,0%): Tambahkan 9,0 g ragi.\n'
            '   • Kelompok C (1,5%): Tambahkan 13,5 g ragi.\n'
            '5. Masukkan ke wadah tertutup beralas daun pisang dan simpan pada suhu ruang.\n'
            '6. Ukur kadar glukosa dan uji organoleptik pada hari ke-1, 2, dan 3.',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
