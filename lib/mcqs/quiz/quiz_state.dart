import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/mcq.dart';

part 'quiz_state.freezed.dart';
part 'quiz_state.g.dart';

enum QuizStatus { initial, correct, incorrect, complete }

@freezed
class QuizState with _$QuizState {
  const QuizState._();

  const factory QuizState({
    required String? tag,
    required List<MCQ>? mcqs,
    required int currentMcqIndex,
    required List<int> correctlyAnsweredMcqIndices,
    required List<int> incorrectlyAnsweredMcqIndices,
    required List<String> selectedAnswers,
    required QuizStatus status,
  }) = _QuizState;

  factory QuizState.initial() => const QuizState(
        tag: null,
        mcqs: null,
        currentMcqIndex: 0,
        correctlyAnsweredMcqIndices: [],
        incorrectlyAnsweredMcqIndices: [],
        selectedAnswers: [],
        status: QuizStatus.initial,
      );

  bool get isAnswered =>
      status == QuizStatus.correct || status == QuizStatus.incorrect;

  bool get isCompleted => status == QuizStatus.complete;

  bool get allMcqsAnswered {
    final mcqs = this.mcqs;
    return mcqs != null &&
        mcqs.length ==
            correctlyAnsweredMcqIndices.length +
                incorrectlyAnsweredMcqIndices.length;
  }

  MCQ? get currentMcq {
    final mcqs = this.mcqs;
    if (mcqs != null && currentMcqIndex < mcqs.length) {
      return mcqs[currentMcqIndex];
    }
  }

  factory QuizState.fromJson(Map<String, dynamic> json) =>
      _$QuizStateFromJson(json);
}
