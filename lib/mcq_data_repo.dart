import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mcq.dart';

abstract class MCQDataRepo {
  Future<List<MCQ>> getMCQs();
}
