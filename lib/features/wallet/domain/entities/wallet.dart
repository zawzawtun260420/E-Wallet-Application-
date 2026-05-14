import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String? id;
  final String? name;
  final String? asset;
  final String? symbol;
  final double? balance;
  final String? address;
  final String? type;

  const Wallet({
    this.id,
    this.name,
    this.asset,
    this.symbol,
    this.balance,
    this.address,
    this.type,
  });

  @override
  List<Object?> get props =>
      [id, name, asset, symbol, balance, address, type];
}
