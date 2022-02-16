import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

enum AuthStatus { initial, awaitingCode, signingIn, authenticated, failure }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    required String uid,
    required String phoneNumber,
  }) = _AuthState;

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      uid: '',
      phoneNumber: '',
    );
  }

  factory AuthState.initialWithStatus(AuthStatus status) {
    return AuthState.initial().copyWith(status: status);
  }

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
