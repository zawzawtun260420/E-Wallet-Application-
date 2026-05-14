import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<List<Wallet>> getWallets();
}
