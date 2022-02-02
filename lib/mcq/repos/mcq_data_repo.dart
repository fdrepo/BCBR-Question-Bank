import '../mcq.dart';

abstract class MCQDataRepo {
  Future<List<MCQ>> getMCQs();
}
