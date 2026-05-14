import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/register_params.dart';
import '../../../domain/entities/registered_user.dart';
import '../../../domain/usecases/register_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUser registerUser;

  RegisterBloc({required this.registerUser})
      : super(const RegisterState.initial()) {
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterReset>(_onReset);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearError: true));

    try {
      final user = await registerUser(
        RegisterParams(
          firstName: event.firstName,
          familyName: event.familyName,
          email: event.email,
          phone1: event.phone1,
          phone2: event.phone2,
          password: event.password,
          defaultCurrency: event.defaultCurrency,
          cfTurnstileToken: event.cfTurnstileToken,
        ),
      );
      emit(state.copyWith(status: RegisterStatus.success, user: user));
    } on ServerException catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onReset(RegisterReset event, Emitter<RegisterState> emit) {
    emit(const RegisterState.initial());
  }
}
