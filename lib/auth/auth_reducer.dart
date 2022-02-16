import '../state/app_state.dart';
import 'auth_actions.dart';

AppState authReducer(AppState state, AuthAction action) {
  return action.map(
    sendOtp: (_) => state,
    verifyPhoneNumber: (_) => state,
    setState: (action) => _setState(state, action),
  );
}

AppState _setState(AppState state, AuthActionSetState action) {
  return state.copyWith(auth: action.state);
}
