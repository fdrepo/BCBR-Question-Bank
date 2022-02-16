import 'dart:async';

import 'auth_state.dart';

export 'auth_state.dart';

abstract class PhoneAuthRepo {
  PhoneAuthRepo(this.phoneNumber);

  String phoneNumber;

  Stream<AuthState> get state;

  void sendCode();

  bool resendCode();

  bool verify(String smsCode);
}
