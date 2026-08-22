class StepProcessModel {
  final int stepNumber;
  final String title;
  final String description;
  final String biologicalContext;
  final String? tip;

  const StepProcessModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.biologicalContext,
    this.tip,
  });
}

class CaseStudyModel {
  final String title;
  final String storyContext;
  final String researchQuestion;
  final String manipulatedVariable;
  final String respondingVariable;
  final String controlledVariables;
  final String hypothesisHint;
  final String scientificExplanation;

  const CaseStudyModel({
    required this.title,
    required this.storyContext,
    required this.researchQuestion,
    required this.manipulatedVariable,
    required this.respondingVariable,
    required this.controlledVariables,
    required this.hypothesisHint,
    required this.scientificExplanation,
  });
}

class FermentedFoodEntity {
  final String id;
  final String name;
  final String localName;
  final String region;
  final String rawMaterial;
  final String heroImage;
  final List<String> microorganisms;
  final List<String> traditionalDishes;
  final List<StepProcessModel> processSteps;
  final String localWisdom;
  final String ethnoscienceConcept;
  final String modernScienceValue;
  final CaseStudyModel caseStudy;

  const FermentedFoodEntity({
    required this.id,
    required this.name,
    required this.localName,
    required this.region,
    required this.rawMaterial,
    required this.heroImage,
    required this.microorganisms,
    required this.traditionalDishes,
    required this.processSteps,
    required this.localWisdom,
    required this.ethnoscienceConcept,
    required this.modernScienceValue,
    required this.caseStudy,
  });
}
