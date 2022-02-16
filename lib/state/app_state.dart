import 'package:freezed_annotation/freezed_annotation.dart';

import '../repos/auth/auth_state.dart';
import 'quiz_state.dart';
import 'tags_state.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    required AuthState auth,
    required TagsState tags,
    required QuizState quiz,
  }) = _AppState;

  factory AppState.initial(AuthState authState) => AppState(
        auth: authState,
        tags: TagsState.initial(),
        quiz: QuizState.initial(),
      );

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
