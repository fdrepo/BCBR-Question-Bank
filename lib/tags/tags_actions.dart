import 'package:freezed_annotation/freezed_annotation.dart';

import '../state/tags_state.dart';

part 'tags_actions.freezed.dart';
part 'tags_actions.g.dart';

@freezed
class TagsAction with _$TagsAction {
  const factory TagsAction.load() = TagsActionLoad;

  const factory TagsAction.loading() = TagsActionLoading;

  const factory TagsAction.loaded(Set<String> tags) = TagsActionLoaded;

  const factory TagsAction.failure(TagsFailure? failure) = TagsActionFailure;

  const factory TagsAction.selectView(TagsView view) = TagsActionSelectView;

  const factory TagsAction.startSearch() = TagsActionStartSearch;

  const factory TagsAction.stopSearch() = TagsActionStopSearch;

  const factory TagsAction.query(String query) = TagsActionQuery;

  factory TagsAction.fromJson(Map<String, dynamic> json) =>
      _$TagsActionFromJson(json);
}
