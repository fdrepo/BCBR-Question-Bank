import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../mcq.dart';
import 'mcq_data_repo.dart';

class CsvMcqDataRepo extends MCQDataRepo {
  @override
  Future<List<MCQ>> getMCQs() async {
    final rawCsvFile = await rootBundle
        .loadString('assets/data.csv'); // From assets assign file
    final csvData =
        const CsvToListConverter().convert(rawCsvFile); // List of rows from csv

    final mcqs = <MCQ>[]; // Empty array to Add MCQ Object

// Get each MCQ out of csv , Assign tags, questions, correct ans and wrong ans.
// 1 Loops List of rows > 2 Loops single row > Put MCQs Fields to MCQ Object
    for (final row in csvData.sublist(1)) {
      // 1 loop
      final correctOptions = row[7] as String;
      final correctAnswers = <String>[];
      final wrongAnswers = <String>[];
      for (int i = 3; i <= 6; i++) {
        // 2 n-loop
        final option = csvData[0][i]; // A B C D
        if (option == correctOptions) {
          correctAnswers.add(row[i].toString()); // row[i]
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
