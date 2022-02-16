import '../app_state/app_state.dart';

enum NextPageStatus { notShown, submit, nextQuestion, showResult }

NextPageStatus getNextPageStatus(AppState state) {
  final quiz = state.quiz;

  final currentMcq = quiz.currentMcq;
  if (currentMcq != null) {
    if (quiz.isAnswered) {
      if (quiz.allMcqsAnswered) {
        return NextPageStatus.showResult;
      } else {
        return NextPageStatus.nextQuestion;
      }
    } else if (currentMcq.isMultipleChoice) {
      return NextPageStatus.submit;
    }
  }

  return NextPageStatus.notShown;
}

enum AnswerStatus { selected, correct, incorrect }

Map<String, AnswerStatus> getAnswerStatus(QuizState quiz) {
  final currentMcq = quiz.currentMcq;
  if (currentMcq == null) {
    return {};
  }

  final res = <String, AnswerStatus>{};
  if (quiz.isAnswered) {
    for (final ans in quiz.selectedAnswers) {
      res[ans] = currentMcq.correctAnswers.contains(ans)
          ? AnswerStatus.correct
          : AnswerStatus.incorrect;
    }
  } else {
    for (final ans in quiz.selectedAnswers) {
      res[ans] = AnswerStatus.selected;
    }
  }

  return res;
}
