import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/registered_user.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final String? id;
  final String? email;
  final String? phone1;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'family_name')
  final String? familyName;

  final String? message;

  const RegisterResponse({
    this.id,
    this.email,
    this.phone1,
    this.firstName,
    this.familyName,
    this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  RegisteredUser toEntity() => RegisteredUser(
        id: id,
        email: email,
        phone: phone1,
        firstName: firstName,
        familyName: familyName,
        message: message,
      );
}
