import '../../features/auth/domain/entities/auth_session.dart';

class AuthSessionStorage {
  AuthSessionStorage._();

  static final AuthSessionStorage instance = AuthSessionStorage._();

  AuthSession? _session;

  AuthSession? get session => _session;
  String? get accessToken => _session?.accessToken;

  void save(AuthSession session) {
    _session = session;
  }

  void clear() {
    _session = null;
  }
}
