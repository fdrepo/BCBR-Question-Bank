import '../state/app_state.dart';
import 'quiz_actions.dart';
import '../state/quiz_state.dart';

AppState quizReducer(AppState state, QuizActions action) {
  return action.map(
    loadMcqs: (_) => state,
    loadingMcqs: (action) => _loadingMcqs(state, action),
    loadedMcqs: (action) => _loadedMcqs(state, action),
    select: (action) => _select(state, action),
    submit: (action) => _submit(state, action),
    nextMcq: (action) => _nextMcq(state, action),
  );
}


}
