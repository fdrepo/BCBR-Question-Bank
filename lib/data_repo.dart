import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'mcq.dart';

//DI class
abstract class MCQDataRepo {
  ProviderRef ref;

  MCQDataRepo(this.ref);

  List<MCQ> getQuestions();
}
