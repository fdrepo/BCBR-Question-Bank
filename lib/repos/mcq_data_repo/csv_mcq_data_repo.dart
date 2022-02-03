import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../../models/mcq.dart';
import 'mcq_data_repo.dart';

class CsvMcqDataRepo extends McqDataRepo {
  List<MCQ>? _mcqsCache;

  Future<List<MCQ>> _getMcqsFromCsv() async {
    final cache = _mcqsCache;
    if (cache != null) {
      return cache;
    }

    final rawCsvFile = await rootBundle.loadString('assets/data.csv');
    final csvData = const CsvToListConverter().convert(rawCsvFile);

    final mcqs = <MCQ>[];
    for (final row in csvData.sublist(1)) {
      final correctOption = row[7] as String;
      final correctAnswers = <String>[];
      final wrongAnswers = <String>[];
      for (int i = 3; i <= 6; i++) {
        final option = csvData[0][i];
        if (option == correctOption) {
          correctAnswers.add(row[i].toString());
        } else {
          wrongAnswers.add(row[i].toString());
        }
      }
      mcqs.add(
        MCQ(
          questionNumber: row[0].toString(),
          categoricalTags: [row[1]],
          question: row[2].toString(),
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
        ),
      );
    }

    return _mcqsCache = mcqs;
  }

  @override
  Future<Set<String>> getTags() async {
    final mcqs = await _getMcqsFromCsv();
    return mcqs.fold<Set<String>>({}, (res, mcq) {
      return res..addAll(mcq.categoricalTags);
    });
  }

  @override
  Future<List<MCQ>> getMcqs(String tag, int count) async {
    final mcqs = await _getMcqsFromCsv();
    return mcqs
        .where((mcq) => mcq.categoricalTags.contains(tag))
        .take(count)
        .toList();
  }
}
