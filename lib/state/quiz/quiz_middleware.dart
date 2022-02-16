import 'package:redux/redux.dart';

import '../../repo/repo.dart';
import '../app_state/app_state.dart';
import 'quiz_actions.dart';

class QuizMiddleware extends MiddlewareClass<AppState> {
  QuizMiddleware({required this.repo, required this.mcqsCount});

  final McqDataRepo repo;
  final int mcqsCount;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is QuizActionsLoadMcqs) {
      final selectedTag = action.tag;
      store.dispatch(const QuizActions.loadingMcqs());
      repo.getMcqs(selectedTag, mcqsCount).then((mcqs) {
        store.dispatch(QuizActions.loadedMcqs(selectedTag, mcqs));
      });
    }
    next(action);
  }
}
