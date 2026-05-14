import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/login_params.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;

  final String password;

  @JsonKey(name: 'remember_me')
  final bool rememberMe;

  @JsonKey(name: 'grant_type')
  final String grantType;

  @JsonKey(name: 'cf_turnstile_token')
  final String cfTurnstileToken;

  const LoginRequest({
    required this.email,
    required this.password,
    required this.rememberMe,
    required this.grantType,
    required this.cfTurnstileToken,
  });

  factory LoginRequest.fromParams(LoginParams params) => LoginRequest(
        email: params.email,
        password: params.password,
        rememberMe: params.rememberMe,
        grantType: params.grantType,
        cfTurnstileToken: params.cfTurnstileToken,
      );

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
