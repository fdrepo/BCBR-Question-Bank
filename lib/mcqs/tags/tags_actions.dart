import 'package:freezed_annotation/freezed_annotation.dart';

part 'tags_actions.freezed.dart';

@freezed
class TagsActions with _$TagsActions {
  const factory TagsActions.load() = TagsActionsLoad;
  const factory TagsActions.loading() = TagsActionLoading;
  const factory TagsActions.loaded(Set<String> tags) = TagsActionLoaded;
}
