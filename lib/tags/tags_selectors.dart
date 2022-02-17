import '../state/app_state.dart';
import '../state/tags_state.dart';

class FilteredTagsView {
  FilteredTagsView({
    required this.hasError,
    required this.failure,
    required this.tags,
    required this.view,
  });

  final bool hasError;
  final TagsFailure? failure;
  final List<String>? tags;
  final TagsView view;
}

FilteredTagsView filteredTagsViewSelector(AppState state) {
  final tags = state.tags;
  bool hasError = tags.status == TagsStatus.failure;

  final query = tags.query.toLowerCase();

  bool search = tags.status == TagsStatus.search;
  final tagsSet = tags.tags;
  final tagsList = tagsSet != null && search
      ? tagsSet.where((t) {
          return t.toLowerCase().contains(query);
        }).toList()
      : tagsSet?.toList();

  return FilteredTagsView(
    hasError: hasError,
    failure: tags.failure,
    tags: tagsList,
    view: tags.view,
  );
}

class TagsAppBarOptions {
  TagsAppBarOptions({
    required this.isSearchEnabled,
    required this.canSearch,
    required this.query,
    required this.view,
  });

  final bool isSearchEnabled;
  final bool canSearch;
  final String query;
  final TagsView view;
}

TagsAppBarOptions tagsAppBarOptionsSelector(AppState state) {
  final tags = state.tags;
  final isSearchEnabled = tags.status == TagsStatus.search;
  return TagsAppBarOptions(
    isSearchEnabled: isSearchEnabled,
    canSearch: isSearchEnabled ||
        (tags.status == TagsStatus.load && tags.tags != null),
    query: tags.query,
    view: tags.view,
  );
}
