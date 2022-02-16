import 'package:freezed_annotation/freezed_annotation.dart';

import '../repos/auth/auth_state.dart';
part 'auth_actions.freezed.dart';
part 'auth_actions.g.dart';

@freezed
class AuthAction with _$AuthAction {
  // TODO: AuthAction.checkRepo

  const factory AuthAction.sendOtp(String phoneNumber) = AuthActionSendOtp;

  const factory AuthAction.verifyPhoneNumber(String smsCode) =
      AuthActionVerifyPhoneNumber;

  const factory AuthAction.setState(AuthState state) = AuthActionSetState;

  factory AuthAction.fromJson(Map<String, dynamic> json) =>
      _$AuthActionFromJson(json);
}
