import '../app_state/app_state.dart';
import 'tags_actions.dart';

AppState tagsReducer(AppState state, TagsAction action) {
  return action.map(
    load: (_) => state,
    loading: (action) => _loading(state, action),
    loaded: (action) => _loaded(state, action),
    selectView: (action) => _selectView(state, action),
    startSearch: (action) => _startSearch(state, action),
    stopSearch: (action) => _stopSearch(state, action),
    query: (action) => _query(state, action),
    failure: (action) => _failure(state, action),
  );
}

AppState _loading(AppState state, TagsActionLoading action) {
  return state.copyWith(
    tags: state.tags.copyWith(tags: null, status: TagsStatus.load),
    quiz: QuizState.initial(),
  );
}

AppState _loaded(AppState state, TagsActionLoaded action) {
  return state.copyWith(
    tags: state.tags.copyWith(tags: action.tags, status: TagsStatus.load),
    quiz: QuizState.initial(),
  );
}

AppState _selectView(AppState state, TagsActionSelectView action) {
  return state.copyWith(tags: state.tags.copyWith(view: action.view));
}

AppState _startSearch(AppState state, TagsActionStartSearch action) {
  return state.copyWith(
    tags: state.tags.copyWith(
      status: TagsStatus.search,
      query: '',
    ),
  );
}

AppState _stopSearch(AppState state, TagsActionStopSearch action) {
  return state.copyWith(
    tags: state.tags.copyWith(
      status: TagsStatus.load,
      query: '',
    ),
  );
}

AppState _query(AppState state, TagsActionQuery action) {
  return state.copyWith(tags: state.tags.copyWith(query: action.query));
}

AppState _failure(AppState state, TagsActionFailure action) {
  return state.copyWith(
    tags: state.tags.copyWith(
      status: TagsStatus.failure,
      failure: action.failure,
      tags: null,
    ),
  );
}
