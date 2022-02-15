import '../repos/auth/phone_auth_repo.dart';
import '../state/app_state.dart';
import 'auth_actions.dart';

AppState authReducer(AppState state, AuthAction action) {
  return action.map(
    verifyPhoneNumber: (_) => state,
    useOtp: (_) => state,
    resendCode: (_) => state,
    initial: (action) => _initial(state, action),
    awaitingCode: (action) => _awaitingCode(state, action),
    signingIn: (action) => _signingIn(state, action),
    authenticated: (action) => _authenticated(state, action),
    failure: (action) => _failure(state, action),
  );
}

AppState _initial(AppState state, AuthActionInitial action) {
  return state.copyWith(auth: AuthStatus.inital);
}

AppState _awaitingCode(AppState state, AuthActionAwaitingCode action) {
  return state.copyWith(auth: AuthStatus.awaitingCode);
}

AppState _signingIn(AppState state, AuthActionSigningIn action) {
  return state.copyWith(auth: AuthStatus.signingIn);
}

AppState _authenticated(AppState state, AuthActionAuthenticated action) {
  return state.copyWith(auth: AuthStatus.authenticated);
}

AppState _failure(AppState state, AuthActionFailure action) {
  return state.copyWith(auth: AuthStatus.failure);
}
