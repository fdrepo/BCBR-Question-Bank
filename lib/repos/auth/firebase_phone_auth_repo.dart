import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'phone_auth_repo.dart';

class FirebasePhoneAuthRepo extends PhoneAuthRepo {
  FirebasePhoneAuthRepo(String phoneNumber) : super(phoneNumber);

  final _controller = StreamController<AuthState>();

  @override
  Stream<AuthState> get state => _controller.stream;

  String? _verificationId;
  int? _resendToken;

  @override
  void sendCode() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
    _controller.sink.add(AuthState.initial());
  }

  @override
  bool verify(String smsCode) {
    final verificationId = _verificationId;
    if (verificationId == null) return false;

    _verificationCompleted(
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      ),
    );
    return true;
  }

  @override
  bool resendCode() {
    final resendToken = _resendToken;
    if (resendToken == null) return false;

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      forceResendingToken: resendToken,
    );
    return true;
  }

  void _verificationCompleted(PhoneAuthCredential credential) {
    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((userCredential) {
      _controller.add(AuthState(
        status: AuthStatus.authenticated,
        phoneNumber: phoneNumber,
        uid: userCredential.user!.uid,
      ));
    });
    _controller.add(AuthState.initialWithStatus(AuthStatus.signingIn));
  }

  void _verificationFailed(FirebaseAuthException exception) {
    _controller.add(AuthState.initialWithStatus(AuthStatus.failure));
  }

  void _codeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    _resendToken = resendToken;
    _controller.add(AuthState.initialWithStatus(AuthStatus.awaitingCode));
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
  }
}
