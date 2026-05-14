// lib/models/wallet.dart
import 'dart:ui';

class Wallet {
  final String key;          // 'gold', 'silver', 'USD', 'retirement'...
  final String displayName;  // 'Gold', 'Retirement Fund'...
  final double amount;
  final String unit;         // 'oz', 'USD', 'SGD'
  final String type;         // 'metal' | 'fiat'
  final double? avgCost;
  final bool verified;
  final bool custom;
  final Color accentColor;   // top stripe color

  Wallet({
    required this.key,
    required this.displayName,
    required this.amount,
    required this.unit,
    required this.type,
    required this.accentColor,
    this.avgCost,
    this.verified = false,
    this.custom = false,
  });
}

class MarketRow {
  final String asset;
  final double bid;
  final double ask;
  final double changePct;
  final double high;
  final double low;
  MarketRow(this.asset, this.bid, this.ask, this.changePct, this.high, this.low);
}