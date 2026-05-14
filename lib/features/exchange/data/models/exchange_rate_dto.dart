import '../../domain/entities/exchange_rate.dart';

class ExchangeRatesDto {
  final Map<String, Map<String, double>> rates;

  const ExchangeRatesDto({this.rates = const {}});

  factory ExchangeRatesDto.fromJson(Map<String, dynamic> json) {
    final raw = _extractRatesMap(json);
    final parsed = <String, Map<String, double>>{};
    raw.forEach((from, inner) {
      if (from is String && inner is Map) {
        final innerMap = <String, double>{};
        inner.forEach((to, value) {
          final d = _asDouble(value);
          if (to is String && d != null) innerMap[to] = d;
        });
        parsed[from] = innerMap;
      }
    });
    return ExchangeRatesDto(rates: parsed);
  }

  ExchangeRates toEntity() => ExchangeRates(rates: rates);

  static Map _extractRatesMap(Map<String, dynamic> json) {
    final direct = json['rates'];
    if (direct is Map) return direct;
    for (final key in const ['data', 'result']) {
      final v = json[key];
      if (v is Map<String, dynamic>) {
        final r = v['rates'];
        if (r is Map) return r;
        if (v.values.isNotEmpty && v.values.every((e) => e is Map)) {
          return v;
        }
      }
    }
    return const {};
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
