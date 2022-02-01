import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'mcq.dart';
import 'mcq_data_repo.dart';

class CsvMcqDataRepo extends MCQDataRepo {
  @override
  Future<List<MCQ>> getMCQs() async {
    final rawData = await rootBundle.loadString('assets/data.csv');
    final csvData = const CsvToListConverter().convert(rawData);

    final mcqs = <MCQ>[];
    for (final row in csvData.sublist(1)) {
      final correctOption = row[7] as String;
      final correctAnswers = <String>[];
      final wrongAnswers = <String>[];
      for (int i = 3; i <= 6; i++) {
        final option = csvData[0][i]; // A B C D
        if (option == correctOption) {
          correctAnswers.add(row[i].toString()); // row[i] = Theoriticla res...
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

    return mcqs;
  }
}
