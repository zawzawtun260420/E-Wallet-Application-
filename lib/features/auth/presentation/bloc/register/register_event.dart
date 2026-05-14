part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String firstName;
  final String familyName;
  final String email;
  final String phone1;
  final String password;
  final String phone2;
  final String defaultCurrency;
  final String cfTurnstileToken;

  const RegisterSubmitted({
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

class RegisterReset extends RegisterEvent {
  const RegisterReset();
}
