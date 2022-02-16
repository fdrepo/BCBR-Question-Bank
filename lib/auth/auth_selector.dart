import '../repos/auth/phone_auth_repo.dart';
import '../state/app_state.dart';

AuthStatus? authStatusSelector(AppState state) => state.auth.status;

Stream<void> authenticatedStreamSelected(Stream<AppState> stateStream) {
  return stateStream
      .map((state) => state.auth.status)
      .distinct()
      .where((status) => status == AuthStatus.authenticated);
}
