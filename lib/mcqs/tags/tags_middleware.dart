import 'package:redux/redux.dart';

import '../../app_state.dart';
import '../../repos/mcq_data_repo/mcq_data_repo.dart';
import 'tags_actions.dart';

class TagsMiddleware implements MiddlewareClass<AppState> {
  TagsMiddleware(this._repo);

  final McqDataRepo _repo;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is TagsActionsLoad) {
      store.dispatch(const TagsActions.loading());
      _repo.getTags().then((tags) {
        store.dispatch(TagsActions.loaded(tags));
      });
    }

    next(action);
  }
}
