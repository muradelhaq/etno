enum PisaCompetency {
  identifyScientificIssues,
  explainPhenomenaScientifically,
  useScientificEvidence,
}

class PisaQuestionOption {
  final String text;
  final bool isCorrect;
  final String justification;

  const PisaQuestionOption({
    required this.text,
    required this.isCorrect,
    required this.justification,
  });
}

class PisaQuestionModel {
  final int id;
  final String title;
  final PisaCompetency competency;
  final String competencyLabel;
  final String scenarioContext;
  final String questionText;
  final String? tableDataSummary;
  final String? imageAsset;
  final List<PisaQuestionOption> options;
  final int correctOptionIndex;
  final String scientificExplanation;
  final String hint;

  const PisaQuestionModel({
    required this.id,
    required this.title,
    required this.competency,
    required this.competencyLabel,
    required this.scenarioContext,
    required this.questionText,
    this.tableDataSummary,
    this.imageAsset,
    required this.options,
    required this.correctOptionIndex,
    required this.scientificExplanation,
    required this.hint,
  });
}
