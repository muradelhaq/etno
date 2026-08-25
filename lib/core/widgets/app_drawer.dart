import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';
import '../../shared/services/local_storage_service.dart';
import 'drawer/drawer_user_header.dart';
import 'drawer/drawer_module_item_tile.dart';
import 'drawer/drawer_audio_setting_tile.dart';
import 'drawer/drawer_version_footer.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressProvider);

    const List<Map<String, dynamic>> menuItems = [
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
          // 1. Drawer Header
          DrawerUserHeader(progress: progress),

          // 2. Drawer Navigation List
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
                final slide = item['slide'] as int;
                final isUnlocked = slide <= progress.highestUnlockedSlide;

                return DrawerModuleItemTile(
                  item: item,
                  isCompleted: isCompleted,
                  isUnlocked: isUnlocked,
                  onLocked: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selesaikan slide ${progress.highestUnlockedSlide} terlebih dahulu.',
                        ),
                        backgroundColor: AppColors.warmTerracotta,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 3. Quick Action Buttons (Sertifikat & Idea Pad)
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

          // 4. Background Music Setting Tile
          const DrawerAudioSettingTile(),

          // 5. App Version & Check Update Tile
          const DrawerVersionFooter(),
        ],
      ),
    );
  }
}
