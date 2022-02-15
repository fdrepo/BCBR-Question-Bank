import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'phone_auth_repo.dart';

class FirebasePhoneAuthRepo extends PhoneAuthRepo {
  FirebasePhoneAuthRepo(String phoneNumber) : super(phoneNumber);

  final _controller = StreamController<AuthStatus>();

  @override
  Stream<AuthStatus> get status => _controller.stream;

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
    _controller.sink.add(AuthStatus.inital);
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
      _controller.add(AuthStatus.authenticated);
      print(userCredential.user?.uid);
    });
    _controller.sink.add(AuthStatus.signingIn);
  }

  void _verificationFailed(FirebaseAuthException exception) {
    print(exception);
    _controller.sink.add(AuthStatus.failure);
  }

  void _codeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    _resendToken = resendToken;
    _controller.sink.add(AuthStatus.awaitingCode);
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
  }
}
