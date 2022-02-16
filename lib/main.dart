import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
// import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'firebase_options.dart';
import 'repo/repo.dart';
import 'state/state.dart';
import 'state/reducers.dart';
import 'state/middleware.dart';
import 'view/auth_screen.dart';

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
