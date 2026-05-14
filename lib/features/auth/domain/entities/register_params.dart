import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String firstName;
  final String familyName;
  final String email;
  final String phone1;
  final String phone2;
  final String password;
  final String defaultCurrency;
  final String cfTurnstileToken;

  const RegisterParams({
    required this.firstName,
    required this.familyName,
    required this.email,
    required this.phone1,
    required this.password,
    this.phone2 = '',
    this.defaultCurrency = 'SGD',
    this.cfTurnstileToken = '',
  });

  @override
  List<Object?> get props => [
        firstName,
        familyName,
        email,
        phone1,
        phone2,
        password,
        defaultCurrency,
        cfTurnstileToken,
      ];
}
