import 'package:freezed_annotation/freezed_annotation.dart';

part 'tags_state.freezed.dart';
part 'tags_state.g.dart';

@freezed
class TagsState with _$TagsState {
  const factory TagsState(Set<String>? tags) = _TagsState;

  factory TagsState.initial() => const TagsState(null);

  factory TagsState.fromJson(Map<String, dynamic> json) =>
      _$TagsStateFromJson(json);
}
