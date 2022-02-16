import 'package:redux/redux.dart';

import '../../repo/repo.dart';
import '../app_state/app_state.dart';
import 'tags_actions.dart';

class TagsMiddleware implements MiddlewareClass<AppState> {
  TagsMiddleware(this._repo);

  final McqDataRepo _repo;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is TagsActionLoad) {
      _load(store, action);
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
