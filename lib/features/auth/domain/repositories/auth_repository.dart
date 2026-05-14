import '../entities/auth_session.dart';
import '../entities/login_params.dart';
import '../entities/register_params.dart';
import '../entities/registered_user.dart';

abstract class AuthRepository {
  Future<RegisteredUser> register(RegisterParams params);
  Future<AuthSession> login(LoginParams params);
}
