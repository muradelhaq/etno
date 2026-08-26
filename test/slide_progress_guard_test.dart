import 'package:e_modul_etnosains/shared/models/user_progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('slide stays locked until read and its required answer is saved', () {
    final unread = UserProgressModel();
    expect(unread.canProceedFromSlide(2), isFalse);

    final readOnly = unread.copyWith(readSlides: {1, 2});
    expect(readOnly.canProceedFromSlide(1), isTrue);
    expect(readOnly.canProceedFromSlide(2), isFalse);
    expect(readOnly.highestUnlockedSlide, 2);

    final answered = readOnly.copyWith(
      apersepsiReflection: 'Fermentasi perlu dilestarikan.',
    );
    expect(answered.canProceedFromSlide(2), isTrue);
    expect(answered.highestUnlockedSlide, 3);
  });

  test('case study, lab, and assessment remain mandatory', () {
    final progress = UserProgressModel(
      readSlides: {4, 10, 11, 12},
    );

    expect(progress.canProceedFromSlide(4), isFalse);
    expect(progress.canProceedFromSlide(10), isFalse);
    expect(progress.canProceedFromSlide(11), isTrue);
    expect(progress.canProceedFromSlide(12), isFalse);

    final completed = progress.copyWith(
      caseStudyAnswers: {'tempe': 'Hipotesis siswa'},
      completedModules: {
        'virtual_lab',
        'virtual_lab_game',
        'challenge',
        'cultural_assessment',
      },
    );
    expect(completed.canProceedFromSlide(4), isTrue);
    expect(completed.canProceedFromSlide(10), isTrue);
    expect(completed.canProceedFromSlide(11), isTrue);
    expect(completed.canProceedFromSlide(12), isTrue);
  });
}
