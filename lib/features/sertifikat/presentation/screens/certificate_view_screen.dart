import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/certificate_generator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';

class CertificateViewScreen extends ConsumerStatefulWidget {
  const CertificateViewScreen({super.key});

  @override
  ConsumerState<CertificateViewScreen> createState() =>
      _CertificateViewScreenState();
}

class _CertificateViewScreenState extends ConsumerState<CertificateViewScreen> {
  bool _isGenerating = false;

  void _editNameDialog(BuildContext context) {
    final currentName = ref.read(userProgressProvider).studentName;
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Nama pada Sertifikat', style: AppTextStyles.h3),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nama Lengkap Siswa...',
            prefixIcon: Icon(Icons.person_outline),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(userProgressProvider.notifier)
                    .updateStudentName(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrintOrDownload() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final progress = ref.read(userProgressProvider);
      await CertificateGenerator.printCertificate(progress);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat dokumen PDF: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(userProgressProvider);
    final dateFormatted = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());

    return EthnoScaffold(
      title: 'E-Sertifikat Kelulusan',
      subtitle: 'Penghargaan Resmi Kelulusan E-Modul',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            // Congratulations Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat atas Kelulusanmu!', style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          'Kamu telah menguasai konsep etnosains dan bioteknologi pangan tradisional.',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.95)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Certificate Preview Card
            EthnoCard(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              borderColor: AppColors.primaryGreen,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.goldenYellow, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.warmCream.withValues(alpha: 0.3),
                ),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_rounded, color: AppColors.primaryGreen, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'SERTIFIKAT KELULUSAN',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'E-MODUL ETNOSAINS FERMENTASI TRADISIONAL',
                      style: AppTextStyles.tagText.copyWith(
                        color: AppColors.warmTerracotta,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Diberikan dengan bangga kepada:',
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),

                    const SizedBox(height: 8),

                    // Student Name
                    InkWell(
                      onTap: () => _editNameDialog(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              progress.studentName.toUpperCase(),
                              style: AppTextStyles.h1.copyWith(
                                fontSize: 20,
                                color: AppColors.primaryDark,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.edit_rounded, size: 16, color: AppColors.warmTerracotta),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Telah menyelesaikan seluruh rangkaian modul rekonstruksi kearifan lokal (Tempe, Tape, Tauco, Kecap, Oncom) serta Uji Literasi Sains HOTS PISA.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11, height: 1.4),
                    ),

                    const SizedBox(height: 16),

                    // Metrics Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBadge('Skor PISA', '${progress.quizScore}/100'),
                        _buildBadge('Kesadaran Budaya', '${progress.culturalAwarenessScore.toStringAsFixed(0)}%'),
                        _buildBadge('Total XP', '${progress.earnedXP} XP'),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(color: AppColors.goldenYellow, thickness: 1),
                    const SizedBox(height: 10),

                    // Signatures & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal: $dateFormatted', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                            Text('ID: ETNO-${progress.earnedXP}', style: AppTextStyles.scientificFormula.copyWith(fontSize: 9)),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.verified, color: AppColors.primaryGreen, size: 24),
                            Text('Tim Pengembang Etnosains', style: AppTextStyles.tagText.copyWith(fontSize: 10, color: AppColors.primaryDark)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // Print / Export PDF Action Button
            CustomButton(
              text: _isGenerating ? 'Memproses Sertifikat...' : 'Unduh / Cetak Sertifikat (PDF)',
              icon: Icons.print_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: _isGenerating ? null : _handlePrintOrDownload,
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () => context.go('/'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.home_rounded, color: AppColors.primaryGreen),
              label: Text(
                'Kembali ke Beranda Utama',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldenYellow),
      ),
      child: Column(
        children: [
          Text(val, style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen, fontSize: 13)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}
