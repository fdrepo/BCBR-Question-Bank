import 'package:redux/redux.dart';

import '../state/app_state.dart';
import '../repos/mcq_data_repo/mcq_data_repo.dart';
import 'tags_actions.dart';

class Middleware implements MiddlewareClass<AppState> {
  
  Middleware({required this.repo,required this.mcqsCount});

  final McqDataRepo repo;
  final int mcqsCount;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {

    if (action is TagsActionLoad) {
      _load(store, action);
    }
    if (action is QuizActionsLoadMcqs) {
      final selectedTag = action.tag;
      store.dispatch(const QuizActions.loadingMcqs());
      repo.getMcqs(selectedTag, mcqsCount).then((mcqs) {
        store.dispatch(QuizActions.loadedMcqs(selectedTag, mcqs));
      });
    }
    next(action);
  }

  Future<void> _load(Store<AppState> store, TagsActionLoad action) async {
    store.dispatch(const TagsAction.loading());
    try {
      final tags = await _repo.getTags();
      store.dispatch(TagsAction.loaded(tags));
    } catch (_) {
      // TODO(navan33th): error handling.
    }
  }
  

}



