import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
// import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'auth/auth_actions.dart';
import 'auth/auth_middleware.dart';
import 'auth/auth_reducer.dart';
import 'auth/auth_screen.dart';
import 'firebase_options.dart';
import 'state/app_state.dart';
import 'quiz/quiz_actions.dart';
import 'quiz/quiz_middleware.dart';
import 'quiz/quiz_reducer.dart';
import 'tags/tags_actions.dart';
import 'tags/tags_middleware.dart';
import 'tags/tags_reducer.dart';
// import 'tags/tags_screen.dart';
import 'repos/mcq_data_repo/csv_mcq_data_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final repo = CsvMcqDataRepo();
  // final remoteDevTools = RemoteDevToolsMiddleware<AppState>('192.168.1.9:8000');

  final store = Store<AppState>(
    combineReducers<AppState>([
      TypedReducer<AppState, TagsAction>(tagsReducer),
      TypedReducer<AppState, QuizActions>(quizReducer),
      TypedReducer<AppState, AuthAction>(authReducer),
    ]),
    initialState: AppState.initial(),
    middleware: [
      TagsMiddleware(repo),
      QuizMiddleware(repo: repo, mcqsCount: 10),
      AuthMiddleware(),
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
        home: const AuthScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.grey.shade200),
      ),
    );
  }
}
