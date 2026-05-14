import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/wallet_dto.dart';

class WalletRemoteDataSource {
  final Dio dio;

  const WalletRemoteDataSource(this.dio);

  Future<List<WalletDto>> getWallets() async {
    final response = await dio.get<dynamic>(ApiEndpoints.wallets);
    return _parseList(response.data);
  }

  List<WalletDto> _parseList(dynamic data) {
    final list = _extractList(data);
    return list
        .whereType<Map>()
        .map((e) => WalletDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      for (final key in const ['wallets', 'data', 'items', 'result', 'results']) {
        final v = data[key];
        if (v is List) return v;
        if (v is Map<String, dynamic>) {
          for (final inner in const ['wallets', 'data', 'items']) {
            final iv = v[inner];
            if (iv is List) return iv;
          }
        }
      }
    }
    return const [];
  }
}
