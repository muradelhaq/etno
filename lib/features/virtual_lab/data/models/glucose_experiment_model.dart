class GlucoseExperimentPoint {
  final double yeastPercent;
  final int day;
  final double glucoseLevel; // in %
  final double alcoholEst; // estimated %
  final String tasteProfile;
  final String textureProfile;
  final String aromaProfile;
  final int organolepticRating; // 1 to 5 stars

  const GlucoseExperimentPoint({
    required this.yeastPercent,
    required this.day,
    required this.glucoseLevel,
    required this.alcoholEst,
    required this.tasteProfile,
    required this.textureProfile,
    required this.aromaProfile,
    required this.organolepticRating,
  });
}

class GlucoseLabEngine {
  // Real research database from empirical findings
  static const Map<String, GlucoseExperimentPoint> _database = {
    // 0.5% Yeast
    '0.5_1': GlucoseExperimentPoint(
      yeastPercent: 0.5,
      day: 1,
      glucoseLevel: 28.86,
      alcoholEst: 0.2,
      tasteProfile: 'Agak manis, masih dominan rasa tawar singkong',
      textureProfile: 'Agak keras, belum merata melunak',
      aromaProfile: 'Aroma khas singkong kukus, sedikit wangi ragi',
      organolepticRating: 2,
    ),
    '0.5_2': GlucoseExperimentPoint(
      yeastPercent: 0.5,
      day: 2,
      glucoseLevel: 41.25,
      alcoholEst: 0.8,
      tasteProfile: 'Manis sedang, asam sangat tipis',
      textureProfile: 'Kenyal lunak cukup rata',
      aromaProfile: 'Harum khas tape singkong segar',
      organolepticRating: 4,
    ),
    '0.5_3': GlucoseExperimentPoint(
      yeastPercent: 0.5,
      day: 3,
      glucoseLevel: 41.14,
      alcoholEst: 1.6,
      tasteProfile: 'Manis bercampur rasa asam dan hangat alkohol',
      textureProfile: 'Lunak berair',
      aromaProfile: 'Aroma alkohol mulai terasa jelas',
      organolepticRating: 4,
    ),
    '0.5_4': GlucoseExperimentPoint(
      yeastPercent: 0.5,
      day: 4,
      glucoseLevel: 34.20,
      alcoholEst: 2.8,
      tasteProfile: 'Rasa manis berkurang, dominan alkohol dan asam',
      textureProfile: 'Sangat lunak dan banyak cairan',
      aromaProfile: 'Aroma tape menyengat beralkohol',
      organolepticRating: 3,
    ),
    '0.5_5': GlucoseExperimentPoint(
      yeastPercent: 0.5,
      day: 5,
      glucoseLevel: 25.80,
      alcoholEst: 4.2,
      tasteProfile: 'Masam menyengat mirip cuka, rasa manis tipis',
      textureProfile: 'Hancur berair pekat',
      aromaProfile: 'Menyengat alkohol dan asam asetat',
      organolepticRating: 1,
    ),

    // 1.0% Yeast (OPTIMAL AT DAY 2)
    '1.0_1': GlucoseExperimentPoint(
      yeastPercent: 1.0,
      day: 1,
      glucoseLevel: 27.94,
      alcoholEst: 0.3,
      tasteProfile: 'Mulai manis di bagian permukaan',
      textureProfile: 'Mulai lembut di bagian luar, tengah masih agak padat',
      aromaProfile: 'Wangi khas ragi aktif',
      organolepticRating: 3,
    ),
    '1.0_2': GlucoseExperimentPoint(
      yeastPercent: 1.0,
      day: 2,
      glucoseLevel: 51.61, // Puncak Kemanisan & Mutu Tertinggi (>51.14%)
      alcoholEst: 1.1,
      tasteProfile: 'Sangat manis legit optimal, segar, keasaman sangat pas',
      textureProfile: 'Sangat lembut, pulen, dan tidak berair berlebih',
      aromaProfile: 'Sangat harum aromatik khas tape bermutu tinggi',
      organolepticRating: 5,
    ),
    '1.0_3': GlucoseExperimentPoint(
      yeastPercent: 1.0,
      day: 3,
      glucoseLevel: 41.71,
      alcoholEst: 2.4,
      tasteProfile: 'Manis berkurang, rasa hangat alkohol meningkat',
      textureProfile: 'Lunak dan mulai basah mengeluarkan cairan',
      aromaProfile: 'Aroma alkohol khas peuyeum matang',
      organolepticRating: 4,
    ),
    '1.0_4': GlucoseExperimentPoint(
      yeastPercent: 1.0,
      day: 4,
      glucoseLevel: 31.50,
      alcoholEst: 3.9,
      tasteProfile: 'Rasa agak pahit alkohol dan asam',
      textureProfile: 'Sangat lunak dan lembek',
      aromaProfile: 'Aroma tape tua beralkohol',
      organolepticRating: 2,
    ),
    '1.0_5': GlucoseExperimentPoint(
      yeastPercent: 1.0,
      day: 5,
      glucoseLevel: 21.30,
      alcoholEst: 5.4,
      tasteProfile: 'Masam tajam dan pahit alkohol pekat',
      textureProfile: 'Hancur berbusa',
      aromaProfile: 'Menyengat bau alkohol keras',
      organolepticRating: 1,
    ),

    // 1.5% Yeast
    '1.5_1': GlucoseExperimentPoint(
      yeastPercent: 1.5,
      day: 1,
      glucoseLevel: 24.48,
      alcoholEst: 0.4,
      tasteProfile: 'Sedikit manis, tertutup aroma ragi yang pekat',
      textureProfile: 'Bagian luar cepat lembek karena banyak ragi',
      aromaProfile: 'Aroma ragi sangat menyengat',
      organolepticRating: 2,
    ),
    '1.5_2': GlucoseExperimentPoint(
      yeastPercent: 1.5,
      day: 2,
      glucoseLevel: 41.81,
      alcoholEst: 1.5,
      tasteProfile: 'Manis sedang, sensasi alkohol cepat muncul',
      textureProfile: 'Lunak dan basah',
      aromaProfile: 'Harum tape beralkohol cukup tajam',
      organolepticRating: 4,
    ),
    '1.5_3': GlucoseExperimentPoint(
      yeastPercent: 1.5,
      day: 3,
      glucoseLevel: 43.92,
      alcoholEst: 3.1,
      tasteProfile: 'Manis pekat bercampur alkohol kuat',
      textureProfile: 'Sangat lunak berair',
      aromaProfile: 'Aroma alkohol menusuk hidung',
      organolepticRating: 3,
    ),
    '1.5_4': GlucoseExperimentPoint(
      yeastPercent: 1.5,
      day: 4,
      glucoseLevel: 33.10,
      alcoholEst: 4.6,
      tasteProfile: 'Dominan asam dan pahit alkohol',
      textureProfile: 'Lembek hancur berair',
      aromaProfile: 'Menyengat bau tape tua',
      organolepticRating: 2,
    ),
    '1.5_5': GlucoseExperimentPoint(
      yeastPercent: 1.5,
      day: 5,
      glucoseLevel: 22.40,
      alcoholEst: 6.1,
      tasteProfile: 'Asam pekat seperti cuka fermentasi',
      textureProfile: 'Hancur berair',
      aromaProfile: 'Menyengat asam asetat dan alkohol tinggi',
      organolepticRating: 1,
    ),
  };

