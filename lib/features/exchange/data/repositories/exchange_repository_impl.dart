import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_data_source.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  const ExchangeRepositoryImpl(this.remoteDataSource);

  @override
  Future<ExchangeRates> getRates() async {
    try {
      final dto = await remoteDataSource.getRates();
      return dto.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Exception _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        return ServerException(
          _extractMessage(e.response?.data) ?? 'Server returned an error.',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return NetworkException(e.message ?? 'Unexpected network error.');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final m = data['message'] ?? data['error'] ?? data['detail'];
      if (m is String) return m;
      if (m is Map<String, dynamic>) {
        final em = m['error_message'] ?? m['message'];
        if (em is String) return em;
      }
      if (m is List && m.isNotEmpty) return m.first.toString();
    }
    return null;
  }
}
