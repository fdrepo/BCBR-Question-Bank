import 'dart:async';

import 'package:redux/redux.dart';

import '../repos/auth/firebase_phone_auth_repo.dart';
import '../repos/auth/phone_auth_repo.dart';
import '../state/app_state.dart';
import 'auth_actions.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  PhoneAuthRepo? _repo;
  StreamSubscription<AuthState>? _sub;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is AuthActionSendOtp) {
      _sendOtp(store, action);
    } else if (action is AuthActionVerifyPhoneNumber) {
      _verifyPhoneNumber(store, action);
    }
    next(action);
  }

  void _verifyPhoneNumber(
    Store<AppState> store,
    AuthActionVerifyPhoneNumber action,
  ) {
    var repo = _repo;
    if (repo == null) return;

    repo.verify(action.smsCode);
  }

  void _sendOtp(Store<AppState> store, AuthActionSendOtp action) {
    var repo = _repo;
    if (repo != null) return;

    repo = FirebasePhoneAuthRepo(action.phoneNumber);
    _sub = repo.state.listen((state) {
      _dispatchAuthStatus(store, state);
    });

    _repo = repo..sendCode();
  }

  void _dispatchAuthStatus(Store<AppState> store, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      _sub?.cancel();
      _sub = null;
      _repo = null;
    }
    store.dispatch(AuthAction.setState(state));
  }
}
