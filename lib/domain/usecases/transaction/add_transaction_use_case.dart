import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/transaction_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/cart.dart';
import '../../entities/transaction.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, Transaction>> execute(List<Cart> carts, int totalPrice, int pay) {
    return repository.addTransaction(carts, totalPrice, pay);
  }
}