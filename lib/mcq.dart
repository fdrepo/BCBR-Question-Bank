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
// List of Correct option , List of Wrong question 
  // UI have 2 scenario in MCQ 
    // 1 correct - auto next question
    // > 1 correct - next button 

    