import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  const WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Wallet>> getWallets() async {
    try {
      final dtos = await remoteDataSource.getWallets();
      return dtos.map((e) => e.toEntity()).toList();
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
      if (m is List && m.isNotEmpty) return m.first.toString();
    }
    return null;
  }
}
