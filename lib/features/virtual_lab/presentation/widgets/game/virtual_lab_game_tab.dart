import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class VirtualLabGameTab extends ConsumerStatefulWidget {
  const VirtualLabGameTab({super.key});

  @override
  ConsumerState<VirtualLabGameTab> createState() => _VirtualLabGameTabState();
}

class _VirtualLabGameTabState extends ConsumerState<VirtualLabGameTab> {
  int _gameScore = 0;
  final Set<String> _scoredItems = {};

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

  static const Map<String, String> _microbeClues = {
    'Rhizopus oligosporus':
        'Membentuk jaring miselium/hifa putih padat yang mengikat kedelai menjadi tempe.',
    'Saccharomyces cerevisiae':
        'Khamir yang memfermentasi gula menjadi alkohol dan aroma harum manis khas tape.',
    'Aspergillus oryzae':
        'Kapang koji yang menguraikan protein kedelai menjadi asam glutamat gurih (umami) tauco.',
  };

  static const List<String> _foodProducts = [
    'Tempe Kedelai',
    'Tape Singkong',
    'Tauco Cianjur',
  ];

  final Map<String, String?> _imageAnswers = {
    'rhizopus': null,
    'saccharomyces': null,
    'neurospora': null,
  };

  static const List<String> _imageOptionIds = [
    'rhizopus',
    'saccharomyces',
    'aspergillus_oryzae',
    'neurospora',
  ];

  static const Map<String, String> _microbeImageClues = {
    'rhizopus':
        'Hifa senositik (tanpa sekat) dengan sporangiofor tegak dan sporangium bulat kehitaman.',
    'saccharomyces':
        'Sel ragi uniseluler oval/bulat telur bereproduksi vegetatif dengan tunas (budding).',
    'neurospora':
        'Miselium cepat tumbuh berwarna jingga kemerahan dengan rantai makrokonidia.',
  };

  MicroorganismModel _microbe(String id) =>
      MicroorganismData.microbes.firstWhere((microbe) => microbe.id == id);

  int get _missionOneCorrectCount => _microbeMatches.entries
      .where((entry) => entry.value == _correctMicrobe[entry.key])
      .length;

  int get _missionTwoCorrectCount => _imageAnswers.entries
      .where((entry) => entry.value == entry.key)
      .length;

  bool get _missionOneComplete =>
      _missionOneCorrectCount == _microbeMatches.length;

  bool get _missionTwoComplete =>
      _missionTwoCorrectCount == _imageAnswers.length;

  bool get _allMissionsComplete =>
      _missionOneComplete && _missionTwoComplete;

  void _onSelectProduct(String microbe, String product) {
    setState(() {
      _microbeMatches[microbe] = product;
      if (product == _correctMicrobe[microbe]) {
        if (_scoredItems.add('microbe:$microbe')) {
          _gameScore += 30;
        }
      }
    });
  }

