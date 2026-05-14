import '../entities/register_params.dart';
import '../entities/registered_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  Future<RegisteredUser> call(RegisterParams params) {
    return repository.register(params);
  }
}
