import '../../app_state.dart';
import '../../models/mcq.dart';

List<MCQ>? mcqs(AppState state) {
  return state.quiz.mcqs;
}

String? nextPageTitle(AppState state) {
  final quiz = state.quiz;
  if (quiz.isCompleted) {
    return 'Show Results';
  } else if (quiz.isAnswered) {
    return 'Next Question';
  }
}
