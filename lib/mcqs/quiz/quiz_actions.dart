import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/mcq.dart';

part 'quiz_actions.freezed.dart';

@freezed
class QuizActions with _$QuizActions {
  const factory QuizActions.loadMcqs(String tag) = QuizActionsLoadMcqs;
  const factory QuizActions.loadingMcqs() = QuizActionsLoadingMcqs;
  const factory QuizActions.loadedMcqs(String tag, List<MCQ> mcqs) =
      QuizActionsLoadedMcqs;

  const factory QuizActions.select(String answer) = QuizActionsSelect;
  const factory QuizActions.submit() = QuizActionsSubmit;
  const factory QuizActions.nextMcq() = QuizActionsNextMcq;
}
