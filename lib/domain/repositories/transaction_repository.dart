import 'package:dartz/dartz.dart';

import '../../commont/failure.dart';
import '../entities/cart.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> addTransaction(List<Cart> carts, int totalPrice, int pay);
  Future<Either<Failure, List<Transaction>>> getTransactions(DateTime startAt, DateTime endAt);
}