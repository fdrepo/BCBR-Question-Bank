import 'package:freezed_annotation/freezed_annotation.dart';

part 'tags_state.freezed.dart';
part 'tags_state.g.dart';

enum TagsStatus {
  /// Initiate loading.
  initial,

  /// The tags have been retrieved / are being retrived.
  load,

  /// Oops! an error has occured.
  failure,

  /// Search mode. It's assumed that the only way to get here is after [load].
  search,
}

enum TagsFailure {
  /// No internet.
  disconnected,
}

enum TagsView { list, grid }

@freezed
class TagsState with _$TagsState {
  const factory TagsState({
    required TagsStatus status,

    /// When [status] is [TagsStatus.failure], the type of failure can be
    /// checked here. `null` imples The cause of failure is unknown.
    required TagsFailure? failure,

    /// When [status] is [TagsStatus.load], `null` value imples the tags are
    /// being retrieved.
    required Set<String>? tags,
    required TagsView view,

    // The text entered during search.
    required String query,
  }) = _TagsState;

  factory TagsState.initial() {
    return const TagsState(
      status: TagsStatus.initial,
      failure: null,
      tags: null,
      view: TagsView.list,
      query: '',
    );
  }

  factory TagsState.fromJson(Map<String, dynamic> json) =>
      _$TagsStateFromJson(json);
}
