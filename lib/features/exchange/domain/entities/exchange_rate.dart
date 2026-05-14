import 'package:equatable/equatable.dart';

class ExchangeRates extends Equatable {
  final Map<String, Map<String, double>> rates;

  const ExchangeRates({this.rates = const {}});

  double? rateFor(String from, String to) {
    if (from.isEmpty || to.isEmpty) return null;
    if (from == to) return 1.0;
    return rates[from]?[to];
  }

  bool get isEmpty => rates.isEmpty;

  @override
  List<Object?> get props => [rates];
}