  void _onSelectImage(String targetId, String optionId) {
    setState(() {
      _imageAnswers[targetId] = optionId;
      if (optionId == targetId) {
        if (_scoredItems.add('image:$targetId')) {
          _gameScore += 30;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(userProgressProvider);
    final alreadySaved =
        progress.completedModules.contains('virtual_lab_game');
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 700 || isLandscape;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 24 : 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Modern Gamified Header
          _buildScoreHeader(alreadySaved),

          const SizedBox(height: 18),

          // 2. Misi 1 Section
          _buildMissionHeader(
            missionNumber: 1,
            title: 'Pasangkan Mikroba dengan Produk Fermentasi',
            subtitle:
                'Cocokkan setiap spesies mikroorganisme dengan produk olahan pangan tradisional Sunda yang tepat.',
            progressText: '$_missionOneCorrectCount / 3 Selesai',
            isComplete: _missionOneComplete,
          ),
          const SizedBox(height: 12),

          // Responsive Misi 1 Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final useMultiColumn = constraints.maxWidth >= 720;
              if (useMultiColumn) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _microbeMatches.keys.map((microbe) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: _buildMisi1Card(microbe),
                      ),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: _microbeMatches.keys
                    .map((microbe) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildMisi1Card(microbe),
                        ))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 22),

          // 3. Misi 2 Section
          _buildMissionHeader(
            missionNumber: 2,
            title: 'Tebak Gambar Mikroskop Mikroorganisme',
            subtitle:
                'Analisis ciri visual mikroskopik dan pilih gambar mikroskop yang tepat sesuai nama mikroba.',
            progressText: '$_missionTwoCorrectCount / 3 Selesai',
            isComplete: _missionTwoComplete,
          ),
          const SizedBox(height: 12),

          // Misi 2 Image Questions
          ..._imageAnswers.keys.map((targetId) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildMisi2Card(targetId, isWide: isWide),
            );
          }),

          const SizedBox(height: 10),

          // 4. Completion Summary & Save Action Button
          _buildSaveActionSection(alreadySaved),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildScoreHeader(bool alreadySaved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmTerracotta.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Interaktif Misi Sains',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Raih hingga 180 XP dengan menyelesaikan kedua tantangan bioteknologi etnosains!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech_rounded,
                        color: AppColors.goldenYellow, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      '$_gameScore XP',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress Chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildHeaderBadge(
                label: 'Misi 1: $_missionOneCorrectCount/3 Pasangan',
                isComplete: _missionOneComplete,
                icon: _missionOneComplete
                    ? Icons.check_circle_rounded
                    : Icons.cached_rounded,
              ),
              _buildHeaderBadge(
                label: 'Misi 2: $_missionTwoCorrectCount/3 Gambar',
                isComplete: _missionTwoComplete,
                icon: _missionTwoComplete
                    ? Icons.check_circle_rounded
                    : Icons.image_search_rounded,
              ),
              if (alreadySaved)
                _buildHeaderBadge(
                  label: 'Tersimpan di Profil',
                  isComplete: true,
                  icon: Icons.cloud_done_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge({
    required String label,
    required bool isComplete,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.primaryGreen.withValues(alpha: 0.85)
            : Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isComplete ? Colors.white60 : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionHeader({
    required int missionNumber,
    required String title,
    required String subtitle,
    required String progressText,
    required bool isComplete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.primaryGreen
                : AppColors.primaryDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Misi $missionNumber',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h2.copyWith(fontSize: 14.5),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.successGreen.withValues(alpha: 0.15)
                : AppColors.sageLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isComplete
                  ? AppColors.successGreen
                  : AppColors.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : Icons.hourglass_empty_rounded,
                size: 13,
                color: isComplete
                    ? AppColors.successGreen
                    : AppColors.primaryDark,
              ),
              const SizedBox(width: 4),
              Text(
                progressText,
                style: TextStyle(
                  color: isComplete
                      ? AppColors.successGreen
                      : AppColors.primaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMisi1Card(String microbe) {
    final selected = _microbeMatches[microbe];
    final isCorrect = selected == _correctMicrobe[microbe];
    final hasAnswered = selected != null;
    final clue = _microbeClues[microbe] ?? '';

    return EthnoCard(
      padding: const EdgeInsets.all(14),
      borderColor: hasAnswered
          ? (isCorrect ? AppColors.successGreen : AppColors.errorRed)
          : AppColors.borderSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of Question
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔬 ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  microbe,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _buildStatusPill(
                hasAnswered: hasAnswered,
                isCorrect: isCorrect,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Pasangan produk pangan olahan:',
            style: AppTextStyles.tagText.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),

          // Options as clean styled selectable cards
          Column(
            children: _foodProducts.map((prod) {
              final isThisSelected = selected == prod;
              final isThisTheCorrectOne = prod == _correctMicrobe[microbe];

              Color bgColor = Colors.white;
              Color borderColor = AppColors.borderSubtle;
              Color textColor = AppColors.textPrimary;
              IconData trailingIcon = Icons.radio_button_unchecked_rounded;
              Color iconColor = AppColors.textSecondary.withValues(alpha: 0.5);

              if (isThisSelected) {
                if (isCorrect) {
                  bgColor = const Color(0xFFE8F5E9);
                  borderColor = AppColors.successGreen;
                  textColor = AppColors.primaryDark;
                  trailingIcon = Icons.check_circle_rounded;
                  iconColor = AppColors.successGreen;
                } else {
                  bgColor = const Color(0xFFFFEBEE);
                  borderColor = AppColors.errorRed;
                  textColor = AppColors.terracottaDark;
                  trailingIcon = Icons.cancel_rounded;
                  iconColor = AppColors.errorRed;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Material(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _onSelectProduct(microbe, prod),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                          width: isThisSelected ? 1.6 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isThisTheCorrectOne && isCorrect
                                ? Icons.verified_rounded
                                : Icons.eco_outlined,
                            size: 16,
                            color: isThisSelected
                                ? iconColor
                                : AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              prod,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isThisSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          Icon(trailingIcon, size: 18, color: iconColor),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Feedback clue / explanation box
          if (hasAnswered) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.primaryLight.withValues(alpha: 0.15)
                    : AppColors.warmCream,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCorrect
                      ? AppColors.primaryGreen.withValues(alpha: 0.4)
                      : AppColors.goldenYellow.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isCorrect
                        ? Icons.lightbulb_rounded
                        : Icons.info_outline_rounded,
                    size: 15,
                    color: isCorrect
                        ? AppColors.primaryDark
                        : AppColors.terracottaDark,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isCorrect
                          ? 'Tepat (+30 XP)! $clue'
                          : 'Belum tepat. Coba telaah: $clue',
                      style: TextStyle(
                        fontSize: 11,
                        color: isCorrect
                            ? AppColors.primaryDark
                            : AppColors.terracottaDark,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMisi2Card(String targetId, {required bool isWide}) {
    final target = _microbe(targetId);
    final selected = _imageAnswers[targetId];
    final isCorrect = selected == targetId;
    final hasAnswered = selected != null;
    final clue = _microbeImageClues[targetId] ?? target.microscopicFeature;

    return EthnoCard(
      padding: const EdgeInsets.all(14),
      borderColor: hasAnswered
          ? (isCorrect ? AppColors.successGreen : AppColors.errorRed)
          : AppColors.borderSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.sageLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            target.kingdomType,
                            style: AppTextStyles.tagText.copyWith(
                              fontSize: 10,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      target.scientificName,
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 13.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusPill(
                hasAnswered: hasAnswered,
                isCorrect: isCorrect,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Microscopic Clue
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warmCream.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.goldenYellow.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.remove_red_eye_outlined,
                    size: 14, color: AppColors.terracottaDark),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Ciri Mikroskopik: $clue',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.terracottaDark,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Options Grid (4 columns in landscape/wide, 2 in narrow portrait)
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isWide ? 1.05 : 1.25,
            children: _imageOptionIds.asMap().entries.map((entry) {
              final index = entry.key;
              final optionId = entry.value;
              final option = _microbe(optionId);
              final isSelected = selected == optionId;
              final isOptionCorrect = optionId == targetId;
              final optionLetter = String.fromCharCode(65 + index); // A, B, C, D

              Color borderColor = AppColors.borderSubtle;
              double borderWidth = 1.0;
              if (isSelected) {
                borderWidth = 2.4;
                borderColor = isOptionCorrect
                    ? AppColors.successGreen
                    : AppColors.errorRed;
              }

              return InkWell(
                onTap: () => _onSelectImage(targetId, optionId),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: isOptionCorrect
                                  ? AppColors.successGreen.withValues(alpha: 0.3)
                                  : AppColors.errorRed.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Microscope Image
                      AppImage(
                        option.afterZoomImage,
                        fit: BoxFit.cover,
                      ),

                      // Top-left option letter badge (A, B, C, D)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Text(
                            'Pilihan $optionLetter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Top-right Selection Feedback Badge
                      if (isSelected)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isOptionCorrect
                                  ? AppColors.successGreen
                                  : AppColors.errorRed,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              isOptionCorrect
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // Bottom label when answered correctly
                      if (isSelected && isOptionCorrect)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            color: AppColors.successGreen.withValues(alpha: 0.9),
                            child: Text(
                              'Benar: ${option.scientificName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill({
    required bool hasAnswered,
    required bool isCorrect,
  }) {
    if (!hasAnswered) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'Belum dijawab',
          style: TextStyle(
            fontSize: 10.5,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (isCorrect) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.successGreen),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded,
                size: 13, color: AppColors.successGreen),
            SizedBox(width: 4),
            Text(
              'Tepat!',
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.errorRed),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel_rounded, size: 13, color: AppColors.errorRed),
          SizedBox(width: 4),
          Text(
            'Kurang tepat',
            style: TextStyle(
              fontSize: 10.5,
              color: AppColors.errorRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveActionSection(bool alreadySaved) {
    if (_allMissionsComplete) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.successGreen, width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded,
                    color: AppColors.goldenYellow, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat! Semua Misi Sains Berhasil!',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kamu telah menyelesaikan seluruh pasangan mikroba dan tebak gambar dengan total skor $_gameScore XP.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            text: alreadySaved
                ? 'Perbarui Poin Game di Profil ($_gameScore XP)'
                : 'Simpan Poin Game & Klaim Hadiah ($_gameScore XP)',
            icon: Icons.check_circle_outline_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () {
              ref.read(userProgressProvider.notifier).markModuleCompleted(
                    'virtual_lab_game',
                    xpBonus: _gameScore,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: AppColors.goldenYellow, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Poin game ($_gameScore XP) berhasil tersimpan di profil belajarmu!',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
          ),
        ],
      );
    }

    final remainingMisi1 = _microbeMatches.length - _missionOneCorrectCount;
    final remainingMisi2 = _imageAnswers.length - _missionTwoCorrectCount;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.warmCream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.goldenYellow),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.terracottaDark, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sisa target: $remainingMisi1 pasangan Misi 1 & $remainingMisi2 gambar Misi 2 untuk membuka tombol simpan skor.',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: AppColors.terracottaDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Selesaikan Semua Misi Terlebih Dahulu',
          icon: Icons.lock_outline_rounded,
          isFullWidth: true,
          backgroundColor: Colors.grey.shade400,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Selesaikan semua pasangan Misi 1 dan tebak gambar Misi 2 dengan tepat terlebih dahulu.',
                ),
                backgroundColor: AppColors.warmTerracotta,
              ),
            );
          },
        ),
      ],
    );
  }
}

