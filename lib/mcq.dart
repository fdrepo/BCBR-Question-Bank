class MCQ {
  final String questionNumber;
  final List<String> categoricalTags;
  final String question;
  final List<String> correctAnswers;
  final List<String> wrongAnswers;

  MCQ({
    required this.questionNumber,
    required this.categoricalTags,
    required this.question,
    required this.correctAnswers,
    required this.wrongAnswers,
  });
}
// Correct option , Wrong question 
// 2 types of choice question ( Multiple correct answers , 1 correct answer ) 
// List of Correct Answers and List of Wrong Answers 
// 1 correct - auto next
// >1 correct - next button 