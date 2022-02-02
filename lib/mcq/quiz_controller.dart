import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mcq.dart';
import 'quiz_state.dart';

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, QuizState>(
  (ref) => QuizController(),
);

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());

  void submitAnswer(MCQ currentQuestion, String answer) {
    if (state.answered) return;
    if (currentQuestion.correctAnswers.contains(answer)) {
      state = state.copyWith(
        selectedAnswer: state.selectedAnswer.toList()..add(answer),
        correct: state.correct.toList()..add(currentQuestion),
        status: currentQuestion.correctAnswers.length == 1
            ? QuizStatus.correct
            : QuizStatus.initial,
      );
    } else {
      state = state.copyWith(
        selectedAnswer: state.selectedAnswer.toList()..add(answer),
        incorrect: state.incorrect.toList()..add(currentQuestion),
        status: currentQuestion.correctAnswers.length == 1
            ? QuizStatus.incorrect
            : QuizStatus.initial,
      );
    }
  }

  void nextQuestion(List<MCQ> questions, int currentIndex) {
    state = state.copyWith(
      selectedAnswer: [],
      status: currentIndex + 1 < questions.length
          ? QuizStatus.initial
          : QuizStatus.complete,
    );
  }

  void reset() {
    state = QuizState.initial();
  }
}
