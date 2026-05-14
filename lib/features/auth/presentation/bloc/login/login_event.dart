part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;
  final String grantType;
  final String cfTurnstileToken;

  const LoginSubmitted({
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.grantType = 'password',
    this.cfTurnstileToken = '',
  });

  @override
  List<Object?> get props => [
        email,
        password,
        rememberMe,
        grantType,
        cfTurnstileToken,
      ];
}

class LoginReset extends LoginEvent {
  const LoginReset();
}
