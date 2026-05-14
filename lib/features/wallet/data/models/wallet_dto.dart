import '../../domain/entities/wallet.dart';

class WalletDto {
  final String? id;
  final String? name;
  final String? asset;
  final String? symbol;
  final double? balance;
  final String? address;
  final String? type;

  const WalletDto({
    this.id,
    this.name,
    this.asset,
    this.symbol,
    this.balance,
    this.address,
    this.type,
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) {
    return WalletDto(
      id: _asString(json['id'] ?? json['_id'] ?? json['wallet_id']),
      name: _asString(json['name'] ?? json['wallet_name'] ?? json['label']),
      asset: _asString(
        json['asset'] ?? json['asset'] ?? json['code'],
      ),
      symbol: _asString(json['symbol'] ?? json['currency_symbol']),
      balance: _asDouble(
        json['balance'] ?? json['amount'] ?? json['available_balance'],
      ),
      address: _asString(json['address'] ?? json['wallet_address']),
      type: _asString(json['type'] ?? json['wallet_type']),
    );
  }

  Wallet toEntity() => Wallet(
        id: id,
        name: name,
        asset: asset,
        symbol: symbol,
        balance: balance,
        address: address,
        type: type,
      );

  static String? _asString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
