import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
// import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'app_state.dart';
import 'mcqs/quiz/quiz_actions.dart';
import 'mcqs/quiz/quiz_middleware.dart';
import 'mcqs/quiz/quiz_reducer.dart';
import 'mcqs/tags/tags_actions.dart';
import 'mcqs/tags/tags_middleware.dart';
import 'mcqs/tags/tags_reducer.dart';
import 'mcqs/tags/tags_screen.dart';
import 'repos/mcq_data_repo/csv_mcq_data_repo.dart';

Future<void> main() async {
  final repo = CsvMcqDataRepo();
  // final remoteDevTools = RemoteDevToolsMiddleware('localhost:8000');

  final store = Store<AppState>(
    combineReducers<AppState>([
      TypedReducer<AppState, TagsActions>(tagsReducer),
      TypedReducer<AppState, QuizActions>(quizReducer),
    ]),
    initialState: AppState.initial(),
    middleware: [
      TagsMiddleware(repo),
      QuizMiddleware(repo: repo, mcqsCount: 10),
      // remoteDevTools,
    ],
  );

  // remoteDevTools.store = store;
  // await (remoteDevTools.connect()).timeout(const Duration(seconds: 10));

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        home: const TagsScreen(),
        theme: ThemeData(scaffoldBackgroundColor: Colors.grey.shade200),
      ),
    );
  }
}
