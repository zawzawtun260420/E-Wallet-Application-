part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final RegisteredUser? user;
  final String? errorMessage;
  final int? statusCode;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.errorMessage,
    this.statusCode,
  });

  const RegisterState.initial() : this();

  RegisterState copyWith({
    RegisterStatus? status,
    RegisteredUser? user,
    String? errorMessage,
    int? statusCode,
    bool clearError = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusCode: clearError ? null : (statusCode ?? this.statusCode),
    );
  }

  bool get isLoading => status == RegisterStatus.loading;
  bool get isSuccess => status == RegisterStatus.success;
  bool get isFailure => status == RegisterStatus.failure;

  @override
  List<Object?> get props => [status, user, errorMessage, statusCode];
}
