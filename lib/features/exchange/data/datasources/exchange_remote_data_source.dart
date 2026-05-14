import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/exchange_rate_dto.dart';

class ExchangeRemoteDataSource {
  final Dio dio;

  const ExchangeRemoteDataSource(this.dio);

  Future<ExchangeRatesDto> getRates() async {
    final response = await dio.get<dynamic>(ApiEndpoints.exchangeRates);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ExchangeRatesDto.fromJson(data);
    }
    return const ExchangeRatesDto();
  }
}
