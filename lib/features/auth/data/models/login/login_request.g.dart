// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['remember_me'] as bool,
      grantType: json['grant_type'] as String,
      cfTurnstileToken: json['cf_turnstile_token'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'remember_me': instance.rememberMe,
      'grant_type': instance.grantType,
      'cf_turnstile_token': instance.cfTurnstileToken,
    };
