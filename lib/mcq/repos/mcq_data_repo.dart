import '../mcq.dart';

//DI class
abstract class MCQDataRepo {
  Future<List<MCQ>> getMCQs();
}
