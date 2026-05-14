import 'package:equatable/equatable.dart';

class RegisteredUser extends Equatable {
  final String? id;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? familyName;
  final String? message;

  const RegisteredUser({
    this.id,
    this.email,
    this.phone,
    this.firstName,
    this.familyName,
    this.message,
  });

  @override
  List<Object?> get props => [id, email, phone, firstName, familyName, message];
}
