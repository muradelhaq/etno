import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({super.key});

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  final _titleController = TextEditingController();
  final _membersController = TextEditingController();
  final _linkController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitted = false;

  final List<Map<String, dynamic>> _rubrics = [
    {
      'title': '1. Sejarah & Asal-usul',
      'desc':
          'Menjelaskan latar belakang budaya dan etimologi nama kuliner secara lugas.',
      'icon': Icons.history_rounded,
    },
    {
      'title': '2. Proses Bioteknologi',
      'desc':
          'Menguraikan peran kapang/khamir/bakteri dan tahapan fermentasi secara ilmiah.',
      'icon': Icons.biotech_rounded,
    },
    {
      'title': '3. Manfaat Kesehatan',
      'desc':
          'Memaparkan kandungan gizi, asam amino, vitamin B12, atau daya cerna protein.',
      'icon': Icons.health_and_safety_rounded,
    },
    {
      'title': '4. Nilai Kearifan Lokal',
      'desc':
          'Menonjolkan filosofi ramah lingkungan (zero waste) dan kebiasaan tradisional.',
      'icon': Icons.eco_rounded,
    },
    {
      'title': '5. Inovasi Produk Modern',
      'desc':
          'Menawarkan ide penyajian kekinian agar digemari generasi muda masa kini.',
      'icon': Icons.lightbulb_rounded,
    },
    {
      'title': '6. Ajakan Melestarikan',
      'desc':
          'Memberikan ajakan persuasif dan bangga terhadap kekayaan kuliner Nusantara.',
      'icon': Icons.campaign_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    final project = ref.read(userProgressProvider);
    _titleController.text = project.projectTitle;
    _membersController.text = project.projectMembers;
    _linkController.text = project.projectLink;
    _notesController.text = project.projectNotes;
    _isSubmitted = project.projectSubmitted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _membersController.dispose();
    _linkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_titleController.text.isEmpty || _membersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Silakan lengkapi judul proyek dan nama anggota kelompok!'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitted = true;
    });

    ref.read(userProgressProvider.notifier).saveProjectSubmission(
          title: _titleController.text,
          members: _membersController.text,
          link: _linkController.text,
          notes: _notesController.text,
        );
    ref
        .read(userProgressProvider.notifier)
        .markModuleCompleted('challenge', xpBonus: 100);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: AppColors.successGreen),
            const SizedBox(width: 8),
            Text('Proyek Terkirim!', style: AppTextStyles.h3),
          ],
        ),
        content: const Text(
          'Selamat! Proyek kampanye video etnosains kelompokmu berhasil dicatat dalam rekam portofolio pembelajaran. (+100 XP)',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/evaluasi-kearifan');
            },
            child: const Text('Lanjut ke Asesmen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EthnoScaffold(
      title: 'Proyek Challenge Inovasi',
      subtitle: 'Slide 10 / 12 • Kampanye Edukasi Media Sosial',
      currentSlide: 10,
      totalSlides: 12,
      prevRoute: '/virtual-lab',
      nextRoute: '/evaluasi-kearifan',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.video_camera_back_rounded,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tugas Proyek Kolaboratif',
                            style: AppTextStyles.h3
                                .copyWith(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          'Buat video promosi (TikTok / IG Reels 1–2 menit) tentang makanan fermentasi tradisional khas daerahmu!',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 18),

            // Section 1: 6 Mandatory Criteria
            Text('6 Kriteria Wajib Konten Edukasi:',
                style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 10),

            ..._rubrics.map((r) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: EthnoCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.sageLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(r['icon'] as IconData,
                            color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['title'] as String,
                                style: AppTextStyles.bodyBold.copyWith(
                                    fontSize: 13,
                                    color: AppColors.primaryDark)),
                            Text(r['desc'] as String,
                                style: AppTextStyles.bodySmall
                                    .copyWith(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Button to Innovation Idea Pad
            OutlinedButton.icon(
              onPressed: () => context.go('/inovasi-pangan'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(
                    color: AppColors.warmTerracotta, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.lightbulb_rounded,
                  color: AppColors.warmTerracotta),
              label: Text(
                'Buka Galeri Ide Inovasi Pangan Modern',
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.terracottaDark),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 2: Submission Form
            Text('Formulir Pengumpulan Proyek Kelompok',
                style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 8),

            EthnoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul Proyek Video:', style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText:
                          'Contoh: Rahasia Kelezatan Colenak & Bio-Sainsnya',
                      prefixIcon: Icon(Icons.movie_creation_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Anggota Kelompok:', style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _membersController,
                    decoration: const InputDecoration(
                      hintText: 'Nama lengkap ketua & anggota kelompok...',
                      prefixIcon: Icon(Icons.group_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Tautan Video (TikTok / IG Reels / YouTube):',
                      style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      hintText: 'https://tiktok.com/@kelompok/...',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Catatan / Sinopsis Singkat:',
                      style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Uraikan secara singkat alur video yang kalian buat...',
                    ),
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    text: _isSubmitted
                        ? 'Kirim Pembaruan Proyek'
                        : 'Kirim Tugas Proyek (+100 XP)',
                    icon: Icons.send_rounded,
                    isFullWidth: true,
                    backgroundColor: AppColors.primaryGreen,
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
