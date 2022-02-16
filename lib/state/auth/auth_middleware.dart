import 'dart:async';

import 'package:redux/redux.dart';

import '../../repo/repo.dart';
import '../app_state/app_state.dart';
import 'auth_actions.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  PhoneAuthRepo? _repo;
  StreamSubscription<AuthStatus>? _sub;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is AuthActionVerifyPhoneNumber) {
      _verifyPhoneNumber(store, action);
    } else if (action is AuthActionUseOtp) {
      _useOtp(store, action);
    }
    next(action);
  }

  void _useOtp(Store<AppState> store, AuthActionUseOtp action) {
    var repo = _repo;
    if (repo == null) return;

    repo.verify(action.smsCode);
  }

  void _verifyPhoneNumber(
    Store<AppState> store,
    AuthActionVerifyPhoneNumber action,
  ) {
    var repo = _repo;
    if (repo != null) return;

    repo = FirebasePhoneAuthRepo(action.phoneNumber);
    _sub = repo.status.listen((status) {
      _dispatchAuthStatus(store, status);
    });

    _repo = repo..sendCode();
  }

  void _dispatchAuthStatus(Store<AppState> store, AuthStatus status) {
    late final AuthAction action;
    switch (status) {
      case AuthStatus.inital:
        action = const AuthAction.initial();
        break;
      case AuthStatus.awaitingCode:
        action = const AuthAction.awaitingCode();
        break;
      case AuthStatus.signingIn:
        action = const AuthAction.signingIn();
        break;
      case AuthStatus.authenticated:
        action = const AuthAction.authenticated();
        break;
      case AuthStatus.failure:
        action = const AuthAction.failure();
        break;
    }
    store.dispatch(action);
  }
}
