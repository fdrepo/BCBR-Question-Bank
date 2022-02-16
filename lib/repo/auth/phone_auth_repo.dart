import 'dart:async';

enum AuthStatus { inital, awaitingCode, signingIn, authenticated, failure }

abstract class PhoneAuthRepo {
  PhoneAuthRepo(this.phoneNumber);

  String phoneNumber;

  Stream<AuthStatus> get status;

  void sendCode();

  bool resendCode();

  bool verify(String smsCode);
}
