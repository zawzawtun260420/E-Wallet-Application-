// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phone1: json['phone1'] as String?,
      firstName: json['first_name'] as String?,
      familyName: json['family_name'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone1': instance.phone1,
      'first_name': instance.firstName,
      'family_name': instance.familyName,
      'message': instance.message,
    };
