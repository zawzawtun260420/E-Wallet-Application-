import '../entities/exchange_rate.dart';

abstract class ExchangeRepository {
  Future<ExchangeRates> getRates();
}
