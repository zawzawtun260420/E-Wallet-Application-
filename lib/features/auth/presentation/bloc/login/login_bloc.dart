import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/entities/login_params.dart';
import '../../../domain/usecases/login_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;

  LoginBloc({required this.loginUser}) : super(const LoginState.initial()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginReset>(_onReset);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    try {
      final session = await loginUser(
        LoginParams(
          email: event.email,
          password: event.password,
          rememberMe: event.rememberMe,
          grantType: event.grantType,
          cfTurnstileToken: event.cfTurnstileToken,
        ),
      );
      emit(state.copyWith(status: LoginStatus.success, session: session));
    } on ServerException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState.initial());
  }
}
