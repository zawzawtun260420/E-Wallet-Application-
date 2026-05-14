import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/usecases/get_wallets.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWallets getWallets;

  WalletBloc({required this.getWallets}) : super(const WalletState.initial()) {
    on<WalletsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    WalletsRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading, clearError: true));

    try {
      final wallets = await getWallets();
      emit(state.copyWith(status: WalletStatus.success, wallets: wallets));
    } on ServerException catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
