part of 'exchange_bloc.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object?> get props => const [];
}

class RatesRequested extends ExchangeEvent {
  const RatesRequested();
}

class SourceWalletSelected extends ExchangeEvent {
  final Wallet wallet;
  const SourceWalletSelected(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class DestinationWalletSelected extends ExchangeEvent {
  final Wallet wallet;
  const DestinationWalletSelected(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class SourceAmountChanged extends ExchangeEvent {
  final String amount;
  const SourceAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class DestinationAmountChanged extends ExchangeEvent {
  final String amount;
  const DestinationAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class WalletsSwapped extends ExchangeEvent {
  const WalletsSwapped();
}
