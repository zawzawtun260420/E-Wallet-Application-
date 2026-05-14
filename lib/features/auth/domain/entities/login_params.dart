import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final String grantType;
  final String cfTurnstileToken;

  const LoginParams({
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
