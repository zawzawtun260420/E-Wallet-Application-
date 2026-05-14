import '../entities/exchange_rate.dart';
import '../repositories/exchange_repository.dart';

class GetExchangeRates {
  final ExchangeRepository repository;

  const GetExchangeRates(this.repository);

  Future<ExchangeRates> call() => repository.getRates();
}
