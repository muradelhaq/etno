import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';
import '../../shared/services/local_storage_service.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressProvider);

    final List<Map<String, dynamic>> menuItems = [
      {
        'slide': 1,
        'title': 'Cover & Pengantar',
        'subtitle': 'Capaian Pembelajaran Etnosains',
        'route': '/',
        'icon': Icons.auto_stories_rounded,
        'id': 'cover',
      },
      {
        'slide': 2,
        'title': 'Apersepsi & Brainstorming',
        'subtitle': 'Kuliner Modern vs Tradisional',
        'route': '/apersepsi',
        'icon': Icons.psychology_alt_rounded,
        'id': 'apersepsi',
      },
      {
        'slide': 3,
        'title': 'Peta Konsep & Mikroorganisme',
        'subtitle': 'Taksonomi Kapang & Ragi',
        'route': '/peta-konsep',
        'icon': Icons.biotech_rounded,
        'id': 'peta_konsep',
      },
      {
        'slide': 4,
        'title': 'Tempe & Kearifan Lokal',
        'subtitle': 'Rhizopus oligosporus & Daun Pisang',
        'route': '/produk/tempe',
        'icon': Icons.grass_rounded,
        'id': 'tempe',
      },
      {
        'slide': 5,
        'title': 'Tape Singkong & Peuyeum',
        'subtitle': 'Saccharomyces & Hidrolisis Amilum',
        'route': '/produk/tape',
        'icon': Icons.bakery_dining_rounded,
        'id': 'tape',
      },
      {
        'slide': 6,
        'title': 'Tauco & Fermentasi Garam',
        'subtitle': 'Tetragenococcus & Penjemuran',
        'route': '/produk/tauco',
        'icon': Icons.soup_kitchen_rounded,
        'id': 'tauco',
      },
      {
        'slide': 7,
        'title': 'Kecap & Oncom Tradisional',
        'subtitle': 'Neurospora & Ampas Tahu',
        'route': '/produk/kecap',
        'icon': Icons.restaurant_menu_rounded,
        'id': 'kecap',
      },
      {
        'slide': 8,
        'title': 'Jelajah Budaya Nusantara',
        'subtitle': 'Peta Interaktif Priangan & Jawa',
        'route': '/jelajah-budaya',
        'icon': Icons.map_rounded,
        'id': 'jelajah',
      },
      {
        'slide': 9,
        'title': 'Virtual Lab Uji Glukosa',
        'subtitle': 'Simulasi Ragi & Durasi Fermentasi',
        'route': '/virtual-lab',
        'icon': Icons.science_rounded,
        'id': 'virtual_lab',
      },
      {
        'slide': 10,
        'title': 'Proyek Challenge Etnosains',
        'subtitle': 'Investigasi & Video Edukasi',
        'route': '/challenge-proyek',
        'icon': Icons.video_camera_back_rounded,
        'id': 'challenge',
      },
      {
        'slide': 11,
        'title': 'Refleksi & Asesmen Budaya',
        'subtitle': 'Skala Likert Kesadaran Kearifan',
        'route': '/evaluasi-kearifan',
        'icon': Icons.rate_review_rounded,
        'id': 'cultural_assessment',
      },
      {
        'slide': 12,
        'title': 'Evaluasi Literasi Sains (PISA)',
        'subtitle': '10 Soal HOTS & E-Sertifikat',
        'route': '/literasi-sains-quiz',
        'icon': Icons.quiz_rounded,
        'id': 'pisa_quiz',
      },
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco_rounded,
                          color: AppColors.warmCream, size: 28),
                    ),
                    InkWell(
                      onTap: () => _showEditNameDialog(context, ref),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warmTerracotta,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_rounded,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('Ganti Nama',
                                style: AppTextStyles.tagText
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  progress.studentName,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'E-Modul Etnosains Fermentasi',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.sageLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                // XP and completion banner
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars_rounded,
                                color: AppColors.goldenYellow, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${progress.earnedXP} XP',
                              style: AppTextStyles.bodyBold.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.sageLight, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${progress.completedModules.length}/12 Modul',
                              style: AppTextStyles.bodyBold.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawer List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              separatorBuilder: (ctx, i) =>
                  const Divider(height: 1, color: AppColors.borderSubtle),
              itemBuilder: (ctx, i) {
                final item = menuItems[i];
                final isCompleted =
                    progress.completedModules.contains(item['id']);

                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.sageLight
                          : AppColors.warmCream.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        item['icon'] as IconData,
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : AppColors.warmTerracotta,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'S${item['slide']}',
                          style: AppTextStyles.tagText.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 13,
                            color: AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    item['subtitle'] as String,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isCompleted
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.successGreen, size: 20)
                      : const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textLight, size: 20),
                  onTap: () {
                    Navigator.pop(context);
                    context.go(item['route'] as String);
                  },
                );
              },
            ),
          ),

          // Footer Options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.warmCream,
              border: Border(
                top: BorderSide(color: AppColors.borderSubtle),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.workspace_premium_rounded,
                      color: AppColors.terracottaDark, size: 20),
                  label: Text('E-Sertifikat',
                      style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.terracottaDark, fontSize: 13)),
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/sertifikat');
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.lightbulb_rounded,
                      color: AppColors.primaryGreen, size: 20),
                  label: Text('Idea Pad',
                      style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.primaryGreen, fontSize: 13)),
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/inovasi-pangan');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final currentName = ref.read(userProgressProvider).studentName;
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Masukkan Nama Siswa', style: AppTextStyles.h3),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nama lengkap untuk sertifikat',
            prefixIcon: Icon(Icons.person_rounded),
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
}
