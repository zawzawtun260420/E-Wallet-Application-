import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/register_params.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'family_name')
  final String familyName;

  final String email;

  final String phone1;

  final String phone2;

  final String password;

  @JsonKey(name: 'default_currency')
  final String defaultCurrency;

  @JsonKey(name: 'cf_turnstile_token')
  final String cfTurnstileToken;

  const RegisterRequest({
    required this.firstName,
    required this.familyName,
    required this.email,
    required this.phone1,
    required this.phone2,
    required this.password,
    required this.defaultCurrency,
    required this.cfTurnstileToken,
  });

  factory RegisterRequest.fromParams(RegisterParams params) => RegisterRequest(
        firstName: params.firstName,
        familyName: params.familyName,
        email: params.email,
        phone1: params.phone1,
        phone2: params.phone2,
        password: params.password,
        defaultCurrency: params.defaultCurrency,
        cfTurnstileToken: params.cfTurnstileToken,
      );

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
