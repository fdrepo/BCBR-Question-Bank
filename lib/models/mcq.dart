import 'package:freezed_annotation/freezed_annotation.dart';

part 'mcq.freezed.dart';
part 'mcq.g.dart';

@freezed
class MCQ with _$MCQ {
  MCQ._();

  factory MCQ({
    required String questionNumber,
    required List<String> categoricalTags,
    required String question,
    required List<String> correctAnswers,
    required List<String> wrongAnswers,
  }) = _MCQ;

  late final allAnswers = [...correctAnswers, ...wrongAnswers]..shuffle();

  bool get isMultipleChoice => correctAnswers.length > 1;

  factory MCQ.fromJson(Map<String, dynamic> json) => _$MCQFromJson(json);
}
// List of Correct option , List of Wrong question 
  // UI have 2 scenario in MCQ 
    // 1 correct - auto next question
    // > 1 correct - next button 
