import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/models/user_progress_model.dart';
import '../../../../shared/services/local_storage_service.dart';

class FoodInnovationScreen extends ConsumerStatefulWidget {
  const FoodInnovationScreen({super.key});

  @override
  ConsumerState<FoodInnovationScreen> createState() =>
      _FoodInnovationScreenState();
}

class _FoodInnovationScreenState extends ConsumerState<FoodInnovationScreen> {
  final _titleCtrl = TextEditingController();
  final _baseProductCtrl = TextEditingController(text: 'Tempe');
  final _ingredientsCtrl = TextEditingController();
  final _bioConceptCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final List<Map<String, dynamic>> _presetInnovations = [
    {
      'title': 'Burger Tempe Vegan Krispi',
      'base': 'Tempe Kedelai',
      'concept':
          'Substitusi daging merah tinggi kolesterol dengan protein nabati kaya asam amino dan serat tempe.',
      'ingredients':
          'Tempe kukus tumbuk, bawang putih, oat, saus jamur, roti bun gandum.',
      'icon': Icons.lunch_dining_rounded,
      'color': AppColors.primaryGreen,
    },
    {
      'title': 'Cheese Cake Peuyeum Bandung',
      'base': 'Tape Singkong (Peuyeum)',
      'concept':
          'Memanfaatkan rasa manis alami glukosa hasil sakarifikasi amilum untuk mengurangi penambahan gula pasir.',
      'ingredients':
          'Peuyeum manis lumat, cream cheese, biskuit gandum, kayu manis bubuk.',
      'icon': Icons.cake_rounded,
      'color': AppColors.warmTerracotta,
    },
    {
      'title': 'Pizza Oncom Saus Tomat Tatar Pasundan',
      'base': 'Oncom Merah Tradisional',
      'concept':
          'Kombinasi aroma khas miselium Neurospora sitophila dan pigmen karotenoid dengan keju mozzarella.',
      'ingredients':
          'Tumis oncom bumbu kencur, saus tomat rempah, adonan pizza gandum.',
      'icon': Icons.local_pizza_rounded,
      'color': AppColors.goldenYellow,
    },
    {
      'title': 'Glaze Tauco Ikan Bakar Modern',
      'base': 'Tauco Cianjur',
      'concept':
          'Pemanfaatan asam glutamat alami hasil fermentasi garam moromi sebagai penyedap umami tanpa MSG sintetis.',
      'ingredients':
          'Pasta tauco murni, madu, jahe parut, kecap manis kelapa, air jeruk limau.',
      'icon': Icons.soup_kitchen_rounded,
      'color': AppColors.terracottaDark,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted('inovasi_pangan', xpBonus: 30);
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _baseProductCtrl.dispose();
    _ingredientsCtrl.dispose();
    _bioConceptCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _saveInnovationIdea() {
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan nama produk dan deskripsi idemu!'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final newIdea = InnovationIdea(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      baseProduct: _baseProductCtrl.text.trim(),
      ingredients: _ingredientsCtrl.text.trim(),
      bioConcept: _bioConceptCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    ref.read(userProgressProvider.notifier).addInnovationIdea(newIdea);

    _titleCtrl.clear();
    _ingredientsCtrl.clear();
    _bioConceptCtrl.clear();
    _descCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Ide kreasi inovasimu berhasil ditambahkan ke Idea Pad! (+75 XP)'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userIdeas = ref.watch(userProgressProvider).innovationIdeas;

    return EthnoScaffold(
      title: 'Galeri Inovasi Pangan',
      subtitle: 'Slide Tambahan • Food Innovation Pad',
      currentSlide: 11,
      totalSlides: 12,
      prevRoute: '/evaluasi-kearifan',
      nextRoute: '/literasi-sains-quiz',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inovasi Pangan Berkelanjutan',
                            style: AppTextStyles.h3
                                .copyWith(color: Colors.white, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          'Transformasi makanan tradisional fermentasi menjadi kuliner modern bernilai ekonomi tinggi.',
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

            // Section 1: Preset Inspirations
            Text('1. Inspirasi Produk Inovasi Modern',
                style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 10),

            ..._presetInnovations.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: EthnoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'] as IconData,
                                color: item['color'] as Color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'] as String,
                                    style: AppTextStyles.bodyBold.copyWith(
                                        fontSize: 13,
                                        color: AppColors.primaryDark)),
                                Text('Basis: ${item['base']}',
                                    style: AppTextStyles.tagText.copyWith(
                                        color: AppColors.warmTerracotta,
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item['concept'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text('Bahan: ${item['ingredients']}',
                          style: AppTextStyles.bodySmall.copyWith(
                              fontStyle: FontStyle.italic, fontSize: 11)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 2: Student Submission Form
            Text('2. Student Idea Pad: Tuliskan Kreasi Inovasimu',
                style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 8),

            EthnoCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.warmCream.withValues(alpha: 0.4),
              borderColor: AppColors.goldenYellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Produk Inovasi:', style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Gelato Peuyeum Madu Alami',
                      prefixIcon: Icon(Icons.drive_file_rename_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Basis Bahan Fermentasi:',
                      style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _baseProductCtrl.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: [
                      'Tempe',
                      'Tape Singkong',
                      'Tape Ketan',
                      'Tauco',
                      'Kecap',
                      'Oncom'
                    ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _baseProductCtrl.text = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text('Konsep Bioteknologi & Keunggulan:',
                      style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _bioConceptCtrl,
                    decoration: const InputDecoration(
                      hintText:
                          'Misal: Pemanfaatan asam amino alami sebagai flavor enhancer...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Deskripsi & Rencana Pembuatan:',
                      style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Jelaskan cara membuat dan target penikmat produkmu...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Simpan Ide Inovasi (+75 XP)',
                    icon: Icons.bookmark_add_rounded,
                    isFullWidth: true,
                    backgroundColor: AppColors.primaryGreen,
                    onPressed: _saveInnovationIdea,
                  ),
                ],
              ),
            ),

            if (userIdeas.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Daftar Idemu (${userIdeas.length}):',
                  style: AppTextStyles.h2.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              ...userIdeas.map((idea) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: EthnoCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: AppColors.primaryGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(idea.title,
                                style: AppTextStyles.bodyBold.copyWith(
                                    fontSize: 13,
                                    color: AppColors.primaryDark)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.sageLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(idea.baseProduct,
                                  style: AppTextStyles.tagText.copyWith(
                                      color: AppColors.primaryDark,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(idea.description, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
