part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final AuthSession? session;
  final String? errorMessage;
  final int? statusCode;

  const LoginState({
    this.status = LoginStatus.initial,
    this.session,
    this.errorMessage,
    this.statusCode,
  });

  const LoginState.initial() : this();

  LoginState copyWith({
    LoginStatus? status,
    AuthSession? session,
    String? errorMessage,
    int? statusCode,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusCode: clearError ? null : (statusCode ?? this.statusCode),
    );
  }

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;

  @override
  List<Object?> get props => [status, session, errorMessage, statusCode];
}
