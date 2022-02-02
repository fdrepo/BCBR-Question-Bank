import 'package:fd_bcbr/csv_mcq_data_repo.dart';
import 'package:fd_bcbr/mcq_data_repo.dart';
import 'mcq.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class MCQState {}

class MCQLoading extends MCQState {}

class MCQLoadedList extends MCQState {
  final List<String> tags;
  final List<MCQ> mcqs;

  MCQLoadedList(this.tags, this.mcqs);
}

class MCQProvider extends StateNotifier<MCQState> {
  MCQProvider() : super(MCQLoading()) {
    _loadMCQs();
  }

  Future<void> _loadMCQs() async {
    final mcqs = await repo.getMCQs();

    final tagsSet = <String>{};
    for (final mcq in mcqs) {
      tagsSet.addAll(mcq.categoricalTags);
    }

    final tags = tagsSet.toList();
    state = MCQLoadedList(tags, mcqs);
  }

  MCQDataRepo repo = CsvMcqDataRepo();
}
