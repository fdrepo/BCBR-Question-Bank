import '../../app_state.dart';

List<String>? tagsList(AppState state) {
  return state.tags.tags?.toList();
}
