import 'package:equatable/equatable.dart';

import 'mcq.dart';

enum QuizStatus { initial, correct, incorrect, complete }

class QuizState extends Equatable {
  final List<String> selectedAnswer;
  final List<MCQ> correct;
  final List<MCQ> incorrect;
  final QuizStatus status;

  bool get answered =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  const QuizState({
    required this.selectedAnswer,
    required this.correct,
    required this.incorrect,
    required this.status,
  });

  factory QuizState.initial() {
    return const QuizState(
      selectedAnswer: [],
      correct: [],
      incorrect: [],
      status: QuizStatus.initial,
    );
  }

  @override
  List<Object> get props => [
        selectedAnswer,
        correct,
        incorrect,
        status,
      ];

  QuizState copyWith({
    List<String>? selectedAnswer,
    List<MCQ>? correct,
    List<MCQ>? incorrect,
    QuizStatus? status,
  }) {
    return QuizState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      status: status ?? this.status,
    );
  }
}
