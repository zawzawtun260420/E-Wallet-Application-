import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final String? userId;
  final String? email;
  final String? message;

  const AuthSession({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.userId,
    this.email,
    this.message,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        userId,
        email,
        message,
      ];
}
