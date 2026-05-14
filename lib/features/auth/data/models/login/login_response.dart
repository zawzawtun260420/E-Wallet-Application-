import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_session.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'token_type')
  final String? tokenType;

  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  @JsonKey(name: 'user_id')
  final String? userId;

  final String? email;
  final String? message;

  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.userId,
    this.email,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json['result'] is Map<String, dynamic>
            ? json['result'] as Map<String, dynamic>
            : json);
    return _$LoginResponseFromJson(inner);
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  AuthSession toEntity() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
        expiresIn: expiresIn,
        userId: userId,
        email: email,
        message: message,
      );
}
