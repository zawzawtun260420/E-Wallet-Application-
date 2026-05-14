part of 'exchange_bloc.dart';

enum RateStatus { idle, loading, loaded, error }

enum AmountEditedSide { source, destination }

class ExchangeState extends Equatable {
  final Wallet? sourceWallet;
  final Wallet? destinationWallet;
  final String sourceAmount;
  final String destinationAmount;
  final ExchangeRates? ratesTable;
  final double? rate;
  final RateStatus rateStatus;
  final String? rateError;
  final AmountEditedSide lastEditedSide;

  const ExchangeState({
    this.sourceWallet,
    this.destinationWallet,
    this.sourceAmount = '',
    this.destinationAmount = '',
    this.ratesTable,
    this.rate,
    this.rateStatus = RateStatus.idle,
    this.rateError,
    this.lastEditedSide = AmountEditedSide.source,
  });

  const ExchangeState.initial() : this();

  ExchangeState copyWith({
    Wallet? sourceWallet,
    Wallet? destinationWallet,
    String? sourceAmount,
    String? destinationAmount,
    ExchangeRates? ratesTable,
    double? rate,
    RateStatus? rateStatus,
    String? rateError,
    AmountEditedSide? lastEditedSide,
    bool clearRate = false,
    bool clearError = false,
  }) {
    return ExchangeState(
      sourceWallet: sourceWallet ?? this.sourceWallet,
      destinationWallet: destinationWallet ?? this.destinationWallet,
      sourceAmount: sourceAmount ?? this.sourceAmount,
      destinationAmount: destinationAmount ?? this.destinationAmount,
      ratesTable: ratesTable ?? this.ratesTable,
      rate: clearRate ? null : (rate ?? this.rate),
      rateStatus: rateStatus ?? this.rateStatus,
      rateError: clearError ? null : (rateError ?? this.rateError),
      lastEditedSide: lastEditedSide ?? this.lastEditedSide,
    );
  }

  bool get isRateLoading => rateStatus == RateStatus.loading;
  bool get hasRate => rate != null && rate! > 0;

  @override
  List<Object?> get props => [
        sourceWallet,
        destinationWallet,
        sourceAmount,
        destinationAmount,
        ratesTable,
        rate,
        rateStatus,
        rateError,
        lastEditedSide,
      ];
}
