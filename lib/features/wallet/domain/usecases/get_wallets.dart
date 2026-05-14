import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWallets {
  final WalletRepository repository;

  const GetWallets(this.repository);

  Future<List<Wallet>> call() => repository.getWallets();
}
