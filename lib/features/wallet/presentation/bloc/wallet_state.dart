part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletStatus status;
  final List<Wallet> wallets;
  final String? errorMessage;
  final int? statusCode;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallets = const [],
    this.errorMessage,
    this.statusCode,
  });

  const WalletState.initial() : this();

  WalletState copyWith({
    WalletStatus? status,
    List<Wallet>? wallets,
    String? errorMessage,
    int? statusCode,
    bool clearError = false,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusCode: clearError ? null : (statusCode ?? this.statusCode),
    );
  }

  bool get isLoading => status == WalletStatus.loading;
  bool get isSuccess => status == WalletStatus.success;
  bool get isFailure => status == WalletStatus.failure;

  @override
  List<Object?> get props => [status, wallets, errorMessage, statusCode];
}
