import '../../app_state.dart';
import '../quiz/quiz_state.dart';
import 'tags_actions.dart';
import 'tags_state.dart';

AppState tagsReducer(AppState state, TagsActions action) {
  return action.map(
    loading: (action) => _loading(state, action),
    loaded: (action) => _loaded(state, action),
    load: (_) => state,
  );
}

AppState _loading(AppState state, TagsActionLoading action) {
  return state.copyWith(
    tags: TagsState.initial(),
    quiz: QuizState.initial(),
  );
}

AppState _loaded(AppState state, TagsActionLoaded action) {
  return state.copyWith(
    tags: TagsState(action.tags),
    quiz: QuizState.initial(),
  );
}
