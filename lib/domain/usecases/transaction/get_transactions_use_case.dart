import 'package:dartz/dartz.dart';
import 'package:rnh_pos/domain/repositories/transaction_repository.dart';

import '../../../commont/failure.dart';
import '../../entities/cart.dart';
import '../../entities/transaction.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<Transaction>>> execute(DateTime startAt, DateTime endAt) {
    return repository.getTransactions(startAt, endAt);
  }
}