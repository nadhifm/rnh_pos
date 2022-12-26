import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rnh_pos/commont/failure.dart';
import 'package:rnh_pos/data/datasources/transaction_remote_data_source.dart';
import 'package:rnh_pos/data/models/cart_model.dart';
import 'package:rnh_pos/data/models/transaction_model.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/repositories/transaction_repository.dart';

import '../../commont/exception.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Transaction>> addTransaction(
    List<Cart> carts,
    int totalPrice,
    int pay,
  ) async {
    try {
      final result = await remoteDataSource.addTransaction(
        TransactionModel(
          id: "",
          date: DateTime.now(),
          totalPrice: totalPrice,
          pay: pay,
          change: pay - totalPrice,
          carts: carts
              .map(
                (cart) => CartModel(
                  id: cart.id,
                  name: cart.name,
                  price: cart.price,
                  quantity: cart.quantity,
                ),
              )
              .toList(),
        ),
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(DateTime startAt, DateTime endAt) async {
    try {
      final result = await remoteDataSource.getTransactions(startAt, endAt);
      return Right(result.map((c) => c.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
