import '../entities/auth_session.dart';
import '../entities/login_params.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  const LoginUser(this.repository);

  Future<AuthSession> call(LoginParams params) {
    return repository.login(params);
  }
}
