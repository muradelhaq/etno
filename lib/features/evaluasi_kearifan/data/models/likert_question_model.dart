class LikertQuestionModel {
  final int id;
  final String indicator;
  final String statement;
  final bool isFavorable; // true = positive statement, false = unfavorable

  const LikertQuestionModel({
    required this.id,
    required this.indicator,
    required this.statement,
    this.isFavorable = true,
  });
}

class CulturalAssessmentData {
  static const List<String> indicators = [
    'Identitas & Sejarah Kuliner',
    'Apresiasi Kearifan Etnosains',
    'Minat Konsumsi & Cita Rasa',
    'Motivasi Inovasi Pangan',
    'Komitmen Pelestarian Warisan',
  ];

  static const List<LikertQuestionModel> questions = [
    LikertQuestionModel(
      id: 1,
      indicator: 'Identitas & Sejarah Kuliner',
      statement: 'Saya bangga bahwa Indonesia memiliki ragam makanan fermentasi tradisional seperti tempe, peuyeum, tauco, dan oncom yang diakui dunia.',
    ),
    LikertQuestionModel(
      id: 2,
      indicator: 'Identitas & Sejarah Kuliner',
      statement: 'Saya tertarik mempelajari asal-usul istilah nama kuliner lokal seperti Colenak (dicocol enak) dan Combro (oncom di jero).',
    ),
    LikertQuestionModel(
      id: 3,
      indicator: 'Apresiasi Kearifan Etnosains',
      statement: 'Praktik tradisional seperti membungkus tempe dengan daun pisang dan menjemur tauco di tempayan memiliki dasar ilmiah yang logis dan cerdas.',
    ),
    LikertQuestionModel(
      id: 4,
      indicator: 'Apresiasi Kearifan Etnosains',
      statement: 'Pemanfaatan ampas tahu menjadi oncom merupakan wujud nyata kearifan lokal dalam menerapkan ekonomi sirkular ramah lingkungan.',
    ),
    LikertQuestionModel(
      id: 5,
      indicator: 'Minat Konsumsi & Cita Rasa',
      statement: 'Saya lebih memilih mencicipi kuliner tradisional berbahan fermentasi dibandingkan membeli makanan cepat saji impor secara berlebihan.',
    ),
    LikertQuestionModel(
      id: 6,
      indicator: 'Minat Konsumsi & Cita Rasa',
      statement: 'Makanan fermentasi tradisional Indonesia memiliki kandungan gizi mikroba (seperti vitamin B12 dan asam amino) yang sangat menyehatkan tubuh.',
    ),
    LikertQuestionModel(
      id: 7,
      indicator: 'Motivasi Inovasi Pangan',
      statement: 'Saya bersemangat untuk menciptakan kreasi kuliner kekinian berbahan dasar fermentasi lokal seperti burger tempe atau cheesecake peuyeum.',
    ),
    LikertQuestionModel(
      id: 8,
      indicator: 'Motivasi Inovasi Pangan',
      statement: 'Bioteknologi fermentasi tradisional memiliki potensi besar untuk dikembangkan menjadi produk industri kreatif bernilai ekonomi tinggi.',
    ),
    LikertQuestionModel(
      id: 9,
      indicator: 'Komitmen Pelestarian Warisan',
      statement: 'Saya bersedia mempromosikan makanan tradisional daerah melalui media sosial seperti video TikTok atau Instagram Reels.',
    ),
    LikertQuestionModel(
      id: 10,
      indicator: 'Komitmen Pelestarian Warisan',
      statement: 'Sebagai generasi muda, saya merasa bertanggung jawab menjaga keberlanjutan tradisi pembuatan makanan fermentasi khas daerah saya.',
    ),
  ];
}