  static GlucoseExperimentPoint simulate(double yeast, int day, {bool isBananaLeaf = true}) {
    // normalize yeast to 0.5, 1.0, 1.5
    String yeastStr = '1.0';
    if (yeast <= 0.75) {
      yeastStr = '0.5';
    } else if (yeast >= 1.25) {
      yeastStr = '1.5';
    }

    int normDay = day.clamp(1, 5);
    final key = '${yeastStr}_$normDay';
    final fallback = _database['1.0_2'] ?? _database.values.first;
    final base = _database[key] ?? fallback;

    if (!isBananaLeaf) {
      // If plastic or open container, efficiency slightly decreases
      return GlucoseExperimentPoint(
        yeastPercent: base.yeastPercent,
        day: base.day,
        glucoseLevel: double.parse((base.glucoseLevel * 0.88).toStringAsFixed(2)),
        alcoholEst: double.parse((base.alcoholEst * 1.15).toStringAsFixed(2)),
        tasteProfile: '${base.tasteProfile} (Kualitas sedikit menurun karena sirkulasi plastik kurang alami)',
        textureProfile: '${base.textureProfile} (Lebih basah/lembab tertutup)',
        aromaProfile: base.aromaProfile,
        organolepticRating: (base.organolepticRating - 1).clamp(1, 5),
      );
    }

    return base;
  }

  static List<Map<String, dynamic>> getDayComparisonData(double yeast) {
    String yeastStr = '1.0';
    if (yeast <= 0.75) yeastStr = '0.5';
    if (yeast >= 1.25) yeastStr = '1.5';

    final fallback = _database['1.0_2'] ?? _database.values.first;

    return [1, 2, 3, 4, 5].map((d) {
      final pt = _database['${yeastStr}_$d'] ?? fallback;
      return {
        'day': d,
        'glucose': pt.glucoseLevel,
        'alcohol': pt.alcoholEst,
      };
    }).toList();
  }

}
