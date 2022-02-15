import '../../models/mcq.dart';

abstract class McqDataRepo {
  Future<Set<String>> getTags();
  Future<List<MCQ>> getMcqs(String tag, int count);
}
