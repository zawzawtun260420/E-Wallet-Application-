// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      firstName: json['first_name'] as String,
      familyName: json['family_name'] as String,
      email: json['email'] as String,
      phone1: json['phone1'] as String,
      phone2: json['phone2'] as String,
      password: json['password'] as String,
      defaultCurrency: json['default_currency'] as String,
      cfTurnstileToken: json['cf_turnstile_token'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'family_name': instance.familyName,
      'email': instance.email,
      'phone1': instance.phone1,
      'phone2': instance.phone2,
      'password': instance.password,
      'default_currency': instance.defaultCurrency,
      'cf_turnstile_token': instance.cfTurnstileToken,
    };
