import '../../app_state.dart';
import '../../models/mcq.dart';
import 'quiz_state.dart';

class PageData {
  final int position;
  final List<MCQ>? mcqs;

  PageData(this.position, this.mcqs);
}

PageData getPageData(AppState state) {
  final quiz = state.quiz;
  return PageData(quiz.currentMcqIndex, quiz.mcqs);
}

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
