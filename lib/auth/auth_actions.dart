import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_actions.freezed.dart';
part 'auth_actions.g.dart';

@freezed
class AuthAction with _$AuthAction {
  const factory AuthAction.verifyPhoneNumber(String phoneNumber) =
      AuthActionVerifyPhoneNumber;

  const factory AuthAction.useOtp(String smsCode) = AuthActionUseOtp;

  const factory AuthAction.initial() = AuthActionInitial;

  const factory AuthAction.awaitingCode() = AuthActionAwaitingCode;

  const factory AuthAction.resendCode() = AuthActionResendCode;

  const factory AuthAction.signingIn() = AuthActionSigningIn;

  const factory AuthAction.authenticated() = AuthActionAuthenticated;

  const factory AuthAction.failure() = AuthActionFailure;

  factory AuthAction.fromJson(Map<String, dynamic> json) =>
      _$AuthActionFromJson(json);
}
