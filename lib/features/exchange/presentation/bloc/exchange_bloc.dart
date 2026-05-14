import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/usecases/get_exchange_rate.dart';

part 'exchange_event.dart';
part 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetExchangeRates getExchangeRates;

  ExchangeBloc({required this.getExchangeRates})
      : super(const ExchangeState.initial()) {
    on<RatesRequested>(_onRatesRequested);
    on<SourceWalletSelected>(_onSourceWalletSelected);
    on<DestinationWalletSelected>(_onDestinationWalletSelected);
    on<SourceAmountChanged>(_onSourceAmountChanged);
    on<DestinationAmountChanged>(_onDestinationAmountChanged);
    on<WalletsSwapped>(_onWalletsSwapped);
  }

  Future<void> _onRatesRequested(
    RatesRequested event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(state.copyWith(rateStatus: RateStatus.loading, clearError: true));
    try {
      final rates = await getExchangeRates();
      emit(state.copyWith(
        ratesTable: rates,
        rateStatus: RateStatus.loaded,
        clearError: true,
      ));
      _resolvePair(emit);
    } on ServerException catch (e) {
      emit(state.copyWith(rateStatus: RateStatus.error, rateError: e.message));
    } on NetworkException catch (e) {
      emit(state.copyWith(rateStatus: RateStatus.error, rateError: e.message));
    } catch (e) {
      emit(state.copyWith(
        rateStatus: RateStatus.error,
        rateError: e.toString(),
      ));
    }
  }

  void _onSourceWalletSelected(
    SourceWalletSelected event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(
      sourceWallet: event.wallet,
      clearRate: true,
      clearError: true,
    ));
    _resolvePair(emit);
  }

  void _onDestinationWalletSelected(
    DestinationWalletSelected event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(
      destinationWallet: event.wallet,
      clearRate: true,
      clearError: true,
    ));
    _resolvePair(emit);
  }

  void _onSourceAmountChanged(
    SourceAmountChanged event,
    Emitter<ExchangeState> emit,
  ) {
    final src = event.amount;
    final rate = state.rate;
    final dst = (rate != null && rate > 0)
        ? _format(_parse(src) * rate)
        : state.destinationAmount;
    emit(state.copyWith(
      sourceAmount: src,
      destinationAmount: dst,
      lastEditedSide: AmountEditedSide.source,
    ));
  }

  void _onDestinationAmountChanged(
    DestinationAmountChanged event,
    Emitter<ExchangeState> emit,
  ) {
    final dst = event.amount;
    final rate = state.rate;
    final src = (rate != null && rate > 0)
        ? _format(_parse(dst) / rate)
        : state.sourceAmount;
    emit(state.copyWith(
      destinationAmount: dst,
      sourceAmount: src,
      lastEditedSide: AmountEditedSide.destination,
    ));
  }

  void _onWalletsSwapped(
    WalletsSwapped event,
    Emitter<ExchangeState> emit,
  ) {
    emit(state.copyWith(
      sourceWallet: state.destinationWallet,
      destinationWallet: state.sourceWallet,
      sourceAmount: state.destinationAmount,
      destinationAmount: state.sourceAmount,
      clearRate: true,
      clearError: true,
      lastEditedSide: state.lastEditedSide == AmountEditedSide.source
          ? AmountEditedSide.destination
          : AmountEditedSide.source,
    ));
    _resolvePair(emit);
  }

  void _resolvePair(Emitter<ExchangeState> emit) {
    final table = state.ratesTable;
    final from = _assetCode(state.sourceWallet);
    final to = _assetCode(state.destinationWallet);
    if (from == null || to == null || from.isEmpty || to.isEmpty) {
      return;
    }
    if (table == null) {
      return;
    }
    final rate = table.rateFor(from, to);
    if (rate == null || rate <= 0) {
      emit(state.copyWith(
        clearRate: true,
        rateError: 'Rate unavailable for $from → $to.',
      ));
      return;
    }
    emit(state.copyWith(rate: rate, clearError: true));
    _recomputeAfterRate(emit, rate);
  }

  void _recomputeAfterRate(Emitter<ExchangeState> emit, double rate) {
    if (state.lastEditedSide == AmountEditedSide.destination) {
      final dst = _parse(state.destinationAmount);
      if (dst > 0) {
        emit(state.copyWith(sourceAmount: _format(dst / rate)));
      }
    } else {
      final src = _parse(state.sourceAmount);
      if (src > 0) {
        emit(state.copyWith(destinationAmount: _format(src * rate)));
      }
    }
  }

  String? _assetCode(Wallet? w) {
    if (w == null) return null;
    final c = w.asset?.trim();
    if (c != null && c.isNotEmpty) return c;
    final s = w.symbol?.trim();
    if (s != null && s.isNotEmpty) return s;
    final t = w.type?.trim();
    if (t != null && t.isNotEmpty) return t;
    return w.id;
  }

  double _parse(String text) {
    if (text.isEmpty) return 0;
    return double.tryParse(text) ?? 0;
  }

  String _format(double value) {
    if (value == 0) return '';
    final s = value.toStringAsFixed(8);
    if (!s.contains('.')) return s;
    final trimmed = s.replaceFirst(RegExp(r'0+$'), '');
    return trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }
}
